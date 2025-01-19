# Symbolically simulates **only** the immediate fanin of a wire, to essentially find it's behavior

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir auto_abstract.tcl]


proc simulate_unit {sig} {
    if {[dict get [check_symsim -model -get_sig_info $sig] type] != "wire"} {
        error "can't simulate $sig : has state!"
        return
    }

    set inclusion [expr {$sig in [check_symsim -model [check_symsim -model -get] -list input]}]
    set fanin_size [llength [check_symsim -model -get_sig_fanin $sig]]
    if {$inclusion || $fanin_size == 0} {
        error "can't simulate $sig : is input!"
    }

    # We do not want any dynamic weakening, since we're just simulating a single component
    set_symsim_bdd_dynamic_weakening_size_limit 0

    set inputs [check_symsim -model -get_sig_fanin $sig]
    set behavior_rails [check_symsim -model -get_sig_excitation $sig]
    set high_rail [lindex $behavior_rails 0]
    set low_rail [lindex $behavior_rails 1]

    # workaround for bug where inspecting the rails will fail
    # unless they've been used somewhere else first
    AND $high_rail [VAR x]
    AND $low_rail [VAR x]

    # substitute in the high and low rails for the signals themselves
    # this behavior might need to change in the future

    set subs [dict create]
    
    # docs state that it should be indexed by 0; actual behavior appears to index by 1
    set i 1
    puts $inputs
    foreach input $inputs {
        set name_h H$i
        set name_l L$i
        incr i
        dict append subs $name_h [VAR $input]
        dict append subs $name_l [NOT [VAR $input]]
    }

    return [check_symsim -expression -substitute $high_rail $subs]

}
 
# Take the union of two lists, removing duplicates
# https://stackoverflow.com/a/42959687
proc list_union {list1 list2} {
    return [lsort -unique [list {*}$list1 {*}$list2]]
}

# is a BDD node a terminal one (i.e. either just true or false)
proc bdd_is_terminal {bdd} {
    if {$bdd == [TRUE] || $bdd == [FALSE]} {
        return true
    }

    return false
}

# returns the 'type' of a (reduced) BDD node when represented as a MUX gate
# can be one of the following values, depending on if the inputs to the MUX gate are 'real' wires or high/low constants:
#  'mux_null'       /- the switching input is a constant (shouldn't occur in a ROBDD; included for completeness)
#  'mux_one'        !- one of the switched inputs is a constant
#  'mux_invert'    !!- both switching inputs are constant, and represents an inversion of the switching input
#  'mux_wire'      !!- both switching inputs are constant, and does not invert the switching input
#  'mux_const'     !!- both switching inputs are constant and represent the same value (shoudn't occur in a ROBDD; included for completeness)
#  'mux_full'       \- no constants; the switching input and both switched ones are wires
# used to determine which case of the MUX abstraction to use
proc bdd_mux_type {bdd} {
    set inputs [TC $bdd]

    set var [lindex $inputs 0]
    set sigHigh [lindex $inputs 1]
    set sigLow [lindex $inputs 2]

    if {[bdd_is_terminal $sigHigh] && [bdd_is_terminal $sigLow]} {
        if {$sigHigh == [TRUE] && $sigLow == [TRUE]} {
            return "mux_const"
        } elseif {$sigHigh == [TRUE] && $sigLow == [FALSE]} {
            return "mux_wire"
        } elseif {$sigHigh == [FALSE] && $sigLow == [TRUE]} {
            return "mux_invert"
        } else {
            return "mux_const"
        }
    } elseif {[bdd_is_terminal $sigHigh] || [bdd_is_terminal $sigLow]} {
        # exactly one is terminal
        return "mux_one"
    } else {
        # none are terminal
        return "mux_full"
    }    
}

# performs the abstraction step on a BDD tree
# returns what the relation should be according to the node's type
proc bdd_mux_abstract {bdd high low} {
    set inputs [TC $bdd]

    set var [lindex $inputs 0]
    set sigHigh [lindex $inputs 1]
    set sigLow [lindex $inputs 2]

    set mux_type [bdd_mux_type $bdd]

    if {$mux_type == "mux_wire"} {
        # then pass everything through to the switching signal
        return [bdd_abstract $var $high $low]
    } elseif {$mux_type == "mux_invert"} {
        return [bdd_abstract $var $low $high]
    } elseif {$mux_type == "mux_const"} {
        error "mux_const hit! this shouldn't happen if the bdd is reduced and it's unclear what to do here"
    } elseif {$mux_type == "mux_full"} {
        set x [fresh_var]
        set var_ab [bdd_abstract $var $x [NOT $x]]
        set sigHigh_ab [bdd_mux_abstract $sigHigh [AND $x $high] [AND $x $low]]
        set sigLow_ab [bdd_mux_abstract $sigLow [AND [NOT $x] $high] [AND [NOT $x] $low]]

        # return [AND [IMPL $var_ab $sigHigh_ab] [IMPL [NOT $var_ab] $sigHigh_ab]]
        return [list_union [list_union $var_ab $sigHigh_ab] $sigLow_ab]
    } elseif {$mux_type == "mux_one"} {
        # if one of the inputs is constant, then the mux reduces down to a single AND gate with some inversions

        # Controls if not gates should be inserted on the output of the MUX gate, switching input, and non-constant switched input respectively
        set invert_out false
        set invert_sw false
        set invert_in false

        if {[bdd_is_terminal $sigHigh]} {
            if {$sigHigh == [TRUE]} {
                set invert_out true
                set invert_sw true 
                set invert_in true
            } else {
                set invert_sw true
            }
        } else {
            if {$sigLow == [TRUE]} {
                set invert_out true
                set invert_in true
            } else {
                # no inversion needed
            }
        }

        set high_temp $high
        set low_temp $low

        if {$invert_out} {
            set high_temp $low
            set low_temp $high
        }

        set x [fresh_var]
        set high_sw $high_temp
        set low_sw [AND $low_temp $x]
        set high_in $high_temp
        set low_in [AND $low_temp [NOT $x]]

        if {$invert_sw} {
            set temp $high_sw
            set high_sw $low_sw
            set low_sw $temp
        }

        if {$invert_in} {
            set temp $high_in
            set high_in $low_in
            set low_in $temp
        }

        set r1 [bdd_abstract $var $high_sw $low_sw]
        if {[bdd_is_terminal $sigHigh]} {
            set r2 [bdd_mux_abstract $sigLow $high_in $low_in]
        } else {
            set r2 [bdd_mux_abstract $sigHigh $high_in $low_in]
        }

        return [list_union $r1 $r2]
    }

    error $mux_type
}

# performs the abstraction step on a signal
# for now just convert the signal to a bdd and use the above mux_abstract
# but this shall have more in it when / if we want to implement non-combinatorial components
proc bdd_abstract {sig high low} {
    puts "abstracting $sig $high $low"
    if {[is_VAR $sig]} {
        set t [VAR v_$sig]
        #return [AND [IMPL $high $t] [IMPL $low [NOT $t]]]
        return [list [list $t $high $low]]
    }

    set bdd [simulate_unit $sig]
    return [bdd_mux_abstract $bdd $high $low]
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