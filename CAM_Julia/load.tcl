source ../juliaAutoAbstract/auto_abstract.tcl

clear -all

analyze -sv real.sv

analyze -sv spec_aa.sv
elaborate -top cam_spec_aa

