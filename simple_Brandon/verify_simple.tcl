# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

clear -all
analyze -sv simple.sv
analyze -sva simple_spec.sva
analyze -sv bind_simple.sv
elaborate -top simple_top

clock -both_edges clk
reset -none
prove -all
