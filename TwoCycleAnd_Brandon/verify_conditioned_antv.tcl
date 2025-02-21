# ===== Symbolic Simulation with Indexing Transformations =====
# Environmental Constraints via Conditioned Antecedent and Output Constraint

clear -all
source ../CommonUtils_Brandon/symsim_utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
source ../CommonUtils_Brandon/autoabstraction_helpers_brandon.tcl
analyze -sv and_2_cycles.sv
analyze -sva and_2_cycle_spec_mod.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

namespace import symsim::*
set_symsim_expr_pretty_print_threshold 300

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]

# == Set up property to check ==
set properties [dict create \
    spec.and_correct 6 \
    spec.special_case 6 \
]

set max_property_tick [max_dict_values $properties]

# === Set up Stimuli ===
# Create initial un-abstracted stimuli
set input_ticks [list 2 4]
set antv [merge_dual_rail_antecedent \
    [create_dual_rail_antecedent a $input_ticks] \
    [create_dual_rail_antecedent b $input_ticks] \
    [create_dual_rail_antecedent c $input_ticks] \  
]
set bdd_variables [get_dual_rail_antecedent_variable_names $antv]

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

#identity relation
set index_rel [AND\
    [XNOR [VAR a@2] [VAR a2] ]\
    [XNOR [VAR b@2] [VAR b2] ]\
    [XNOR [VAR c@2] [VAR c2] ]\
    [XNOR [VAR a@4] [VAR a4] ]\
    [XNOR [VAR b@4] [VAR b4] ]\
    [XNOR [VAR c@4] [VAR c4] ]\
]

set index_rel [check_symsim -expression -canonize $index_rel]
PR $index_rel

# === Construct Input Constraints ===
# Here we assume the input constraint that 
# ((a@2 AND b@2) = (a@2 AND c@2)) AND ((a@4 AND b@4) = (a@4 AND c@4))
# this is equivalent to
# ((a@2 AND b@2) XNOR (a@2 AND c@2)) AND ((a@4 AND b@4) XNOR (a@4 AND c@4))

set input_constraint [AND \
    [XNOR [AND [VAR a@2] [VAR b@2]] [AND [VAR a@2] [VAR c@2]]] \
    [XNOR [AND [VAR a@4] [VAR b@4]] [AND [VAR a@4] [VAR c@4]]] \
]

PR $input_constraint

# Check Coverage
# For using parametric encoding, we should cover all parameterised variables T'
set coverage [satisfiesCoverage $index_rel $bdd_variables "" $input_constraint]
assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

# === Indexing Transformation ===


set conditioned_antv [condition_antv $antv $input_constraint]
set transformed_ant_stimuli [strong_preimage_stim $conditioned_antv $index_rel $bdd_variables]

# === Run the symbolic simulation ===
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
check_symsim -sequence $eval_seq -get [list a b c o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
# ## Specifically note that we restrict the requirements for the property to hold to the input constraint being true
set prop_low [weak_preimage $index_rel [FALSE] $bdd_variables]  
set prop_high [weak_preimage $index_rel $input_constraint $bdd_variables] 

PR $prop_high
PR $prop_low

check_properties_against_sim $properties $eval_seq $prop_high $prop_low