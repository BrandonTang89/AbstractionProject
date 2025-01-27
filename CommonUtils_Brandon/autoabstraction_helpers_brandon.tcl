#######################################
# Renames the variables in the partitioned abstraction to be consistent with create_dual_rail_antecedent
#######################################
proc rename_partition_abstraction {partition_abstraction inputs} {
    set sub_dict [dict create]
    foreach input $inputs {
        dict set sub_dict "v_$input" [VAR $input]
    }
    
    set substituted_abstraction []

    foreach abstraction $partition_abstraction {
        set var [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        set new_var [check_symsim -expression -substitute $var $sub_dict]
        set new_hexpr [check_symsim -expression -substitute $hexpr $sub_dict]
        set new_lexpr [check_symsim -expression -substitute $lexpr $sub_dict]

        lappend substituted_abstraction [list $new_var $new_hexpr $new_lexpr]
    }

    return $substituted_abstraction
}


#######################################
# Converts a partitioned abstraction [(TARGVAR/SymbolicConstBDD, highexpr, lowexpr)] into the form (S, T)
# Takes the partitioned abstraction and a list of target_variables (as strings)
# Where the indexing relation is S[xs, cs] and T[xs, ts]
# S[xs] contains no target variables, formed from tuples of the form (SymbolicConstBDD, highexpr, lowexpr)
# T[xs, ts] = AND_(target variables ti) (highexpr -> ti) AND (lowexpr -> NOT ti)

# We return T as a dictionary from target variable (expression numbers) to (highexpr, lowexpr)
# We return S as a BDD expression

# Note that this will not work if we do param over the indexing relation since we will have functions of target variables
#######################################
proc normalise_abstraction {partition_abstraction target_variables} {
    set tvar_expr_numbers [list]
    foreach var $target_variables {
        lappend tvar_expr_numbers [VAR $var]
    }
    # Initialise T_dict with var -> (false, false)
    set T_dict [dict create]
    foreach var $tvar_expr_numbers {
        dict set T_dict $var [list [FALSE] [FALSE]]
    }

    # Initialise S with TRUE
    set S [TRUE]

    foreach abstraction $partition_abstraction {
        set expr [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        if {$expr in $tvar_expr_numbers} {
            set T [dict get $T_dict $expr]
            set T [list [OR [lindex $T 0] $hexpr] [OR [lindex $T 1] $lexpr]]
            dict set T_dict $expr $T
        } else {
            set S [AND $S [IMPLIES $hexpr $expr]]
            set S [AND $S [IMPLIES $lexpr [NOT $expr]]]
        }
    }

    return [list $S $T_dict]
}

#######################################
# Combines a dictionary of (expr: (highexpr, lowexpr)) into a single expression
# Used on the T component of a normalised abstractionq
#######################################
proc combine_abstraction_dict {abstraction_dict} {
    set combined_abstraction [TRUE]
    foreach key [dict keys $abstraction_dict] {
        set hexpr [lindex [dict get $abstraction_dict $key] 0]
        set lexpr [lindex [dict get $abstraction_dict $key] 1]

        set combined_abstraction [AND $combined_abstraction [IMPLIES $hexpr $key]]
        set combined_abstraction [AND $combined_abstraction [IMPLIES $lexpr [NOT $key]]]
    }
    return $combined_abstraction
}

#######################################
# Returns the domain of the abstraction efficiently using the normalised abstraction
#######################################
proc get_domain {abstraction_S abstraction_T} {
    set domain $abstraction_S
    foreach key [dict keys $abstraction_T] {
        set hexpr [lindex [dict get $abstraction_T $key] 0]
        set lexpr [lindex [dict get $abstraction_T $key] 1]
        set domain [AND $domain [NOT [AND $hexpr $lexpr]]]
    }
    return $domain
}

#######################################
# Preimage Computation with Partitioned Abstraction
#######################################
proc weak_preimage_part {abstraction_T domain predicate target_vars} {
    set free_vars [check_symsim -expression -depends $predicate]
    set relevant_target_vars [intersect $free_vars $target_vars]

    if {[llength $relevant_target_vars] == 0} {
        return [AND $domain $predicate]
    } elseif {[dict exists $abstraction_T $predicate]} {
        set lexpr [lindex [dict get $abstraction_T $predicate] 1]
        return [AND $domain [NOT $lexpr]]
    } elseif {[dict exists $abstraction_T [NOT $predicate]]} {
        set hexpr [lindex [dict get $abstraction_T [NOT $predicate]] 0]
        return [AND $domain [NOT hexpr]]
    } else {
        set restricted_dict [dict create]
        foreach key [dict keys $abstraction_T] {
            if {[lsearch $relevant_target_vars $key] != -1} {
                dict set restricted_dict $key [dict get $abstraction_T $key]
            }
        }

        set RDownP [combine_abstraction_dict $restricted_dict]

        return [AND $domain [weak_preimage $RDownP $predicate $relevant_target_vars]]
    }
}

#######################################
# Combines a partititioned abstraction into a single abstraction
# For use with the basic indexing transformation
# The abstraction is a list of tuples (expr, highexpr, lowexpr)
# The combined abstraction is the conjunction of all the highexpr -> expr and lowexpr -> NOT expr
#######################################
proc combine_abstractions {abstractions} { 
    set combined_abstraction [TRUE]
    foreach abstraction $abstractions {
        # puts $abstraction
        set expr [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        set combined_abstraction [AND $combined_abstraction [IMPLIES $hexpr $expr]]
        set combined_abstraction [AND $combined_abstraction [IMPLIES $lexpr [NOT $expr]]]
    }
    return $combined_abstraction
}