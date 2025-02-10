# === Common utilites ===

source ../CommonUtils_Brandon/symsim_utils.tcl

namespace import symsim::*

proc IMPL {x y} {check_symsim -expression -implies $x $y}

proc TC {sig} {
    return [check_symsim -expression -top_cofactor $sig]
}

proc is_VAR {sig {cut_points ""}} {

    set inclusion [expr {$sig in [check_symsim -model [check_symsim -model -get] -list input]}]
    set fanin_size [llength [check_symsim -model -get_sig_fanin $sig]]

    # NOTE: fanin_size being zero isn't enough to know if we're an input or not
    # Jasper does an optimisation where it erases elements from the fanin of a component if the component's output is constant
    # e.g. a XOR gate with both inputs wired together 
    # TODO figure out how to consistently fix this -- it's not a priority because it only arises in artificial cases rn
    # and the cases where it does happen will be fixed by the fanout resolution maybe?
    if {$inclusion || $fanin_size == 0 || ($sig in $cut_points)} {
        return 1
    }
    return 0
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


# Find the 'free variables' present in a given signal
# in circuit terminology this means the transitive fanin restricted to only inputs
proc freevars {sig} {
    # find all the signals listed in the bdd
    set sigs [list $sig]
    if {[string is digit $sig]} {
        set sigs [check_symsim -expression -depends $sig]
    }
    set trans_fanin [check_symsim -transitive_fanin -signals $sigs]
    set results [list]
    foreach s $trans_fanin {
        if {[is_VAR $s]} {
            lappend results $s
        }
    }
    return $results
}

# is a BDD node a terminal one (i.e. either just true or false)
proc bdd_is_terminal {bdd} {
    if {$bdd == [TRUE] || $bdd == [FALSE]} {
        return true
    }

    return false
}

# from https://wiki.tcl-lang.org/page/Performance+of+Various+Stack+Implementations by Lars Hellström
# pops a value from a list, removing and returning it
proc lpop listVar {
        upvar 1 $listVar l
        set r [lindex $l end]
        set l [lreplace $l [set l end] end] ; # Make sure [lreplace] operates on unshared object
        return $r
}

# Take the union of two lists, removing duplicates
# https://stackoverflow.com/a/42959687
proc list_union {list1 list2} {
    return [lsort -unique [list {*}$list1 {*}$list2]]
}


# Pretty-print an abstraction list
proc PRR {abs} {
    puts "============"
    foreach ab $abs {
        set x_str [lmap x $ab {PR $x}]
        puts "([lindex $x_str 0] -> [lindex $x_str 1] // [lindex $x_str 2])"
    }
    puts "============"
}

# Pretty-print an abstraction list, simplifying it first
proc PRRS {abs} {
    PRR [simplify_abs_list $abs]
}

# Get a list of discinct variables in an abstraction list
proc get_abs_vars {abs} {
    set vars [list]
    foreach ab $abs {
        set vars [list_union $vars [check_symsim -expression -depends [lindex $ab 1]]]
        set vars [list_union $vars [check_symsim -expression -depends [lindex $ab 2]]]
    }
    return $vars
}

# simplifies an abstraction list, compressing multiple guards for a certain wire into one
proc simplify_abs_list {abs} {
    set new_abs [dict create]
    foreach ab $abs {

        if {[dict exists $new_abs [lindex $ab 0]]} {
            set existing [dict get $new_abs [lindex $ab 0]]
            set high [OR [lindex $existing 0] [lindex $ab 1]]
            set low [OR [lindex $existing 1] [lindex $ab 2]]
            dict set new_abs [lindex $ab 0] [list $high $low]
        } else {
            dict set new_abs [lindex $ab 0] [list [lindex $ab 1] [lindex $ab 2]]
        }
    }

    set result [list]
    dict for {k v} $new_abs {
        lappend result [list $k [lindex $v 0] [lindex $v 1]]
    }

    return $result
}

# sanity-checks an abstraction list, checking if each property in the siplified form is mutex
proc abs_is_fully_mutex {abs} {
    set sabs [simplify_abs_list $abs]
    foreach ab $sabs {
        set var [lindex $ab 0]
        set high  [lindex $ab 1]
        set low [lindex $ab 2]

        if {[AND $high $low] != [FALSE]} {
            puts "mutex violation: ([PR $var] -> [PR $high] // [PR $low]) FAILS"
            puts "intersection: [AND $high $low]"
            return false
        }
    }
    return true
}


# finds a list of points with nontrivial fanout in the transitive fanin of a signal i.e. 'fanout points'
# we only return nontrivial fanout points; when a fanout point is an input it doesn't matter because there's no 'other side' to 
# have to deal with
proc get_fanout_points {sig} {
    set candidates [check_symsim -transitive_fanin -signals $sig]
    set results [list]

    foreach candidate $candidates {
        set fanout [check_symsim -model -get_sig_fanout $candidate]
        set count 0
        foreach f $fanout {
            if {$f in $candidates} {
                incr count
            }
        }
        if {$count >= 2} {
            if {![is_VAR $candidate]} {
                lappend results $candidate
            }
        }

    }

    return $results
}