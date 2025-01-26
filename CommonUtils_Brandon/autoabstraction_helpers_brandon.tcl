proc rename_partition_abstraction {partition_abstraction inputs} {
    # rename every v_xxx to just xxx to be consistent with create_dual_rail_antecedent
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
# Where the indexing relation is S[xs]and T[xs, ts]
# S[xs] contains no target variables, formed from tuples of the form (SymbolicConstBDD, highexpr, lowexpr)
# T[xs, ts] = AND_(target variables ti) (highexpr -> ti) AND (lowexpr -> NOT ti)

# We return T as a dictionary from target variables to (highexpr, lowexpr)
# We return S as a BDD expression

# Note that this will not work if we do param over the indexing relation since we will have functions of target variables
#######################################
proc normalise_abstraction {partition_abstraction target_variables} {
    # Initialise T_dict with var -> (false, false)
    set T_dict [dict create]
    foreach var $target_variables {
        dict set T_dict $var [list [FALSE] [FALSE]]
    }

    # Initialise S with TRUE
    set S [TRUE]

    foreach abstraction $partition_abstraction {
        set expr [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        if {$expr in $target_variables} {
            set T [dict get $T_dict $expr]
            set T [list [OR [lindex $T 0] $hexpr] [OR [lindex $T 1] $lexpr]]
            dict set T_dict $expr $T
        } else {
            set S [AND $S [IMPLIES $hexpr $expr]]
            set S [AND $S [IMPLIES $lexpr [NOT $expr]]]
        }

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
        puts $abstraction
        set expr [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        set combined_abstraction [AND $combined_abstraction [IMPLIES $hexpr $expr]]
        set combined_abstraction [AND $combined_abstraction [IMPLIES $lexpr [NOT $expr]]]
    }
    return $combined_abstraction
}