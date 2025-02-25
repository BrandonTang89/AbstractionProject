# =====================================================================
# Verification of the CAM via a Indexing Transformation with a manually created indexing relation
# This creates a partitioned abstraction relation that can be used with the efficient preimage algorithm
# Includes Timing
# Sets query as a symbolic constant
# =====================================================================
set DATA_WIDTH 2; # log d
set ADDR_WIDTH 2; # log n
set TEST_ITERATIONS 1

set DATA_LENGTH [expr 2**$DATA_WIDTH]
set NUM_ENTRIES [expr 2**$ADDR_WIDTH]

unset -nocomplain memo
clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
clock -both_edges clk
reset -none

source ../juliaAutoAbstract/utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
source ../CommonUtils_Brandon/autoabstraction_helpers_brandon.tcl
set_symsim_expr_pretty_print_threshold 3000

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
set signals [check_symsim -model $model_id -list signal]

# == Set up property to check ==
set properties [dict create \
    spec.assert_hit 4 \
    spec.assert_next_hit 2 \
]

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
# We don't need to stimulate on tick 4, leave it as Xs
set input_ticks [list 2]
set ant_query [create_dual_rail_antecedent query [list 2]]

set ant_mem_list [list]
for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
    set ant [create_dual_rail_antecedent "mem\[$i\]" [list 2]]
    set ant_mem_list [lappend ant_mem_list $ant]
    puts $ant_mem_list
    puts "MEOWW \n"
}

set ant_mem [eval merge_dual_rail_antecedents $ant_mem_list]

set antv [merge_dual_rail_antecedents $ant_query $ant_mem]
set query_variables [get_dual_rail_antecedent_variable_names $ant_query]
set bdd_variables [get_dual_rail_antecedent_variable_names $ant_mem]

# === Create indexing relation === 
# Returns the binary representation of a number, where num = sum (output[i] * 2**i) for i in 0 to numBits-1
proc get_binary_rep {numBits num} {
    set binaryRep [list]
    for {set i 0} {$i < $numBits} {incr i} {
        lappend binaryRep [expr ($num >> $i) & 1]
    }
    return $binaryRep
}

## CAM HIT
proc make_entry_hit {entry} {
    # When {ch} = binary_rep(entry), we should have tagin == mem[entry]
    global DATA_LENGTH
    global ADDR_WIDTH
    # premise: when the ch_i bits that correspond to the entry are set, that entry is hit
    # outcome: query[i] == mem[entry][i] for all i in 0 to DATA_LENGTH
    set premise [VAR h]
    set entry_binary [get_binary_rep $ADDR_WIDTH $entry]
    for {set i 0} {$i < $ADDR_WIDTH} {incr i} {
        if {[lindex $entry_binary $i] == 0} {
            set premise [AND $premise [NOT [VAR ch\[$i\]]]]
        } else {
            set premise [AND $premise [VAR ch\[$i\]]]
        }
    }

    set partitioned_out [list]
    for {set i 0} {$i < $DATA_LENGTH} {incr i} {
        lappend partitioned_out [list [VAR mem\[$entry\]\[$i\]] \
                                      [AND $premise [VAR query\[$i\]]]\
                                      [AND $premise [NOT [VAR query\[$i\]]]]]
    }

    return $partitioned_out
}


proc make_cam_hit {} {
    global NUM_ENTRIES
    
    set partitioned_out [list]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        lappend partitioned_out [make_entry_hit $i]
    }

    set partitioned_out [flatten $partitioned_out]
    return $partitioned_out
}


## CAM MISS
proc make_index_at_entry_miss {entry index} {
    global DATA_LENGTH
    global ADDR_WIDTH
    global DATA_WIDTH
    # (em_entry = index) -> query[index] != mem[entry][index]
    set index_binary [get_binary_rep $DATA_WIDTH $index]
    set premise [NOT [VAR h]]
    for {set i 0} {$i < $DATA_WIDTH} {incr i} {
        if {[lindex $index_binary $i] == 0} {
            set premise [AND $premise [NOT [VAR em\[$entry\]\[$i\]]]]
        } else {
            set premise [AND $premise [VAR em\[$entry\]\[$i\]]]
        }
    }

    return [list [list [VAR mem\[$entry\]\[$index\]] \
                 [AND $premise [NOT [VAR query\[$index\]]]]\
                 [AND $premise [VAR query\[$index\]]]
            ]]
    # set outcome [XOR [VAR tagin\[$index\]] [VAR mem\[$entry\]\[$index\]]]
}

proc make_entry_miss {entry} {
    global DATA_LENGTH
    set conjunct [TRUE]

    set partitioned_out [list]
    for {set i 0} {$i < $DATA_LENGTH} {incr i} {
        lappend partitioned_out [make_index_at_entry_miss $entry $i]
    }

    set partitioned_out [flatten $partitioned_out]
    return $partitioned_out
}

proc make_cam_miss {} {
    global NUM_ENTRIES

    set partitioned_out [list]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        lappend partitioned_out [make_entry_miss $i]
    }

    set partitioned_out [flatten $partitioned_out]
    return $partitioned_out
}

puts "Abstracting..."
set abstraction_time [time {
    set partition_abstraction [
        flatten [list [make_cam_hit] [make_cam_miss]]
    ]
} $TEST_ITERATIONS ]

# set index_rel [combine_abstractions $partition_abstraction]
# check_symsim -expression -depends $index_rel
# PR $index_rel

# Check coverage
# set coverage [satisfiesCoveragePartitioned $partition_abstraction $bdd_variables $query_variables]
# assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

puts "Transforming..."
set transform_time [time {
    set normal_abstraction [normalise_abstraction $partition_abstraction $bdd_variables]
    set abstraction_S [lindex $normal_abstraction 0]
    set abstraction_T [lindex $normal_abstraction 1]
    set dom [get_domain $abstraction_S $abstraction_T]

    # === Indexing Transformation ===
    # Apply the indexing transformation to the stimuli
    set transformed_ant_stimuli [strong_preimage_stim_part $antv $abstraction_T $dom $bdd_variables]
} $TEST_ITERATIONS ]

# Create a sequence from tranformed stimuli
puts "Evaluating..."
set eval_time [time {
    set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
    set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

    # Run the symbolic simulation
    set num_ticks [expr $max_property_tick + 2]
    set eval_out [check_symsim  -eval $model_id \
                                -resolved_sequence $resolved_seq_id \
                                -start_tick 1 \
                                -num_ticks $num_ticks \
                                -init_states false\
                                -canonize on]

    set eval_seq [dict get $eval_out sequence_id]
} $TEST_ITERATIONS ]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list hit] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
puts "Checking properties"
set check_time [time {
    set prop_high $dom
    set prop_low [FALSE]

    # check_symsim -expression -depends $prop_high
    # PR $prop_high
    # PR $prop_low
    check_properties_against_sim $properties $eval_seq $prop_high $prop_low
}  $TEST_ITERATIONS ]

# === Timing Information ===
puts "Manual Indexing of the CAM with Partitioned Abstraction"
puts "Time taken for Abstraction: $abstraction_time"
puts "Time taken for Transformation: $transform_time"
puts "Time taken for Evaluation: $eval_time"
puts "Time taken for Checking: $check_time"

puts "Total Time: [expr {[lindex $abstraction_time 0] \
                        + [lindex $transform_time 0] \
                        + [lindex $eval_time 0] \
                        + [lindex $check_time 0]}]"

puts "NUM_ENTRIES: $NUM_ENTRIES"
puts "DATA_LENGTH: $DATA_LENGTH"