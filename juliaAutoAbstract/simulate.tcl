# Symbolically simulates **only** the immediate fanin of a wire, to essentially find it's behavior

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir auto_abstract.tcl]
source [file join $baseDir simulate.tcl]


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

proc bdd_mux_one_type {bdd} {
    set inputs [TC $bdd]

    set var [lindex $inputs 0]
    set sigHigh [lindex $inputs 1]
    set sigLow [lindex $inputs 2]

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

    return [list $invert_out $invert_sw $invert_in]
}

# recursively traverses a tree, looking for sequences of AND gates
# note that just mux_one isn't sufficient, since intervening inversions spoil the AND structure
# however double inversions can be eliminated safely
# returns a list of pairs {node, inverted}, where inverted is true if the node terminates with a NOT gate
#
# the efficiency of this function could be increased by memoizing simulate, since we're computing things that could be reused later
# but the gain is tiny and in a large circuit could drastically increase memory consumption since bdd nodes could never be freed
#
# the size of the output depends on the BDD ordering -- perhaps it's possible to find orderings that give maximal size somehow?
proc find_big_ands {bdd needsinvert} {

    set inputs [TC $bdd]
    set var [lindex $inputs 0]

    set mux_type [bdd_mux_type $bdd]

    if {$mux_type != "mux_one"} {
        if {$mux_type == "mux_wire" || $mux_type == "mux_invert"} {
            if {$mux_type == "mux_invert"} {
                set needsinvert [expr {!$needsinvert}]
            }

            if {[is_VAR $var]} {
                # if the node is an input, terminate the process
                return [list [list $var $needsinvert]]
            } else {
                return [find_big_ands [simulate_unit $var] $needsinvert]
            }
        } else {
            puts "returned early $bdd [bdd_mux_type $bdd]"
            return [list [list $bdd $needsinvert]]
        }
    }

    set sigIn [lindex $inputs 1]
    if {[bdd_is_terminal $sigIn]} {
        set sigIn [lindex $inputs 2]
    }

    set invert_list [bdd_mux_one_type $bdd]

    set invert_out [lindex $invert_list 0]
    set invert_sw [lindex $invert_list 1]
    set invert_in [lindex $invert_list 2]

    if {$invert_out != $needsinvert} {
        # inversion violation, the and gate ends here
        puts "inversion violation $bdd"
        return [list [list $bdd $needsinvert]]
    }

    # okay, this is an and gate that is consistent with it's ancestors, so we can recurse down it's inputs
    if {[is_VAR $var]} { 
        # stop recursing, since this is a variable
        set sw_and_list [list [list $var $needsinvert]]
    } else {
        set sw_and_list [find_big_ands [simulate_unit $var] $invert_sw]
    }
    set in_and_list [find_big_ands $sigIn $invert_in]

    puts "normal $sw_and_list $in_and_list"
    return [list_union $sw_and_list $in_and_list]
}

# creates fresh boolean variables for at least n cases, and returns those cases
proc get_case_exprs {n} {
    return [lrange [get_case_exprs_rec $n 2] 0 [expr {$n - 1}]]
}

proc get_case_exprs_rec {n i} {
    set x [fresh_var]
    if {$i >= $n} {
        return [list $x [NOT $x]]
    } else {
        set cases [get_case_exprs_rec $n [expr {$i * 2}]]
        set cases_pos [lmap case $cases {AND $x $case}]
        set cases_neg [lmap case $cases {AND [NOT $x] $case}]

        return [list_union $cases_pos $cases_neg]
    }
}


# performs the abstraction step on a BDD tree
# returns an _abstraction list_ of triples (node, high, low)
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
   

        set invert_list [bdd_mux_one_type $bdd]

        # Controls if not gates should be inserted on the output of the MUX gate, switching input, and non-constant switched input respectively
        set invert_out [lindex $invert_list 0]
        set invert_sw [lindex $invert_list 1]
        set invert_in [lindex $invert_list 2]

        set and_operands [find_big_ands $bdd $invert_out]
        puts "ops: $and_operands"
        set and_cases [get_case_exprs [llength $and_operands]]

        set high_temp $high
        set low_temp $low

        if {$invert_out} {
            set high_temp $low
            set low_temp $high
        }

        # TODO add the names optimisation hereS
        set result [list]
        foreach op $and_operands case $and_cases {
            puts "op: $op, case: $case"
            set next_sig [lindex $op 0]
            set invert [lindex $op 1]

            if {$invert} {
                set result [list_union $result [bdd_abstract $next_sig [AND $low_temp $case] $high_temp]]
            } else {
                set result [list_union $result [bdd_abstract $next_sig $high_temp [AND $low_temp $case]]]
            }
        }

        return $result
    }

    error $mux_type
}

# performs the abstraction step on a signal
# for now just convert the signal to a bdd and use the above mux_abstract
# but this shall have more in it when / if we want to implement non-combinatorial components
# returns an _abstraction list_ of triples (node, high, low)
proc bdd_abstract {sig high low} {
    puts "abstracting $sig $high $low"
    
    # quick continue if we somehow get passed a bdd node
    if {[string is digit $sig]} {
            return [bdd_mux_abstract $sig $high $low]
    }


    if {[is_VAR $sig]} {
        set t [VAR v_$sig]
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