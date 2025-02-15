# =====================================================================
# CAM Verification Script
#
# Top-level verification script for Jasper.
# =====================================================================

set DATA_WIDTH 1; # log d
set ADDR_WIDTH 2; # log n

clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
clock -both_edges clk
reset -none

# prove -property "cam_top.spec.assert_hit"
prove -all