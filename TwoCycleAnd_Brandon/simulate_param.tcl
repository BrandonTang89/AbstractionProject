# ===== Exprimentation with symbolic simulation =====
clear -all
source symsim_utils.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

# Set up the symbolic model of the circuit
set modelId [check_symsim -model -create]
set propertyName <embedded>::and_2_cycles_top.spec.and_correct
check_symsim -model $modelId -list input
check_symsim -model $modelId -list signal
check_symsim -model $modelId -list assert

set alpha [check_symsim -expression -var alpha]
set beta [check_symsim -expression -var beta]
set gamma [check_symsim -expression -var gamma]

set nalpha [check_symsim -expression -not $alpha]
set nbeta [check_symsim -expression -not $beta]
set ngamma [check_symsim -expression -not $gamma]

# We assume an environmental constraint where alpha AND beta = alpha AND gamma
set alphaAndBeta [check_symsim -expression -and [list $alpha $beta]]
set alphaAndGamma [check_symsim -expression -and [list $alpha $gamma]]
set leftImpRight [check_symsim -expression -implies $alphaAndBeta $alphaAndGamma]
set rightImpLeft [check_symsim -expression -implies $alphaAndGamma $alphaAndBeta]
set envt_const [check_symsim -expression -and [list $leftImpRight $rightImpLeft]]

set envt_const_conanical [check_symsim -expression -get_canonical $envt_const]
check_symsim -expression -depends $envt_const_conanical
check_symsim -expression -pretty_print $envt_const_conanical
check_symsim -expression -pick_assignment [list $envt_const_conanical] -small

# We param away gamma (which is sufficient) 
set param_output [check_symsim -param -expressions [list $envt_const_conanical] -variables [list gamma]]
set gamma_assignment [dict get [lindex [dict get [dict get $param_output param_res] symb_subst] 0] gamma]

# this is the assignment that we will use to param away gamma
check_symsim -expression -pretty_print $gamma_assignment
set ngamma_assignment [check_symsim -expression -not $gamma_assignment]

# Now our stimulus is based on alpha, beta and p0::gamma since we have paramed away gamma
set my_stimuli_dict [dict create a [list [list $alpha $nalpha 1:$]] b [list [list $beta $nbeta 1:$]] c [list [list $gamma_assignment $ngamma_assignment 1:$]]]
set my_sequence_id [check_symsim -sequence -create $my_stimuli_dict -name my_sequence]

set my_seq_resolved_id [check_symsim -sequence -resolve -antecedent $my_sequence_id -name my_sequence_resolved]
set outputList [check_symsim -eval $modelId -resolved_sequence $my_seq_resolved_id -start_tick 1 -num_ticks 6]
set outputSeq [lindex $outputList 5]

check_symsim -sequence $outputSeq -get [list o] -verbose
set assertions [check_symsim -model $modelId -list assert]
check_symsim -sequence $outputSeq -get $assertions -verbose