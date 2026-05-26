# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# ===== Symbolic Simulation with Indexing Transformations =====
# This script applies an indexing transformation to add abstraction to the simulation

# We use the following indexing relation:
# p and q and r -> a@2 and b@2 and c@2 and a@4 and b@4 and c@4
# p and q and (not r) -> not a@2
# p and (not q) and r -> not b@2
# (not p) and q and r -> not c@2
# (not p) and (not q) and r -> not a@4
# (not p) and q and (not r) -> not b@4
# p and (not q) and (not r) -> not c@4p
# p OR q OR r

# This satisfies the coverage condition that
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
set properties [dict create \
    spec.and_correct 6 \
    spec.and_wrong 6]

set max_property_tick [max_dict_values $properties]

# === Set up Stimuli ===
# Create initial un-abstracted stimuli
set input_ticks [list 2 4]
set antv [merge_dual_rail_antecedent \
    [create_dual_rail_antecedent a $input_ticks] \
    [create_dual_rail_antecedent b $input_ticks] \
    [create_dual_rail_antecedent c $input_ticks] \ ]
set bdd_variables [get_dual_rail_antecedent_variable_names $antv]

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
    [OR $p $q $r]]

# Example of too coarse abstraction, doesn't work
# set index_rel [AND \
#     [IMPLIES $p [AND [VAR a@2] [VAR b@2] [VAR c@2] [VAR a@4] [VAR b@4] [VAR c@4]]] \
#     [IMPLIES [NOT $p] [OR [NOT [VAR a@2]] [NOT [VAR b@2]] [NOT [VAR c@2]] [NOT [VAR a@4]] [NOT [VAR b@4]] [NOT [VAR c@4]]]] \
# ]

set index_rel [check_symsim -expression -canonize $index_rel]

# Check that the indexing relation is as expected
check_symsim -expression -depends $index_rel
PR $index_rel

# Check Coverage
set coverage [satisfiesCoverage $index_rel $bdd_variables]
assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
set transformed_ant_stimuli [strong_preimage_stim $antv $index_rel $bdd_variables]

# Create a sequence from tranformed stimuli
set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

# Run the symbolic simulation
set num_ticks [expr $max_property_tick + 2]
set eval_out [check_symsim -eval $model_id \
    -resolved_sequence $resolved_seq_id \
    -start_tick 1 \
    -num_ticks $num_ticks \
    -init_states false \
    -canonize on]

set eval_seq [dict get $eval_out sequence_id]

# Visualise the simulation
# Here we can manually inspect to see the value of o (at tick 6) but we need to figure out if this is actually correct
check_symsim -sequence $eval_seq -get [list a b c o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
# With the modified property, we can perform the weak preimage transformation to get the transformed consequence
# We observe that for each property, we will transform the dual rail value (TRUE, FALSE) so we just need to do this once for all properties
set prop_high [weak_preimage $index_rel [TRUE] $bdd_variables]
set prop_low [weak_preimage $index_rel [FALSE] $bdd_variables]

# prop_low should always be false
# prop_high is the domain of the indexing relation, i.e. all abstraction cases that correspond to some target assignment

PR $prop_high
PR $prop_low

# We then need to conclude whether the property is satisfied or not
# for a property to be satisfied, both expressions of the property signal in the consequence should imply their respective symbolic simulation exprs
# i.e. for all assignments A where A ent cons(high), we must have A ent sim(high)
# and for all assignments A where A ent cons(low), we must have A ent sim(low)

check_properties_against_sim $properties $eval_seq $prop_high $prop_low
