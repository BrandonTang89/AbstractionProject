# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# ===== Exprimentation with Conducting a Symbolic Simulation =====
# ==== Here we simulate the circuit assuming stable inputs ====
# A lot of stuff here is not necessary and just for learning

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

# === Symsim Stuff ===
# Set up the symbolic model of the circuit
set modelId [check_symsim -model -create]

# === Running a symbolic simulation ===
# We can list the signals (wires) in the model, these are the same models as in the systemverilog code
check_symsim -model $modelId -list input
check_symsim -model $modelId -list signal
check_symsim -model $modelId -list assert

# symsim expressions are bdds
# We can create bdd variables as follows
# We will set the inputs of our circuit to be equal to these bdd variables later on
set alpha [check_symsim -expression -var alpha]
set beta [check_symsim -expression -var beta]
set gamma [check_symsim -expression -var gamma]

# We can get negations of expressions
set nalpha [check_symsim -expression -not $alpha]
set nbeta [check_symsim -expression -not $beta]
set ngamma [check_symsim -expression -not $gamma]

# We can compose expressions together to get bigger bdd expressions
set and_abg [check_symsim -expression -and [list $alpha $beta $gamma]]

check_symsim -expression -depends $and_abg

# This returns a satisfying assignment for the expression if possible
check_symsim -expression -pick_assignment [list $and_abg] -small

# Sequences in check_symsim map expressions to wires over some time
# this seems to be where we can eventually add abstraction since we have the opportunity
# for dual rail BDDS to be attached to each signal

set my_stimuli_dict [dict create a [list [list $alpha $nalpha 1:$]] b [list [list $beta $nbeta 1:$]] c [list [list $gamma $ngamma 1:$]]]
set my_sequence_id [check_symsim -sequence -create $my_stimuli_dict -name my_sequence]

# Gets the value of the signal at the given time (as a dual rail bdd)
check_symsim -sequence $my_sequence_id -get_value a -tick 1

# we need to resolve a sequence before we can do symbolic evaluation
# I think this corresponds to creating an antv for rSTE?
set my_seq_resolved_id [check_symsim -sequence -resolve -antecedent $my_sequence_id -name my_sequence_resolved]


# We can now run the symbolic simulation with the resolved sequence'
# Note that each tick represents a clock phase so to simulate until the output of my circuit is stable,
# we need to simulate for 3 rising clock phases i.e. 6 ticks
set outputList [check_symsim -eval $modelId -resolved_sequence $my_seq_resolved_id -start_tick 1 -num_ticks 6]

set outputSeq [lindex $outputList 5]

# We can view this symbolic simulation output
# if we remove the signal list we will all the observed signals
check_symsim -sequence $outputSeq -get [list o] -verbose

set assertions [check_symsim -model $modelId -list assert]
check_symsim -sequence $outputSeq -get $assertions -verbose

# We can see that after 1 clock cycle, the output will be low if any alpha beta or gamma are low (or X otherwise)
# after 2 clock cycles, the output will be equal to alpha & beta & gamma
