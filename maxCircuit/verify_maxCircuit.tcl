# =====================================================================
# Max Circuit Verification Script
#
# Top-level verification script for Jasper.
# =====================================================================

set DATA_WIDTH 6; # log d
set ADDR_WIDTH 5; # log n

set DATA_LENGTH [expr 2**$DATA_WIDTH]
set NUM_ENTRIES [expr 2**$ADDR_WIDTH]

clear -all
analyze -sv maxCircuit.sv
analyze -sva maxCircuitSpec.sva
analyze -sv maxCircuitBind.sv
elaborate -top max_circuit_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
clock -both_edges clk
reset -none

prove -all

