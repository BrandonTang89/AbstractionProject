# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

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
