
clear -all
analyze -sv simple.sv
analyze -sva simple_spec.sva
analyze -sv bind_simple.sv
elaborate -top simple_top

clock -both_edges clk
reset -none
prove -all