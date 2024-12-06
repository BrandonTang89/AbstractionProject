# ===== Symbolic Simulation with Indexing Transformations =====
# This script runs a symbolic simulation with an indexing transformation and input constraints

clear -all
source ../CommonUtils_Brandon/symsim_utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
analyze -sv and_2_cycles.sv
analyze -sva and_2_cycle_spec.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

namespace import symsim::*
set_symsim_expr_pretty_print_threshold 30

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]

# === Set up for a symbolic simulation ===
set inputs [list a b c]
set input_ticks [list 2 4]
set bdd_variables [create_bdd_variables $inputs $input_ticks]
set stimuli_dict [create_stimuli_dict $inputs $bdd_variables]

# === Create indexing relation === 
set p [VAR p]
set q [VAR q]
set r [VAR r]

set index_rel [AND \
    [IMPLIES [AND $p $q $r] [AND [VAR a@2] [VAR b@2] [VAR c@2] [VAR a@4] [VAR b@4] [VAR c@4]]] \
    [IMPLIES [AND $p $q [NOT $r]] [NOT [VAR a@2]]] \
    [IMPLIES [AND $p [NOT $q] $r] [NOT [VAR b@2]]] \
    [IMPLIES [AND [NOT $p] $q $r] [NOT [VAR c@2]]] \
    [IMPLIES [AND [NOT $p] [NOT $q] $r] [NOT [VAR a@4]]] \
    [IMPLIES [AND [NOT $p] $q [NOT $r]] [NOT [VAR b@4]]] \
    [IMPLIES [AND $p [NOT $q] [NOT $r]] [NOT [VAR c@4]]] \
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

# === Parameterise away the input constraint ===
# Here we are fine with parameterising away all the variables
set param_output [check_symsim -param -expressions [list $input_constraint] -exclude_symbols [list]]
set param_res [dict get $param_output param_res]

# TODO: figure out what is_sat_exprs really is
assert [expr {[dict get $param_res is_sat_exprs] == 1}] "Parameterisation failed"

set param_substitutions [lindex [dict get $param_res symb_subst] 0]
proc rename_param_phase_0 {exp} {return [rename_param_variables $exp 0]}

# We rename the substituted variables 
set param_subs_renamed [dict_map $param_substitutions rename_param_phase_0]

# == Apply parameterisation to the Antecedent and Indexing Relation ==
set stimuli_paramed [apply_substitution_stim $stimuli_dict $param_subs_renamed]
set index_rel_paramed [check_symsim -expression -substitute $index_rel $param_subs_renamed]


# === Indexing Transformation ===
set transformed_ant_stimuli [strong_preimage_stim $stimuli_paramed $index_rel_paramed $bdd_variables]

# Comparing this with the ThreeWayAndGate_correct.fl transformed antecedent, it seems like the right form
# Even though this transformed version is the same as that without the parameterisation


# === Run the symbolic simulation ===
set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

# Run the symbolic simulation
set num_ticks 8
set eval_out [check_symsim  -eval $model_id \
                            -resolved_sequence $resolved_seq_id \
                            -start_tick 1 \
                            -num_ticks $num_ticks \
                            -init_states false\
                            -canonize on]

set eval_seq [dict get $eval_out sequence_id]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list a b c o] -verbose

# Remains to transform the output_constraint (property to prove) with the paramed indexing relation
# and verify that the the transformed property is satisfied