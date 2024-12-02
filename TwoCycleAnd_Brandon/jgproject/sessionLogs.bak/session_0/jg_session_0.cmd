# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2024.12
# platform  : Linux 6.8.0-48-generic
# version   : 2024.12-20241120 64 bits
# build date: 2024.11.20 12:43:18 UTC
# ----------------------------------------
# started   : 2024-12-02 19:19:31 UTC
# hostname  : tfm2.(none)
# pid       : 312025
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:33417' '-style' 'windows' '-data' 'AAAAinicY2RgYLCp////PwMYMD6A0Aw2jAyoAMRnQhUJbEChGRhYkRVrMegyJDLkAGE+QzlDPEMpQx5DMZAsAMJ8hiKGEoZUhhSguD9DMFgPAM7XDyQ=' '-proj' '/home/ug22btyh/TwoCycleAnd_Brandon/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ug22btyh/TwoCycleAnd_Brandon/jgproject/.tmp/.initCmds.tcl'
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set assertions [check_symsim -model $modelId -list assert]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct


namespace import symsim::*
# check_symsim -recipe my_recipe -config 
check_symsim -recipe my_recipe -config -init_states false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false
check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
# check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_antecedent_variables $myantv
symsim::get_result_sequence
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_antecedent_variables $myantv
symsim::get_result_sequence
symsim::debug_proof
prove -property <embedded>::and_2_cycles_top.spec.and_correct -sst
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none
prove -property <embedded>::and_2_cycles_top.spec.and_correct -sst
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set assertions [check_symsim -model $modelId -list assert]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set assertions [check_symsim -model $modelId -list assert]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 4]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

prove -property $propertyName -max_trace_length 2
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

prove -property $propertyName -max_trace_length 2
prove -property $propertyName -max_trace_length 5
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none
prove -property $propertyName -max_trace_length 5
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 1 2 3 4 5 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof

prove -property $propertyName -max_trace_length 5
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof

help prove
prove -property $propertyName -max_trace_lengh 5
prove -property $propertyName -max_trace 5
# ===== Exprimentation with using DFV for Proof =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
prove -property $propertyName -max_trace 5
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none
prove -property $propertyName -max_trace 5
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_result_sequence
symsim::debug_proof
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
set mycout [dict create $propertyName [list 6 8]]
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_result_sequence
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
set mycout [dict create $propertyName [list 6 4]]
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_result_sequence
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]
set cout [create_output_constraint -property $propertyName -tick [list 4 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof


# We need to finish off the proof for ticks < 6
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set pcout [create_output_constraint -property $propertyName -tick [list 4 6]]
set cout [merge_output_constraints $pcout]
puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

symsim::debug_proof


# We need to finish off the proof for ticks < 6

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]
set cout [create_output_constraint -property $propertyName -tick [4 6]]
set cout [create_output_constraint -property $propertyName -tick 4 6]
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout
$couty
$cout
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct

set sstMaxLength 4
proc create_list {a b} {
    set myList {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend myList $i
    }
    return $myList
}

check_symsim -recipe my_recipe -config
check_symsim -recipe my_recipe -config -init_states false
check_symsim -recipe my_recipe -cin_ncfow false -cout_ncfow false 
check_symsim -recipe list

proc makeAntecedent {signals ticks} {
    # creates a antecent dictionary with one BDD variable per signal per tick from 1 until $
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
set mycout [dict create $propertyName [list 4 6]]
check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

symsim::get_result_sequence
symsim::debug_proof
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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
set mycout [dict create $propertyName [list 4 6]]
# If we add 4 to the above cout list, we will see that the proof fails for tick 4 since at tick 4, $past(_, 2) is X

check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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
# If we add 4 to the above cout list, we will see that the proof fails for tick 4 since at tick 4, $past(_, 2) is X

check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
prove -property $propertyName -max_trace_length 5
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
prove -property $propertyName -max_trace_length 5
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
prove -property $propertyName -max_trace_length 5
# ===== DFV Proof via check-symsim API =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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
set mycout [dict create $propertyName [list 4 6 8]]
# If we add 4 to the above cout list, we will see that the proof fails for tick 4 since at tick 4, $past(_, 2) is X

check_symsim -resolved_recipe -create -recipe my_recipe -antv $myantv -cout $mycout -force
set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]

set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false
check_symsim -recipe my_recipe -config -add_cout_observation [list o a b c]

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6 8]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
# prove -property $propertyName -max_trace_length 5
symsim::debug_proof
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set cout_observation_dict [dict create o [2 4 6 8] a [2 4 6 8] b [2 4 6 8] c [2 4 6 8]]
check_symsim -recipe my_recipe -config -add_cout_observation $cout_observation_dict

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6 8]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
# prove -property $propertyName -max_trace_length 5
symsim::debug_proof
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false

set cout_observation_dict [dict create o [list 2 4 6 8] a [list 2 4 6 8] b [list 2 4 6 8] c [list 2 4 6 8]]
check_symsim -recipe my_recipe -config -add_cout_observation $cout_observation_dict

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6 8]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
symsim::debug_proof
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
source helpers.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false


set obs_ticks [create_list 1 8]
set cout_observation_dict [dict create o $obs_ticks a $obs_ticks b $obs_ticks c $obs_ticks]
check_symsim -recipe my_recipe -config -add_cout_observation $cout_observation_dict

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 4 6 8]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
# prove -property $propertyName -max_trace_length 5
symsim::debug_proof
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
source symsim_utils.tcl
source helpers.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
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

namespace import symsim::*
check_symsim -recipe my_recipe -config -init_states false 
# the fact that the reset state is Xs everywhere means we can generalise our simulation to start at any time
check_symsim -recipe my_recipe -config -cin_ncfow false -cout_ncfow false


# We add observation ticks so we can better visualise what is happening during the simulation
set obs_ticks [create_list 1 8]
set cout_observation_dict [dict create o $obs_ticks a $obs_ticks b $obs_ticks c $obs_ticks $propertyName $obs_ticks]
check_symsim -recipe my_recipe -config -add_cout_observation $cout_observation_dict

set aantv [create_antecedent -signal a -tick [list 2 4]]
set bantv [create_antecedent -signal b -tick [list 2 4]]
set cantv [create_antecedent -signal c -tick [list 2 4]]
set antv [merge_antecedents $aantv $bantv $cantv]

set cout [create_output_constraint -property $propertyName -tick [list 6]]

puts $antv
puts $cout

check_symsim -resolved_recipe -create -recipe my_recipe -antv $antv -cout $cout -force

set proofRes [check_symsim -prove -resolved_recipe my_recipe ]
set recipe_res [dict get  $proofRes recipe_results]
set proofId [dict get $recipe_res proof_id]


# We can analyse the output sequence at the observation ticks
# Note that the assertion signal will automatically get observed at the relevant ticks for the proof
set outputSeq [symsim::get_result_sequence]
check_symsim -sequence $outputSeq -get [list o] -verbose
check_symsim -sequence $outputSeq -get $assertions -verbose

# symsim::debug_proof

# We need to finish off the proof for ticks < 6
# prove -property $propertyName -max_trace_length 5
debug_proof
# ===== DFV Proof via SymsimUtils.tcl =====
clear -all
