# WORK IN PROGRESS
set DATA_WIDTH 2; # d
set ADDR_WIDTH 2; # log n
set numEntries [expr 2**$ADDR_WIDTH]

clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top -loop_limit 100000
clock -both_edges clk
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
namespace import symsim::*
set_symsim_expr_pretty_print_threshold 300

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
set signals [check_symsim -model $model_id -list signal]

# == Set up property to check ==
set properties [dict create \
    spec.assert_hit_signal 4 \
]

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
set input_ticks [list 2]
set ant_query [create_dual_rail_antecedent query [list 2]]
set ant_trigger [create_dual_rail_antecedent trigger [list 2]]

set ant_mem [list]
for {set i 0} {$i < $numEntries} {incr i} {
    set ant [create_dual_rail_antecedent "mem\[$i\]" [list 2]]
    puts $ant
    set ant_mem [merge_dual_rail_antecedent $ant_mem $ant]
}

set antv [merge_dual_rail_antecedents $ant_query $ant_trigger $ant_mem]

# puts [get_dual_rail_antecedent_variable_names $antv]

set bdd_variables [get_dual_rail_antecedent_variable_names $antv]


# === Create indexing relation === 
# TODO: Deal with trigger signal as well
# Our indexing relation should cover the following cases
# - query is in the CAM at entry 1, 2, ..., n
# - query is not the the CAM, i.e. each entry is different from the query

# we have 1 variable for whether the query is in the cam or not, h
# NOT h -> [
#   AND_(i<-0 to num_entries) (
#       OR j<-0 to DATA_WIDTH (query@2[j] != mem[i]@2[j]))
#   )
#]

# h -> [
#  OR_(i<-0 to num_entries) (
#      AND j<-0 to DATA_WIDTH (query@2[j] == mem[i]@2[j])) 
#  )
#]

# the case where the entry is in the CAM requires (log n) boolean variables to select the entry that matches the query
# these will be denoted as ch[i] for i in 0 until log n
# the case where the entry is not in the CAM requires (n log d) boolean variables such that for each entry, we select the mismatched bit
# denote as em[entry][j] for j in 0 until log d

# Returns the binary representation of a number, where num = sum (output[i] * 2**i) for i in 0 to numBits-1
proc get_binary_rep {numBits num} {
    set binaryRep [list]
    for {set i 0} {$i < $numBits} {incr i} {
        lappend binaryRep [expr ($num >> $i) & 1]
    }
    return $binaryRep
}

## CAM HIT
# When {ch_i} = entry, we should have query == mem[entry]
proc make_entry_hit {entry} {
    global DATA_WIDTH
    global ADDR_WIDTH
    # when the ch_i bits that correspond to the entry are set, the entry is hit
    # outcome: query[i] == mem[entry][i] for all i in 0 to DATA_WIDTH
    set premise [TRUE]
    set entry_binary [get_binary_rep $ADDR_WIDTH $entry]
    for {set i 0} {$i < $ADDR_WIDTH} {incr i} {
        if {[lindex $entry_binary $i] == 0} {
            set premise [AND $premise [NOT [VAR ch\[$i\]]]]
        } else {
            set premise [AND $premise [VAR ch\[$i\]]]
        }
    }

    set outcome [TRUE]
    for {set i 0} {$i < $DATA_WIDTH} {incr i} {
        set outcome [AND $outcome [XNOR [VAR query\[$i\]] [VAR mem\[$entry\]\[$i\]]]]
    }

    return [IMPLIES $premise $outcome]
}

proc all_em_false {} {
    global numEntries
    global DATA_WIDTH
    set conjunct [TRUE]
    for {set i 0} {$i < $numEntries} {incr i} {
        for {set j 0} {$j < $DATA_WIDTH} {incr j} {
            set conjunct [AND $conjunct [NOT [VAR em\[$i\]\[$j\]]]]
        }
    }
    return $conjunct
}

proc make_cam_hit {} {
    global numEntries
    set conjunct [TRUE]
    for {set i 0} {$i < $numEntries} {incr i} {
        set conjunct [AND $conjunct [make_entry_hit $i]]
    }
    return [AND [all_em_false] $conjunct]
}


## CAM MISS
proc make_index_at_entry_miss {entry index} {
    global DATA_WIDTH
    global ADDR_WIDTH
    # (em_entry = index) -> query[index] != mem[entry][index]
    set index_binary [get_binary_rep $DATA_WIDTH $index]
    set premise [TRUE]
    for {set i 0} {$i < $ADDR_WIDTH} {incr i} {
        if {[lindex $index_binary $i] == 0} {
            set premise [AND $premise [NOT [VAR em\[$entry\]\[$i\]]]]
        } else {
            set premise [AND $premise [VAR em\[$entry\]\[$i\]]]
        }
    }
    set outcome [XOR [VAR query\[$index\]] [VAR mem\[$entry\]\[$index\]]]
    return [IMPLIES $premise $outcome]
}

proc make_entry_miss {entry} {
    global DATA_WIDTH
    set conjunct [TRUE]
    for {set i 0} {$i < $DATA_WIDTH} {incr i} {
        set conjunct [AND $conjunct [make_index_at_entry_miss $entry $i]]
    }
    return $conjunct
}

proc all_ch_false {} {
    global ADDR_WIDTH
    set conjunct [TRUE]
    for {set i 0} {$i < $ADDR_WIDTH} {incr i} {
        set conjunct [AND $conjunct [NOT [VAR ch\[$i\]]]]
    }
    return $conjunct
}

proc make_cam_miss {} {
    global numEntries
    set conjunct [TRUE]
    for {set i 0} {$i < $numEntries} {incr i} {
        set conjunct [AND $conjunct [make_entry_miss $i]]
    }
    return [AND [all_ch_false] $conjunct]
}

set index_rel [AND [IMPLIES [VAR h] [make_cam_hit]] [IMPLIES [NOT [VAR h]] [make_cam_miss]]]


check_symsim -expression -depends $index_rel
PR $index_rel


# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
set transformed_ant_stimuli [strong_preimage_stim $antv $index_rel $bdd_variables]

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

# Visualise the simulation
# Here we can manually inspect to see the value of o (at tick 6) but we need to figure out if this is actually correct
check_symsim -sequence $eval_seq -get [list hit] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
# set prop_high [strong_preimage $index_rel [TRUE] $bdd_variables] 
# set prop_low [strong_preimage $index_rel [FALSE] $bdd_variables]

# PR $prop_high
# PR $prop_low

# check_properties_against_sim $properties $eval_seq $prop_high $prop_low