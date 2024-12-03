# === Helper Functions that Complement symsim_utils.tcl ===

#######################################
# Shorthand for BDD expression creation
#######################################
proc IMPLIES {a b} { check_symsim -expression -implies $a $b }
proc EXISTS_QUANT {tvariables expression} { check_symsim -expression -exist_quantify $expression $tvariables }


#######################################
# Procedure to create BDD variables signal@tick for each (signal, tick) in variables * ticks
# - Returns a dictionary of the form {signal@tick: id(signal@tick)}
#######################################
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

#######################################
# Procedure to create stimuli dict to be used in sequence creation
# - Assumes the bdd_variables are in the form input_signal@tick
# - Assigns to each signal sig: (sig@tick, not sig@tick, tick:tick)
# - Returns a dictionary of the form {input_signal: [(id(sig@tick), id(not sig@tick), tick:tick)]}
#######################################
proc create_stimuli_dict {input_signals bdd_variables} {
    set stimuli_dict [dict create]
    foreach bdd_var [dict keys $bdd_variables] {
        set bdd_var_id [dict get $bdd_variables $bdd_var]
        set not_bdd_var_id [check_symsim -expression -not $bdd_var_id]

        set signal_name [lindex [split $bdd_var @] 0]
        set tick [lindex [split $bdd_var @] 1]

        set stimuli [list $bdd_var_id $not_bdd_var_id $tick:$tick]
        dict lappend stimuli_dict $signal_name $stimuli
    }
    return $stimuli_dict
}


#######################################
# Procedures to compute the preimage of an indexing relation
# Details in the 2002 paper
#######################################
proc weak_preimage {relation predicate target_vars} {
    EXISTS_QUANT $target_vars [AND $relation $predicate]
}

proc strong_preimage {relation predicate target_vars} {
    set wpre [weak_preimage $relation $predicate $target_vars]
    return [AND $wpre [NOT [EXISTS_QUANT $target_vars [AND $relation [NOT $predicate]]]]]
}

#######################################
# Procedures to apply the preimages to a stimuli dictionary
#######################################
proc apply_preimage {preimage_func stimuli_dict index_rel target_variables} {
    set transformed_dict [dict create]
    foreach signal_name [dict keys $stimuli_dict] {
        set stimuli_list [dict get $stimuli_dict $signal_name]
        set transformed_stimuli_list [list]
        foreach stimuli_tuple $stimuli_list {
            set bdd_var_id [lindex $stimuli_tuple 0]
            set not_bdd_var_id [lindex $stimuli_tuple 1]
            set tick_range [lindex $stimuli_tuple 2]
            set transformed_var [eval [list $preimage_func $index_rel $bdd_var_id $target_variables]]
            set transformed_not_var [eval [list $preimage_func $index_rel $not_bdd_var_id $target_variables]]
            lappend transformed_stimuli_list [list $transformed_var $transformed_not_var $tick_range]
        }
        dict set transformed_dict $signal_name $transformed_stimuli_list
    }
    return $transformed_dict
}

proc strong_preimage_stim {stimuli_dict index_rel target_variables} {
    return [apply_preimage strong_preimage $stimuli_dict $index_rel $target_variables]
}

proc weak_preimage_stim {stimuli_dict index_rel target_variables} {
    return [apply_preimage weak_preimage $stimuli_dict $index_rel $target_variables]
}