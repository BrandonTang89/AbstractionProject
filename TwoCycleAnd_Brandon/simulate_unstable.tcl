# ===== Exprimentation with Conducting a Symbolic Simulation =====
# This script does a no-abstraction symbolic simulation and shows 
# - the correct property being satisfied
# - the wrong property being violated
# - a visualisation of the simulation

clear -all
source symsim_utils.tcl
source helpers.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
# set property_name <embedded>::and_2_cycles_top.spec.and_correct
# set property_name <embedded>::and_2_cycles_top.spec.and_wrong

# === Running a symbolic simulation ===
# For each var@tick, create a BDD variable
proc create_bdd_variables {variables ticks} {
    set bddVars [dict create]
    foreach variable $variables {
        foreach tick $ticks {
            set bdd_variable [check_symsim -expression -var $variable@$tick]
            dict set bddVars $variable@$tick $bdd_variable
        }
    }
    return $bddVars
}

set inputs [list a b c]
set input_ticks [list 2 4]
set bdd_variables [create_bdd_variables $inputs $input_ticks]
puts "BDD Variables: $bdd_variables"

# Creates a dictionary mapping input_sig -> [list of tuples (input_sig@tick, not_input_sig@tick, tick:tick)]
proc create_stimuli_dict {input_signals bdd_variables} {
    set stimuli_dict [dict create]
    foreach bdd_var [dict keys $bdd_variables] {
        set bdd_var_id [dict get $bdd_variables $bdd_var]
        set not_bdd_var_id [check_symsim -expression -not $bdd_var_id]
        
        set signal_name [lindex [split $bdd_var @] 0]
        set tick [lindex [split $bdd_var @] 1]

        set stimuli [list $bdd_var_id $not_bdd_var_id $tick:$tick]
        
        # Add this stimuli tuple to the list at $stimuli_dict[signal_name], creating the list if needed
        dict lappend stimuli_dict $signal_name $stimuli
    }
    return $stimuli_dict
}

set stimuli_dict [create_stimuli_dict $inputs $bdd_variables]
puts "Stimuli Dict: $stimuli_dict"

# Create a sequence from the stimuli dictionary
set sequence_id [check_symsim -sequence -create $stimuli_dict -name my_sequence]

# Resolve the sequence
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $sequence_id -name my_resolved_sequence]


# Run the symbolic simulation
set num_ticks 8
set eval_out [check_symsim  -eval $model_id \
                            -resolved_sequence $resolved_seq_id \
                            -start_tick 1 \
                            -num_ticks $num_ticks \
                            -init_states false\
                            -canonize on]
# since we do not specify -observation, all signals are tracked
set eval_seq [dict get $eval_out sequence_id]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list a b c o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

## The critical part is seeing that on tick 6, the correct property has value 1