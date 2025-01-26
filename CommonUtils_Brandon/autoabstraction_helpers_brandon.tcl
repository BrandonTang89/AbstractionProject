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

# Combines a partititioned abstraction into a single abstraction
proc combine_abstractions {abstractions} { 
    set combined_abstraction [TRUE]
    foreach abstraction $abstractions {
        puts $abstraction
        set var [lindex $abstraction 0]
        set hexpr [lindex $abstraction 1]
        set lexpr [lindex $abstraction 2]

        set combined_abstraction [AND $combined_abstraction [IMPLIES $hexpr $var]]
        set combined_abstraction [AND $combined_abstraction [IMPLIES $lexpr [NOT $var]]]
    }
    return $combined_abstraction
}