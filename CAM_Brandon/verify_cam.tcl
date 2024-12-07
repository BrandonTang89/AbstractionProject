# =====================================================================
# CAM Verification Script
#
# Top-level verification script for Jasper.
# =====================================================================

clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top
clock -both_edges clk
reset -none

# prove -property "cam_top.spec.assert_hit"
prove -all