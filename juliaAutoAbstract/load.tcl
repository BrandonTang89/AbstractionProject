
clear -all
analyze -sv bp_test.sv
elaborate -top bp_test

clock -none
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
namespace import symsim::*


source auto_abstract.tcl

#puts [PR [simple_bp y6 [VAR x_0] [NOT [VAR x_0]]]]

puts [PR_bp [advanced_bp [list] y6 [VAR x_0] [NOT [VAR x_0]] base]]

# create a symbolic model so that interactive invocations of simulate don't fail
check_symsim -model -create 