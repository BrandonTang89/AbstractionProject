# =====================================================================
# Verification of the combinational aspect of the CAM via automatic indexing transformation
# Doesn't use the efficient preimage computation
# Makes use of symbolic constants
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

source ../juliaAutoAbstract/simulate.tcl
source ../juliaAutoAbstract/utils.tcl
source ../CommonUtils_Brandon/autoabstraction_helpers_brandon.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
source ../CommonUtils_Brandon/helpers.tcl
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
set input_ticks [list 2]
set ant_query [create_dual_rail_antecedent query [list 2]]

set ant_mem [list]
for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
    set ant [create_dual_rail_antecedent "mem\[$i\]" [list 2]]
    puts $ant
    set ant_mem [merge_dual_rail_antecedents $ant_mem $ant]
}

set antv [merge_dual_rail_antecedents $ant_query $ant_mem]
set bdd_variables [get_dual_rail_antecedent_variable_names $ant_mem] 
set query_variables [get_dual_rail_antecedent_variable_names $ant_query]

# === Create indexing relation ===
# set partition_abstraction [autoabstract spec.assert_next_hit_signal [VAR t0] [NOT [VAR t0]]]
set abstraction_time [time {
    set partition_abstraction [autoabstract next_hit [VAR t_0] [NOT [VAR t_0]] $query_variables]
} $TEST_ITERATIONS ]

set transform_time [time {
    set index_rel [combine_abstractions $partition_abstraction]
    set transformed_ant_stimuli [strong_preimage_stim $antv $index_rel $bdd_variables]
} $TEST_ITERATIONS ]


# Check coverage
set coverage [getCoverage $index_rel $bdd_variables]
assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

# check_symsim -expression -depends $index_rel 
# PR $index_rel

# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
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
check_symsim -sequence $eval_seq -get [list next_hit] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

set check_time [time {
    set prop_high [weak_preimage $index_rel [TRUE] $bdd_variables] 
    set prop_low [weak_preimage $index_rel [FALSE] $bdd_variables]

    # check_symsim -expression -depends $prop_high
    # PR $prop_high
    # PR $prop_low

    check_properties_against_sim $properties $eval_seq $prop_high $prop_low
}  $TEST_ITERATIONS ]

# === Timing Information ===
puts "Automatic Indexing of the CAM with Partitioned Abstraction"
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