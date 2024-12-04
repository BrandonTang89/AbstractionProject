# =====================================================================
# Simple 3-input, unit-delay AND gate example to illustrate rSTE.
#
# Top-level verification script for Jasper.
# =====================================================================

# Main help text: help check_symsim & help symsim_prove

# Clear everything, in case you want to re-load this file or start again.
clear -all
analyze -sv sync_ram.sv
analyze -sva sync_ram_spec.sva
analyze -sv bind_sync_ram.sv
elaborate -top sync_ram

# At this point, try
# - opening the schematic viewer on the circuit; right-click on the Design Hierarchy.
# - viewing the property; right-click on the property name, to get the Property Details
# Basically play around with it.

# Specify the clocking and reset
clock -both_edges clk
reset -none

# You are now ready to do some verification.
# - try doing the proof with the GUI. And/or excecuting this:

prove -property "sync_ram.spec.correct_write"