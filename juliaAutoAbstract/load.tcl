
clear -all
analyze -sv bp_test.sv
elaborate -top bp_test

clock -none
reset -none

source ../CommonUtils_Brandon/symsim_utils.tcl
namespace import symsim::*
# create a symbolic model so that interactive invocations of simulate don't fail
set model_id [check_symsim -model -create]

source auto_abstract.tcl
# set_symsim_expr_pretty_print_threshold 3000

# puts [PR [simple_bp y6 [VAR x_0] [NOT [VAR x_0]]]]
#puts [PR_bp [advanced_bp [list] y6 [VAR x_0] [NOT [VAR x_0]] base]]

