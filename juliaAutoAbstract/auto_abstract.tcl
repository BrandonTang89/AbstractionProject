
source auto_abstract_simple.tcl

proc freevars_signal {sig} {
    return [get_fanin -transitive $sig -filter_out non_boundary -silent]
}

# Returns true if a is a subset (possibly equality) of b
proc is_subset {a b} {
    foreach x $a {
        if {[lsearch $b x] == -1} {
            return 0
        }
    }

    return 1
}

# Converts a signal (which is described as a bexpr in the paper) to a STE variable.
proc bexpr2bdd {sig} {
    return [VAR v_$root]
}

# Is the 'behavior' driving a signal an XNOR? (uses the same ugly/unstable logic as that in auto_abstract_simple)
proc is_XNOR {sig} {
    set expr [extract_gate_expr $sig]
    set nScanned [scan $expr {~(%s ^ %s)} opA opB]
    # return true if both tokens were scanned successfully i.e. this is a && expr 
    if {$nScanned == 2} {
        return 1
    }
    return 0
}

# Extracts the signal names out of a XNOR
proc destruct_XNOR {sig} {
    return [get_fanin $sig]
}

# Get the input signals to an XNOR, ensuring that if any signals depend fully on C, they come first
proc sort_inp_args {C sig} {
    set sigs [destruct_XNOR $sig]
    if {[is_subset [freevars_signal [lindex $sigs 1]] C]} {
        return [lreverse $sigs]
    }
    return $sigs
}

proc get_case_exprs {name n} {
    # for now, only deal with n=2
    if {$n != 2} {
        error "get_case_exprs for n!=2 is currently unimplemented"
    }

    return [list [VAR c_$name] [NOT [VAR c_$name]]]
}

proc make_same_names {name n} {
    set names [list]
    for {set i 1} {$i < $n} {incr i} {
        lappend names $name
    }
    return $names
}

proc make_unique_names {name n} {
    set names $name\_0
    for {set i 1} {$i < $n} {incr i} {
        lappend names $name\_$i
    }
    return $names
}

# TODO work for more than one AND
proc find_big_ands {sig C} {
    set is [destruct_AND $sig]
    set cis [list]
    set oinps [list]
    foreach i $is {
        if {[is_subset [freevars_signal $i] C]} {
            lappend cis $i
        } else {
            lappend oinps $i
        }
    }

    return [list cis oinps]
}

