# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir auto_abstract_simple.tcl]

proc TC {sig} {
    return [check_symsim -expression -top_cofactor $sig]
}

proc freevars_signal {sig} {
    if {[get_signal_info $sig] == "input"} {
        # special case: if we have an input variable, it's fanin will be empty, but it drives itself.
        return $sig
    }
    return [get_fanin -transitive $sig -filter_out non_boundary -silent]
}

# Returns true if a is a subset (possibly equality) of b
proc is_subset {a b} {
    foreach x $a {
        if {!($x in $b)} {
            return 0
        }
    }

    return 1
}

# Converts a signal (which is described as a bexpr in the paper) to a STE variable.
proc bexpr2bdd {sig} {
    return [VAR v_$sig]
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

# removed, i have a better version
#proc get_case_exprs {name n} {
#    # for now, only deal with n=2
#    if {$n != 2} {
#        error "get_case_exprs for n!=2 is currently unimplemented (your n: $n)"
#    }
#
#    return [list [VAR c_$name] [NOT [VAR c_$name]]]
#}

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

    return [list $cis $oinps]
}

proc big_AND {ops} {
    if {[llength $ops] == 0} {
        return [TRUE]
    } elseif {[llength $ops] == 1} {
        return [bexpr2bdd [lindex $ops 0]]
    } else {
        return [AND [bexpr2bdd [lindex $ops 0]] [big_AND [lrange $ops 1 end]]]
    }
}


proc advanced_bp {C sig high low name} {
    if {[is_subset [freevars_signal $sig] $C] || [is_VAR $sig]} {
        return [list [list [bexpr2bdd $sig] $high $low]]
    } elseif {[is_XNOR $sig]} {
        set is [sort_inp_args $C $sig]
        if {[is_subset [freevars_signal [lindex $is 0]] C]} {
            set c [bexpr2bdd $sig]
            # TODO I don't understand what this `h c` notation does... there isn't really an obvious free variable to substitute for...
            # I _think_ it's just going to be (h AND c) but I need to think about this some more (why not just write that in the paper if it's the case!)

            # NOTE: it looks like it might be AND, as I suspected
            error "xnor implementation unfinished"
        } else {
            set xs [get_case_exprs $name 2]
            set ns [make_unique_names $name 2]
            error "xnor implementation unfinished"
        }
    } elseif {[is_NOT $sig]} {
        return [advanced_bp $C [strip_NOT $sig] $low $high $name]
    } elseif {[is_AND $sig]} {
        set cisoinps [find_big_ands $sig $C]
        set cis [lindex $cisoinps 0]
        set oinps [lindex $cisoinps 1]
        set noinps [llength $oinps]
        set c [big_AND $cis]
        set res [list]
        if {[llength $cis] > 0} {
            lappend res [list $c $high [FALSE]]
        }
        set cases [get_case_exprs $name $noinps]
        if {$high == [FALSE]} {
            # TODO: does this require that high is actually syntactically false or just that it is UNSAT
            set names [make_same_names $name $noinps]
        } else {
            set names [make_unique_names $name $noinps]
        }

        foreach b $oinps s $cases n $names {
            set res [concat $res [advanced_bp $C $b $high [AND $low [AND $s $c]] $n]]
        }

        return $res
    } else {
        error [concat "unknown expression in fanin for " $sig]
        return [list]
    }
}


proc PR_bp {triples} {
    foreach triple $triples {
        puts [concat [PR [lindex $triple 0]] "<-" [PR [lindex $triple 1]] "//" [PR [lindex $triple 2]]]
    }
}
