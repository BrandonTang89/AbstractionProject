
clear -all
analyze -sv bp_test.sv
elaborate -top bp_test

clock -none
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
namespace import symsim::*

source auto_abstract_simple.tcl

puts [PR [simple_bp y6 [VAR x0] [NOT [VAR x0]]]]