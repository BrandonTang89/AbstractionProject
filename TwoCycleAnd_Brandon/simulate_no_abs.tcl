# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# ===== Exprimentation with Conducting a Symbolic Simulation =====
# This script does a no-abstraction symbolic simulation and shows
# - the correct property being satisfied
# - the wrong property being violated
# - a visualisation of the simulation

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

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
# set property_name <embedded>::and_2_cycles_top.spec.and_correct
# set property_name <embedded>::and_2_cycles_top.spec.and_wrong

# === Running a symbolic simulation ===
# For each var@tick, create a BDD variable
set inputs [list a b c]
set input_ticks [list 2 4]
set bdd_variables [create_bdd_variables $inputs $input_ticks]
puts "BDD Variables: $bdd_variables"

# Creates a dictionary mapping input_sig -> [list of tuples (input_sig@tick, not_input_sig@tick, tick:tick)]
set stimuli_dict [create_stimuli_dict $inputs $bdd_variables]
puts "Stimuli Dict: $stimuli_dict"

# Create a sequence from the stimuli dictionary
set sequence_id [check_symsim -sequence -create $stimuli_dict -name my_sequence]

# Resolve the sequence
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $sequence_id -name my_resolved_sequence]


# Run the symbolic simulation
set num_ticks 8
set eval_out [check_symsim -eval $model_id \
    -resolved_sequence $resolved_seq_id \
    -start_tick 1 \
    -num_ticks $num_ticks \
    -init_states false \
    -canonize on]
# since we do not specify -observation, all signals are tracked
set eval_seq [dict get $eval_out sequence_id]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list a b c o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

## The critical part is seeing that on tick 6, the correct property has value 1
