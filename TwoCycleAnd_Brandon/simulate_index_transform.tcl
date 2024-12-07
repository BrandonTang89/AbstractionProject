# ===== Symbolic Simulation with Indexing Transformations =====
# This script applies an indexing transformation to add abstraction to the simulation
# We still have the following goals:
# - the correct property being satisfied
# - the wrong property being violated
# - a visualisation of the simulation

# We use the following indexing relation:
# p and q and r -> a@2 and b@2 and c@2 and a@4 and b@4 and c@4
# p and q and (not r) -> not a@2
# p and (not q) and r -> not b@2
# (not p) and q and r -> not c@2
# (not p) and (not q) and r -> not a@4
# (not p) and q and (not r) -> not b@4
# p and (not q) and (not r) -> not c@4p
# p OR q OR r


# This (should) satisfy the coverage condition that 
    # for each 2^6 possible inputs (across 3 signals on 2 time ticks),
    # we have some value of (p, q, r) that maps to that


# The initial set up is the same as for the no-abstraction simulation
clear -all
analyze -sv and_2_cycles.sv
analyze -sva and_2_cycle_spec_mod.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
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

# == Set up property to check ==
set property_tick 6
set property_signal spec.and_correct
# set property_signal spec.and_wrong


# === Set up Stimuli ===
set inputs [list a b c]
set input_ticks [list 2 4]
set bdd_variables [create_bdd_variables $inputs $input_ticks]

# Create initial un-abstracted stimuli
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
    [OR $p $q $r]\
]

set index_rel [check_symsim -expression -canonize $index_rel]

# Check that the indexing relation is as expected
check_symsim -expression -depends $index_rel
PR $index_rel

# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
set transformed_ant_stimuli [strong_preimage_stim $stimuli_dict $index_rel $bdd_variables]

# Create a sequence from tranformed stimuli
set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

# Run the symbolic simulation
set num_ticks [expr $property_tick + 2]
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
# Here we can manually inspect to see the value of o (at tick 6)

# === Transformation of the property ===
# With the modified property, we can perform the weak preimage transformation to get the transformed consequence
set ste_cons [dict create spec.and_correct [list [list [TRUE] [FALSE] $property_tick:$property_tick]]]

set transformed_cons [strong_preimage_stim $ste_cons $index_rel $bdd_variables]
set prop_stim [dict get $transformed_cons $property_signal]
set prop_high [lindex [lindex $prop_stim 0] 0]
set prop_low [lindex [lindex $prop_stim 0] 1]

PR $prop_high
PR $prop_low

# We then need to conclude whether the property is satisfied or not
# for a property to be satisfied, both expressions of the property signal in the consequence should imply their respective symbolic simulation exprs
# i.e. for all assignments A where A ent cons(high), we must have A ent sim(high)
# and for all assignments A where A ent cons(low), we must have A ent sim(low)

set property_sim_seq [lindex [check_symsim -sequence $eval_seq -get $property_signal] 1]
set sim_expr [get_high_low $property_tick $property_sim_seq]
set sim_high [lindex $sim_expr 0]
set sim_low [lindex $sim_expr 1]

set property_low_sat [IMPLIES $prop_low $sim_low]
set property_high_sat [IMPLIES $prop_high $sim_high]

set property_sat [expr {($property_low_sat == [TRUE]) && ($property_high_sat == [TRUE])}]
puts "Property $property_signal at tick $property_tick satisfied: $property_sat"