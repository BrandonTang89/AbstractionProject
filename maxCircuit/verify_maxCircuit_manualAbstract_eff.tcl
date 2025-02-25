# =====================================================================
# Verification of the MaxCircuit via a Indexing Transformation with a manually created indexing relation
# =====================================================================
set DATA_WIDTH 5; # log d
set ADDR_WIDTH 2; # log n
set DATA_LENGTH [expr 2**$DATA_WIDTH]
set NUM_ENTRIES [expr 2**$ADDR_WIDTH]
set TEST_ITERATIONS 1

unset -nocomplain memo
clear -all
analyze -sv maxCircuit.sv
analyze -sva maxCircuitSpec.sva
analyze -sv maxCircuitBind.sv
elaborate -top max_circuit_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
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
    spec.assert_contained 2 \
    spec.assert_bounds 2
]

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
set input_ticks [list 2]
set ant_ins_list [list]
for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
    set ant [create_dual_rail_antecedent "ins\[$i\]" [list 2]]
    set ant_mem_list [lappend ant_ins_list $ant]
}
set ant_ins [eval merge_dual_rail_antecedents $ant_ins_list]

set antv $ant_ins
set bdd_variables [get_dual_rail_antecedent_variable_names $antv]

# === Create indexing relation === 
# Returns the binary representation of a number, where num = sum (output[i] * 2**i) for i in 0 to numBits-1
set DWPlus1 [expr $DATA_WIDTH + 1]

proc get_binary_rep {numBits num} {
    set binaryRep [list]
    for {set i 0} {$i < $numBits} {incr i} {
        lappend binaryRep [expr ($num >> $i) & 1]
    }
    return $binaryRep
}

proc s_eq {x} {
    global ADDR_WIDTH
    set xrep [get_binary_rep $ADDR_WIDTH $x]
    set conjunct [TRUE]
    for {set j 0} {$j < $ADDR_WIDTH} {incr j} {
        if {[lindex $xrep $j] == 0} {
            set conjunct [AND $conjunct [NOT [VAR s\[$j\]]]]
        } else {
            set conjunct [AND $conjunct [VAR s\[$j\]]]
        }
    }
    return $conjunct    
}

proc d_i_eq {i x} {
    global DWPlus1
    set xrep [get_binary_rep $DWPlus1 $x]
    set conjunct [TRUE]
    for {set j 0} {$j < $DWPlus1} {incr j} {
        if {[lindex $xrep $j] == 0} {
            set conjunct [AND $conjunct [NOT [VAR d\[$i\]\[$j\]]]]
        } else {
            set conjunct [AND $conjunct [VAR d\[$i\]\[$j\]]]
        }
    }
    return $conjunct
}

proc d_i_ge_rec {i xrep j} {
    if {$j == 0} { # base case
       if {[lindex $xrep $j] == 0} {
           return [TRUE]
       } else {
           return [VAR d\[$i\]\[$j\]]
       }
    }
    # either d[i][j] = 1 and x[j] = 0 OR (recurse)
    if {[lindex $xrep $j] == 0} {
        return [OR [VAR d\[$i\]\[$j\]] [d_i_ge_rec $i $xrep [expr $j - 1]]]
    } else {
        return [AND [VAR d\[$i\]\[$j\]] [d_i_ge_rec $i $xrep [expr $j - 1]]]
    }
}

proc d_i_ge {i x} {
    global DWPlus1
    global DATA_WIDTH
    set xrep [get_binary_rep $DWPlus1 $x]
    return [d_i_ge_rec $i $xrep $DATA_WIDTH]
}

## At least one d[i] = D
proc any_di_eq_D {} {
    global NUM_ENTRIES
    global DATA_LENGTH
    set disjunction [FALSE]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        set disjunction [OR $disjunction [d_i_eq $i $DATA_LENGTH]]
    }
    return [list [list $disjunction [TRUE] [FALSE]]]
}

## Most signficant bits of entry are same
proc make_top_bits_same_i_j {i j} {
    global DATA_LENGTH
    # D - j <= d[i] implies ins[i][j] = t[j]
    set premise [d_i_ge $i [expr $DATA_LENGTH - $j]]
    return [list [VAR ins\[$i\]\[$j\]]\
                 [AND $premise [VAR t\[$j\]]]\
                 [AND $premise [NOT [VAR t\[$j\]]]]
            ]
}

proc make_top_bits_same {} {
    global NUM_ENTRIES
    global DATA_LENGTH
    set partitioned_abstraction [list]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        for {set j 0} {$j < $DATA_LENGTH} {incr j} {
            lappend partitioned_abstraction [make_top_bits_same_i_j $i $j]
        }
    }    
    return $partitioned_abstraction
}

## Make critical bit smaller
proc make_critical_bit_smaller_i_j {i j} {
    global DATA_LENGTH
    # d[i] = D - 1 - j implies ins[i][j] AND t[j] = 1
    set premise [d_i_eq $i [expr $DATA_LENGTH - 1 - $j]]
    return [list \
        [list [VAR ins\[$i\]\[$j\]] [FALSE] $premise]\
        [list [VAR t\[$j\]] $premise [FALSE]]
    ]
}

proc make_critical_bit_smaller {} {
    global NUM_ENTRIES
    global DATA_LENGTH
    set partitioned_abstraction [list]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        for {set j 0} {$j < $DATA_LENGTH} {incr j} {
            set tuples [make_critical_bit_smaller_i_j $i $j]
            lappend partitioned_abstraction [lindex $tuples 0]
            lappend partitioned_abstraction [lindex $tuples 1]
        }
    }    
    return $partitioned_abstraction
}

# Set BDD ordering to put Ts in front of the Ds (not clear if this is relevant)
# set bdd_ordering [list]
# for {set i 0} {$i < $DATA_WIDTH} {incr i} {
#     lappend bdd_ordering "t\[$i\]"
# }
# for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
#     for {set j 0} {$j < $DATA_WIDTH} {incr j} {
#         lappend bdd_ordering "d\[$i\]\[$j\]"
#     }
# }
# check_symsim -var_order -set $bdd_ordering

# === Abstraction ===
puts "Abstracting..."
set abstraction_time [time {
    set partition_abstraction [
        flatten [list [any_di_eq_D] [make_top_bits_same] [make_critical_bit_smaller]]
    ]
} $TEST_ITERATIONS ]

# Combine partitioned abstraction
# set index_rel [combine_abstractions $partition_abstraction]
# check_symsim -expression -depends $index_rel
# PR $index_rel

# Check coverage
# set coverage [satisfiesCoveragePartitioned $partition_abstraction $bdd_variables]
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

puts "Evaluating..."
set eval_time [time {
    # Create a sequence from tranformed stimuli
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
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
set check_time [time {
    set prop_high $dom
    set prop_low [FALSE]

    # check_symsim -expression -depends $prop_high
    # PR $prop_high
    # PR $prop_low
    check_properties_against_sim $properties $eval_seq $prop_high $prop_low
}  $TEST_ITERATIONS ]

# === Timing Information ===
puts "Manual Indexing of the MaxCircuit with Partitioned Abstraction"
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