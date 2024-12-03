# perform the usual uninteresting setup

clear -all
analyze -sv megaAnd.sv
analyze -sva megaAnd_spec.sva
analyze -sv bind.sv
elaborate -top megaAnd
clock -both_edges clk
reset -none

source symsim_utils.tcl

# prove -property megaAnd.spec.full_out_neg_delay -max_trace_length 4

set_symsim_bdd_dynamic_weakening_size_limit 0

set model [check_symsim -model -create]

set goal <embedded>::megaAnd.spec.full_out_neg_delay

set op_ant [symsim::create_antecedent -signal operands -tick [list 2 4 6]] 
set trigger_ant [symsim::create_antecedent -signal trigger -tick [list 2 4 6]]

# why am i specifing -tick here?
set antv [symsim::merge_antecedents $op_ant $trigger_ant]
set cin [symsim::create_input_constraint -property $goal -tick 4]
set cout [symsim::create_output_constraint -property $goal -tick 6]  

check_symsim -recipe rec -config -cin_ncfow false -cout_ncfow false -cin_main_dyn_wlim 0 -cout_main_dyn_wlim 0 
check_symsim -resolved_recipe -create -recipe rec -antv $antv -cout $cout -cin $cin -force
set result [check_symsim -prove -resolved_recipe rec ]


puts $result