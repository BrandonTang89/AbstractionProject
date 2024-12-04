# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva and_2_cycle_spec.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick in ticks
    set antecedent [dict create]
    foreach signal $signals {
        set signalAntecedent [list]
        foreach tick $ticks {
            set bddVar [format "%sVar_%d" $signal $tick]
            set bddTime [format "%d:%d" $tick $tick]
            lappend signalAntecedent [list $bddVar $bddTime]
        }
        dict set antecedent $signal $signalAntecedent
    }
    return $antecedent
}


set myantv [makeAntecedent [list a b c] [list 2 4]]
puts myantv
set mycout [dict create $propertyName [list 6]]
# If we add 4 or 8 to the above cout list, we will see that the proof fails

check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof