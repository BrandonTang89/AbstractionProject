# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

clear -all
analyze -sv simple.sv
analyze -sva simple_spec.sva
analyze -sv bind_simple.sv
elaborate -top simple_top

clock -both_edges clk
reset -none

source ../juliaAutoAbstract/auto_abstract.tcl
source ../juliaAutoAbstract/simulate.tcl
source ../CommonUtils_Brandon/autoabstraction_helpers_brandon.tcl
source ../CommonUtils_Brandon/symsim_utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
namespace import symsim::*
set_symsim_expr_pretty_print_threshold 3000

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
set signals [check_symsim -model $model_id -list signal]

# == Set up properties to check ==
set properties [dict create \
    spec.property_wire 2]

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
set input_ticks [list 2]

set ant_a [create_dual_rail_antecedent a [list 2]]
set ant_b [create_dual_rail_antecedent b [list 2]]
set ant_c [create_dual_rail_antecedent c [list 2]]
set ant_d [create_dual_rail_antecedent d [list 2]]
set antv [merge_dual_rail_antecedents $ant_a $ant_b $ant_c $ant_d]

set bdd_variables [get_dual_rail_antecedent_variable_names $antv]


# == Automatic Abstraction ==
######################
# If you uncomment this line and run it, the evaluation will produce a different result!!

# autoabstract spec.desired_wire [VAR t_0] [NOT [VAR t_0]] []

# Note that the above line does produce the same abstraction as the one below...
######################

set partition_abstraction [autoabstract o [VAR t_0] [NOT [VAR t_0]] []]

# Rename the abstraction
set inputs [check_symsim -model $model_id -list input]
set partition_abstraction [rename_partition_abstraction $partition_abstraction $inputs]

set index_rel [combine_abstractions $partition_abstraction]

# Manual correction!!!
set index_rel [AND $index_rel [OR [VAR x_1] [VAR x_2]]]

# === Indexing Transformation ===
# set model_id [check_symsim -model -create]
# Apply the indexing transformation to the stimuli
# set transformed_ant_stimuli $antv
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
check_symsim -sequence $eval_seq -get [list o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
set prop_high [weak_preimage $index_rel [TRUE] $bdd_variables]
set prop_low [weak_preimage $index_rel [FALSE] $bdd_variables]


check_symsim -expression -depends $prop_high
PR $prop_high
PR $prop_low

check_properties_against_sim $properties $eval_seq $prop_high $prop_low
check_symsim -expression -get_canonical $prop_high
