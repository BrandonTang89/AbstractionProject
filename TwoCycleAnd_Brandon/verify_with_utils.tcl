# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
source helpers.tcl
namespace import symsim::*
analyze -sv and_2_cycles.sv
analyze -sva and_2_cycle_spec.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set assertions [check_symsim -model $modelId -list assert]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

#  (##2 o == ($past(a, 1) & $past(b, 1) & $past(c, 1) & $past(a, 2) & $past(b, 2) & $past(c, 2)));
# For this property, we need to simulate the inputs for ticks 2 and 4
# We check the property at tick 6

check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false


# We add observation ticks so we can better visualise what is happening during the simulation
set obs_ticks [create_list 1 8]
set observed_signals [list a b c o]
set cout_observation_dict [assign_to_all $observed_signals $obs_ticks]
check_symsim -recipe my_recipe -config -add_cout_observation $cout_observation_dict

# Create the antecedent (create bdd variables for each input signal)
set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

# Create the output constraint (see which wires we should observe during the simulation)
set cout [create_output_constraint -property $propertyName -tick [list 4 6 8]]
# remove the 4 and 8 to get it to prove properly

puts $antv
puts $cout

# Resolve the recipe
check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

# Prove the recipe
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# Analyse the output sequence at the observation ticks
# Note that the assertion signal will automatically get observed at the relevant ticks for the proof
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof
# We need to finish off the proof for ticks < 6
# prove -property $propertyName -max_trace_length 5