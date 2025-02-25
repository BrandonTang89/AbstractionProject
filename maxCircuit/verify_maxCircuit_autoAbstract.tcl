# =====================================================================
# Verification of the MaxCircuit via a Indexing Transformation with a manually created indexing relation
# =====================================================================
# set DATA_WIDTH 2; # log d
# set ADDR_WIDTH 1; # log n
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

puts "Abstracting..."
set abstraction_time [time {
    # set partition_abstraction [autoabstract spec.found [VAR t_0] [NOT [VAR t_0]]]
    set partition_abstraction [autoabstract spec.boundsInput [VAR t_0] [NOT [VAR t_0]]]

} $TEST_ITERATIONS ]

# Combine partitioned abstraction
# set index_rel [combine_abstractions $partition_abstraction]
# check_symsim -expression -depends $index_rel
# PR $index_rel

# Check coverage
set coverage [satisfiesCoveragePartitioned $partition_abstraction $bdd_variables]
assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

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
puts "Automatic Indexing of the MaxCircuit with Partitioned Abstraction"
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