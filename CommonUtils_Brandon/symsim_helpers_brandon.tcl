# === Helper Functions that Complement symsim_utils.tcl ===
# You should also import helpers.tcl in your script to use these functions

########################################
# Shorthand for BDD expression creation
########################################
proc XOR {a b} { check_symsim -expression -xor $a $b }
proc XNOR {a b} { check_symsim -expression -xnor $a $b }
proc IMPLIES {a b} { check_symsim -expression -implies $a $b }
proc EXISTS_QUANT {tvariables expression} { check_symsim -expression -exist_quantify $expression $tvariables }
proc FORALL_QUANT {tvariables expression} { check_symsim -expression -forall_quantify $expression $tvariables }

#######################################
# Analogue of create_antecedent for dual rail signals
#  - Supports wide signals
#  - Returns a dictionary of the form 
# {signal_bit: [(high_expr = bdd_variable@tick, low_expr = NOT bdd_variable@tick, tick:tick) for tick in tick_list]}
######################################
proc create_dual_rail_antecedent {signal tick_list} {
    set antv [dict create]
    set bit_list [get_signal_info -bit_blast $signal]

    set single_tick [expr {[llength $tick_list] == 1}]
    foreach signal_bit $bit_list {
        set stim_list [list]
        foreach tick $tick_list {
            if {$single_tick} {
                set bdd_variable [VAR $signal_bit]
            } else {
                set bdd_variable [VAR $signal_bit@$tick]
            }
            lappend stim_list [list $bdd_variable [NOT $bdd_variable] $tick:$tick]
        }
        dict set antv $signal_bit $stim_list
    }
    return $antv
}

proc merge_dual_rail_antecedents {args} {
    set ant [dict create]
    foreach a $args {
	    dict map {key value} $a {dict append ant $key "$value"}
    }
    return $ant
}


#######################################
# Procedure to condition an antecedent based on an input constraint
# I.e. replace each (high, low, tick) tuple with (input_constraint => high, input_constraint => low, tick)
# Used for environmental constraints
#######################################
proc condition_antv {antv input_constraint} {
    set conditioned_antv [dict create]
    foreach {signal tuples} $antv {
        set conditioned_tuples {}
        foreach tuple $tuples {
            set high [lindex $tuple 0]
            set low [lindex $tuple 1]
            set tick [lindex $tuple 2]
            lappend conditioned_tuples [list [IMPLIES $input_constraint $high] [IMPLIES $input_constraint $low] $tick]
        }
        dict set conditioned_antv $signal $conditioned_tuples
    }
    return $conditioned_antv
}

#######################################
# Procedure to get the variables an antv depends on
# Note that this returns a list of the variable names rather than the IDs. To be used with QUANT_EXISTS
#######################################
proc get_dual_rail_antecedent_variable_names {antv} {
    set var_names [list]
    foreach {signal_name signal_stimuli} [dict get $antv] {
        foreach stim_range $signal_stimuli {
            foreach {high_expr low_expr tick_range} $stim_range {
                set var_names [concat $var_names [check_symsim -expression -depends $high_expr]]
                set var_names [concat $var_names [check_symsim -expression -depends $low_expr]]
            }
        }
    }
    return [make_unique $var_names]
}

#######################################
# Procedure to apply a substitution to a stimuli (antv) dictionary
# - For each signal * tick_ranges, apply the substitution to the high and low expressions
# - Returns a new stimuli dictionary with the substitutions applied
#######################################
proc apply_substitution_stim {stimuli sub_dict} {
    set new_stimuli [dict create]
    foreach {sig stim_list} [dict get $stimuli] {
        set new_stim_list [list]
        foreach stim $stim_list {
            set high_expr [lindex $stim 0]
            set low_expr [lindex $stim 1]
            set tick_range [lindex $stim 2]

            set new_high_expr [check_symsim -expression -substitute $high_expr $sub_dict]
            set new_low_expr [check_symsim -expression -substitute $low_expr $sub_dict]

            lappend new_stim_list [list $new_high_expr $new_low_expr $tick_range]
        }
        dict set new_stimuli $sig $new_stim_list
    }
    return $new_stimuli
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
# A stimuli dict is a dictionary of the form {signal: [(bdd_expr_id, not_bdd_expr_id, tick_range)]}
#######################################
proc apply_preimage {preimage_func stimuli_dict index_rel target_variables} {
    set transformed_dict [dict create]
    foreach signal_name [dict keys $stimuli_dict] {
        set stimuli_list [dict get $stimuli_dict $signal_name]
        set transformed_stimuli_list [list]
        foreach stimuli_tuple $stimuli_list {
            set bdd_expr_id [lindex $stimuli_tuple 0]
            set not_bdd_expr_id [lindex $stimuli_tuple 1]
            set tick_range [lindex $stimuli_tuple 2]
            set transformed_var [eval [list $preimage_func $index_rel $bdd_expr_id $target_variables]]
            set transformed_not_var [eval [list $preimage_func $index_rel $not_bdd_expr_id $target_variables]]
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

#######################################
# Procedures to get the high and low values of a signal at a tick from a simulation sequence
#######################################
proc get_high_low {tick sim_seq} {
    foreach {seq_tup} $sim_seq {
        set high [lindex $seq_tup 0]
        set low [lindex $seq_tup 1]
        set tick_range [lindex $seq_tup 2]
        
        if {[tick_in_range $tick $tick_range]} {
            return [list $high $low]
        }
    }
    return [list "ERROR" "ERROR"]
}

proc tick_in_range {tick tick_range} {
    set range [split $tick_range ":"]
    set from [lindex $range 0]
    set to [lindex $range end]
    
    if {$to == "$"} {
        set to [expr $tick] 
        # tick will be included
    }

    if {$tick >= $from && $tick <= $to} {
        return 1
    } else {
        return 0
    }
}


#######################################
# Procedure to check if a symbolic simulation has TOP for given signals
# This would imply something has gone quite wrong since the simulation is inconsistent
#######################################
proc check_has_top {eval_seq signals} {
    set symbolic_sequence [check_symsim -sequence $eval_seq -get $signals]
    foreach {stimuli} [dict values $symbolic_sequence] {
        foreach {stim_range} $stimuli {
            foreach {high low tick_range} $stim_range {
                if {[AND $high $low] != [FALSE]} {
                    # there is some assignment where both high and low are true
                    return 1
                }
            }
        }
    }
    return 0
}

#######################################
# Procedure to check that a symbolic simulation satisfies given property signals at given ticks

# - properties: dictionary of the form {signal: tick}
# - eval_seq: ID of the output sequence from a symbolic simulation (symsim -eval)
# - prop_high: high expression required of properties (i.e. weak_preimage of TRUE) 
#    - this is the dom(R)[X] = ∃T R[X,T] in the 2007 paper.
# - prop_low: low expression required of properties (i.e. weak_preimage of FALSE) 
#    - which should be FALSE for properties of the relevant form
# - verbose: flag to print the results

# Returns a dictionary of the form {(signal, tick): satisfied}
#######################################

# For a property to be satisfied, both expressions of the property signal in the consequence should imply their respective symbolic simulation exprs
# i.e. for all assignments A where A ent cons(high), we must have A ent sim(high)
# and for all assignments A where A ent cons(low), we must have A ent sim(low)

# Note that this relies on the precondition that no signal in the simulation ever has both high and low expr satisfied at the same time
# i.e. no TOP

# Note that below doesn't use the knowledge that prop_low should be FALSE to allow for functional properties in general.

proc check_properties_against_sim {properties eval_seq prop_high prop_low {verbose 1}} {
    # Ensure we don't have any signals with TOP
    # No longer a safe assumption with conditioning on input_constraint environmental condition strategy
    # assert [expr {[check_has_top $eval_seq [dict keys $properties]] == 0}] "Simulation has TOP for some signals"

    set symbolic_sequence [check_symsim -sequence $eval_seq -get [dict keys $properties]]
    set proof_result [dict create]

    foreach property_signal [dict keys $properties] {
        set property_tick [dict get $properties $property_signal]
        set property_in_sim [dict get $symbolic_sequence $property_signal]
        set sim_expr [get_high_low $property_tick $property_in_sim]
        set sim_high [lindex $sim_expr 0]
        set sim_low [lindex $sim_expr 1]

        set property_low_sat [IMPLIES $prop_low $sim_low]
        set property_high_sat [IMPLIES $prop_high $sim_high]

        set property_sat [expr {($property_low_sat == [TRUE]) && ($property_high_sat == [TRUE])}]
        
        if {$verbose} {
            puts "Property $property_signal at tick $property_tick satisfied: $property_sat"
            puts "Simulated property high: $sim_high"
            puts [PR $sim_high]
            puts "Simulated property low: $sim_low"
            puts [PR $sim_low]
        }
        dict set proof_result [list $property_signal $property_tick] $property_sat
    }
    return $proof_result
}


#########################################################
# DEPRECATED (Don't use with new code)
# Instead of create_bdd_variable and create_stimuli_dict, use create_dual_rail_antecedent
#########################################################

#######################################
# Procedure to create BDD variables signal@tick for each (signal, tick) in signals * ticks
# - Returns a dictionary of the form {signal@tick: id(signal@tick)}
# - Supports wide signals
#######################################
proc create_bdd_variables {signals ticks} {
    set bddVars [dict create]
    foreach signal $signals {
        foreach tick $ticks {
            set bdd_variable [check_symsim -expression -var $signal@$tick]
            dict set bddVars $signal@$tick $bdd_variable
        }
    }
    return $bddVars
}

#######################################
# Procedure to create stimuli dict to be used in sequence creation
# - Assumes the bdd_variables are in the form input_signal@tick
# - Assigns to each signal sig: (sig@tick, not sig@tick, tick:tick)
# - Returns a dictionary of the form {input_signal: [(id(sig@tick), id(not sig@tick), tick:tick)]}

# Similar to create_antecedent but for the simulation rather than recipes (recipes don't use dual rail BDDs)
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