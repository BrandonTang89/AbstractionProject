
clear -all
analyze -sv bp_test.sv
elaborate -top bp_test

clock -none
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
namespace import symsim::*


source auto_abstract_simple.tcl

puts [PR [simple_bp y6 [VAR x_0] [NOT [VAR x_0]]]]

puts [PR_bp [advanced bp [list] y6 [VAR x_0] [NOT [VAR x_0]] base]]