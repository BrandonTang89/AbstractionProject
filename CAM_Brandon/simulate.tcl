# WORK IN PROGRESS
set DATA_WIDTH 2;
set ADDR_WIDTH 2;
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
set_symsim_expr_pretty_print_threshold 30

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

# === Create indexing relation === 
# set p [VAR p]
# set q [VAR q]
# set r [VAR r]

# set index_rel [AND \
#     [IMPLIES [AND $p $q $r] [AND [VAR a@2] [VAR b@2] [VAR c@2] [VAR a@4] [VAR b@4] [VAR c@4]]] \
#     [IMPLIES [AND $p $q [NOT $r]] [NOT [VAR a@2]]] \
#     [IMPLIES [AND $p [NOT $q] $r] [NOT [VAR b@2]]] \
#     [IMPLIES [AND [NOT $p] $q $r] [NOT [VAR c@2]]] \
#     [IMPLIES [AND [NOT $p] [NOT $q] $r] [NOT [VAR a@4]]] \
#     [IMPLIES [AND [NOT $p] $q [NOT $r]] [NOT [VAR b@4]]] \
#     [IMPLIES [AND $p [NOT $q] [NOT $r]] [NOT [VAR c@4]]] \
#     [OR $p $q $r]\
# ]

# set index_rel [check_symsim -expression -canonize $index_rel]

# # Check that the indexing relation is as expected
# check_symsim -expression -depends $index_rel
# PR $index_rel

# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
# set transformed_ant_stimuli [strong_preimage_stim $stimuli_dict $index_rel $bdd_variables]

# Create a sequence from tranformed stimuli
# set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]

set antecedent_seq [check_symsim -sequence -create $antv -name my_sequence]
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