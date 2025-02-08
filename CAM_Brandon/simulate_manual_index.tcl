# =====================================================================
# Verification of the CAM via a Indexing Transformation with a manually created indexing relation
# Suppose that the CAM has n entries with d bits each
# - We let ADDR_WIDTH = log n, DATA_WIDTH = log d
# 
# We use a similar indexing relation to that shown in https://dl.acm.org/doi/pdf/10.1145/266021.266056
# 
# Our indexing relation should cover the following cases
# - query is in the CAM at entry 1, 2, ..., n
# - query is not the the CAM, i.e. each entry is different from the query
#
# For reference, the following are our target variables:
# - query[0..d-1] : the query
# - mem[0..n-1][0..d-1] : the entries in the CAM
#
# We create d indexing variables to represent the query
#   {tagin[0..d-1]}
# we have 1 variable for whether the query is in the cam or not,
#   {h}
# We have ADDR_WIDTH variables for selecting which entry in the CAM is the query (for the case where the CAM is hit) 
#   {ch[0..ADDR_WIDTH-1]}
# We have n * DATA_WIDTH variables for selecting which bit in each entry is different from the query (for the case where the CAM is missed) 
#   {em[0..n-1][0..DATA_WIDTH-1]}
# 
# This takes O(d + n log d + log n) variables, (logarithmically in d) less than the O(n * d) variables that would be required to represent the entire CAM
#
# Our indexing relation is thus of the form
#
# query[i] == tagin[i] for i in 0 to DATA_LENGTH
#
# &&
#
# h -> [
#  AND (i<-0 to n) (
#     (i == ch) -> [AND j<-0 to DATA_LENGTH (query[j] == mem[i][j]))] 
#  )
# ]
#
# && 
#
# NOT h -> [
#   AND_(i<-0 to n) (
#       AND (j<-0 to DATA_LENGTH) (
#           (em[i] == j) -> (tagin[j] != mem[i][j])
#       )
#   )
# ]
#
# =====================================================================
set DATA_WIDTH 1; # log d
set ADDR_WIDTH 2; # log n
set DATA_LENGTH [expr 2**$DATA_WIDTH]
set NUM_ENTRIES [expr 2**$ADDR_WIDTH]

clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
clock -both_edges clk
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
namespace import symsim::*
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

set ant_mem [list]
for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
    set ant [create_dual_rail_antecedent "mem\[$i\]" [list 2]]
    puts $ant
    set ant_mem [merge_dual_rail_antecedent $ant_mem $ant]
}

set antv [merge_dual_rail_antecedents $ant_query $ant_mem]
set bdd_variables [get_dual_rail_antecedent_variable_names $antv]

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
    for {set i 0} {$i < $DATA_LENGTH} {incr i} {
        set outcome [AND $outcome [XNOR [VAR tagin\[$i\]] [VAR mem\[$entry\]\[$i\]]]]
    }

    return [IMPLIES $premise $outcome]
}


proc make_cam_hit {} {
    global NUM_ENTRIES
    set conjunct [TRUE]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        set conjunct [AND $conjunct [make_entry_hit $i]]
    }
    return $conjunct
}


## CAM MISS
proc make_index_at_entry_miss {entry index} {
    global DATA_LENGTH
    global ADDR_WIDTH
    global DATA_WIDTH
    # (em_entry = index) -> query[index] != mem[entry][index]
    set index_binary [get_binary_rep $DATA_WIDTH $index]
    set premise [TRUE]
    for {set i 0} {$i < $DATA_WIDTH} {incr i} {
        if {[lindex $index_binary $i] == 0} {
            set premise [AND $premise [NOT [VAR em\[$entry\]\[$i\]]]]
        } else {
            set premise [AND $premise [VAR em\[$entry\]\[$i\]]]
        }
    }
    set outcome [XOR [VAR tagin\[$index\]] [VAR mem\[$entry\]\[$index\]]]
    return [IMPLIES $premise $outcome]
}

proc make_entry_miss {entry} {
    global DATA_LENGTH
    set conjunct [TRUE]

    # Add all the implications for causing the entry to miss
    for {set i 0} {$i < $DATA_LENGTH} {incr i} {
        set conjunct [AND $conjunct [make_index_at_entry_miss $entry $i]]
    }

    return $conjunct
}

proc make_cam_miss {} {
    global NUM_ENTRIES
    set conjunct [TRUE]
    for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
        set conjunct [AND $conjunct [make_entry_miss $i]]
    }
    return $conjunct
}

proc make_query_tagin {} {
    # ensures that tagin == query
    global DATA_LENGTH

    set conjunct [TRUE]
    for {set i 0} {$i < $DATA_LENGTH} {incr i} {
        set conjunct [AND $conjunct [XNOR [VAR tagin\[$i\]] [VAR query\[$i\]]]]
    }
    return $conjunct
}

set index_rel [AND [IMPLIES [VAR h] [make_cam_hit]] [IMPLIES [NOT [VAR h]] [make_cam_miss]] [make_query_tagin]]

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
set prop_high [weak_preimage $index_rel [TRUE] $bdd_variables] 
set prop_low [weak_preimage $index_rel [FALSE] $bdd_variables]


check_symsim -expression -depends $prop_high
PR $prop_high
PR $prop_low

check_properties_against_sim $properties $eval_seq $prop_high $prop_low
check_symsim -expression -get_canonical $prop_high

# Sanity Checks
# Observe that hit is high if and only if h is true, this is expected from our indexing relation
# We can inspect the transformed antv to see that the query is exactly the same as the tagin