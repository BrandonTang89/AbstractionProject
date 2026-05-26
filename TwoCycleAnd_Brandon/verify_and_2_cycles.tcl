# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# =====================================================================
# Simple 3-input, unit-delay AND gate example to illustrate rSTE.
#
# Top-level verification script for Jasper.
# =====================================================================

# Main help text: help check_symsim & help symsim_prove

# Clear everything, in case you want to re-load this file or start again.
clear -all

# Parse the DUT - the "Design Under Test"
analyze -sv and_2_cycles.sv

# Parse the specification module
analyze -sva and_2_cycle_spec_mod.sva

# Parse and load in the bin directive
analyze -sv bind_and_2_cycles.sv

# Now "instantiate" everything. THis will create an and_top module, containing a "spec" module.
elaborate -top and_2_cycles_top

# At this point, try
# - opening the schematic viewer on the circuit; right-click on the Design Hierarchy.
# - viewing the property; right-click on the property name, to get the Property Details
# Basically play around with it.

# Specify the clocking and reset
clock -both_edges clk
reset -none

# You are now ready to do some verification.
# - try doing the proof with the GUI. And/or excecuting this:

# prove -property "and_2_cycles_top.spec.and_correct"
prove -all
