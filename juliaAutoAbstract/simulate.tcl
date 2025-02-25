# Symbolically simulates **only** the immediate fanin of a wire, to essentially find it's behavior

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir utils.tcl]
source [file join $baseDir names.tcl]
source [file join $baseDir forward_prop_constants.tcl]
source [file join $baseDir environmental.tcl]


proc simulate_unit {sig cut_points} {
    memoize
    if {[dict get [check_symsim -model -get_sig_info $sig] type] != "wire"} {
        error "can't simulate $sig : has state!"
        return
    }

    if {[is_VAR $sig $cut_points]} {
        error "can't simulate $sig : is input!"
    }

    # We do not want any dynamic weakening, since we're just simulating a single component
    set_symsim_bdd_dynamic_weakening_size_limit 0

    set inputs [check_symsim -model -get_sig_fanin $sig]
    set behavior_rails [check_symsim -model -get_sig_excitation $sig]
    set high_rail [lindex $behavior_rails 0]
    set low_rail [lindex $behavior_rails 1]

    # workaround for bug where inspecting the rails will fail
    # unless they've been evaluated somewhere else first
    AND $high_rail [VAR x]
    AND $low_rail [VAR x]

    # substitute in the high and low rails for the signals themselves
    # this behavior might need to change in the future

    set subs [dict create]
    
    # docs state that it should be indexed by 0; actual behavior appears to index by 1
    set i 1
    foreach input $inputs {
        set name_h H$i
        set name_l L$i
        incr i
        dict append subs $name_h [VAR $input]
        dict append subs $name_l [NOT [VAR $input]]
    }

    return [check_symsim -expression -substitute $high_rail $subs]

}

proc transitive_simulate {bdd {cut_points ""}} {
    memoize

    if {![string is digit $bdd]} {
        # then we're dealing with a signal, rather than a BDD!

        if {[is_VAR $bdd $cut_points]} {
            return [VAR $bdd]
        }

        set bdd [simulate_unit $bdd $cut_points]
    }

    foreach sig [check_symsim -expression -depends $bdd] {
        set subs_dict [dict create $sig [transitive_simulate $sig $cut_points]]
        set bdd [check_symsim -expression -substitute $bdd $subs_dict]
    }

    return $bdd
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
    memoize

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
    memoize
    
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
proc find_big_ands {bdd needsinvert constants cut_points} {
    memoize

    set inputs [TC $bdd]
    set var [lindex $inputs 0]

    set mux_type [bdd_mux_type $bdd]

    if {$mux_type != "mux_one"} {
        if {$mux_type == "mux_wire" || $mux_type == "mux_invert"} {
            if {$mux_type == "mux_invert"} {
                set needsinvert [expr {!$needsinvert}]
            }

            if {[is_VAR $var $cut_points]} {
                # if the node is an input, terminate the process
                return [list [list $var $needsinvert]]
            } else {
                return [find_big_ands [simulate_unit $var $cut_points] $needsinvert $constants $cut_points]
            }
        } else {
            # puts "returned early $bdd [bdd_mux_type $bdd]"

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
        #puts "inversion violation $bdd"
        return [list [list $bdd $needsinvert]]
    }

    # okay, this is an and gate that is consistent with it's ancestors, so we can recurse down it's inputs
    if {[is_VAR $var $cut_points] || $var in $constants} { 
        # stop recursing, since this is a variable
        set sw_and_list [list [list $var $needsinvert]]
    } else {
        set sw_and_list [find_big_ands [simulate_unit $var $cut_points] $invert_sw $constants $cut_points]
    }
    set in_and_list [find_big_ands $sigIn $invert_in $constants $cut_points]

    # puts "normal $sw_and_list $in_and_list"

    return [list_union $sw_and_list $in_and_list]
}

# divides a list of signals and bdd nodes into two lists -- one where the signal or bdd depends on the constants, and one where they do not.
# this function works with the tuple-lists returned by find_big_ands
# it will also convert all the elements of the cis list to bdds, incorporating the 2nd element of the tuple
proc separate_and_signals {signals constants} {
    set cis [list]
    set oinps [list]

    foreach sig_tuple $signals {
        if {[is_const $constants [lindex $sig_tuple 0]]} {
            set $sig [lindex $sig_tuple 0]
            if {[string is digit $sig]} {
                set $sig [simulate $sig]
            }
            if {[lindex $sig_tuple 1]} {
                lappend cis [NOT $sig]
            } else {
                lappend cis $sig
            }
        } else {
            lappend oinps $sig_tuple
        }
    }

    return [list $cis $oinps]
}





# performs the abstraction step on a BDD tree
# returns an _abstraction list_ of triples (node, high, low)
proc bdd_mux_abstract {bdd high low name {constants ""} {cut_points ""}} {
    set inputs [TC $bdd]

    set var [lindex $inputs 0]
    set sigHigh [lindex $inputs 1]
    set sigLow [lindex $inputs 2]

    if {[is_const $constants $bdd]} {
        #puts "a>>>>>>>>>>>>>>> $bdd <<<<<<<<<<<<<<<<<< $constants $cut_points"
        # ignore cut points for this transitive simulation, since we want to cross boundaries here
        set t [transitive_simulate $bdd]
        return [list [list $t $high $low]]
    }

    set mux_type [bdd_mux_type $bdd]

    # puts "type: $mux_type"


    if {$mux_type == "mux_wire"} {
        # then pass everything through to the switching signal
        return [bdd_abstract $var $high $low $name $constants $cut_points]
    } elseif {$mux_type == "mux_invert"} {
        return [bdd_abstract $var $low $high $name $constants $cut_points]
    } elseif {$mux_type == "mux_const"} {
        error "mux_const hit! this shouldn't happen if the bdd is reduced and it's unclear what to do here"
    } elseif {$mux_type == "mux_full"} {
        set x_name [lindex [make_unique_names $name 1] 0]
        set x [VAR $x_name]

        # handle fconstants on the switching input
        if {[is_const $constants $var]} {
            set x [transitive_simulate $var]
            set var_ab ""
        } else {
            set var_ab [bdd_abstract $var [AND [OR $high $low] $x] [AND [OR $high $low] [NOT $x]] $x_name $constants $cut_points]
        }

        # due to the variable ordering condition, it's impossible for these to be fconstants when sig is not
        # so we can in particular ignore the case where both are fconstant and the switching input is not
        # furthermore it's impossible for all three to be fconstant; that would be covered by the base case at the top of the function
        # so we need only handle the case where either none, or exactly one is fconstant

        if {![is_const $constants $sigHigh]} {
            set sigHigh_ab [bdd_mux_abstract $sigHigh [AND $x $high] [AND $x $low] $x_name $constants $cut_points]
        } else {
            set sigHigh_ab [list [list [transitive_simulate $sigHigh] [AND $x $high] [AND $x $low]]]
        }

        if {![is_const $constants $sigLow]} {
            set sigLow_ab [bdd_mux_abstract $sigLow [AND [NOT $x] $high] [AND [NOT $x] $low] $x_name $constants $cut_points]
        } else {
            set sigLow_ab [list [list [transitive_simulate $sigLow] [AND [NOT $x] $high] [AND [NOT $x] $low]]]
        }
        
        return [list_union [list_union $var_ab $sigHigh_ab] $sigLow_ab]


    } elseif {$mux_type == "mux_one"} {
        # if one of the inputs is terminal, then the mux reduces down to a single AND gate with some inversions
   

        set invert_list [bdd_mux_one_type $bdd]

        # Controls if not gates should be inserted on the output of the MUX gate, switching input, and non-constant switched input respectively
        set invert_out [lindex $invert_list 0]
        set invert_sw [lindex $invert_list 1]
        set invert_in [lindex $invert_list 2]

        set and_operands_raw [find_big_ands $bdd $invert_out $constants $cut_points]
        set and_operands_pair [separate_and_signals $and_operands_raw $constants]
        set and_operands_const [lindex $and_operands_pair 0]
        set and_const_combined [check_symsim -expression -and $and_operands_const]
        set and_operands [lindex $and_operands_pair 1]

        set and_cases [get_case_exprs [llength $and_operands] $name]
        set and_names [make_unique_names $name [llength $and_operands]]

        set high_temp $high
        set low_temp $low

        if {$invert_out} {
            set high_temp $low
            set low_temp $high
        }

        # really good optimisation!
        if {$high_temp == [FALSE]} {
            set and_names [make_same_names $name [llength $and_operands]]
        }

        if {$and_const_combined eq [TRUE]} {
            set result [list]
        } else {
            set result [list [list $and_const_combined $high [FALSE]]]
        }
        foreach op $and_operands case $and_cases x_name $and_names {
            set next_sig [lindex $op 0]
            set invert [lindex $op 1]

            if {$invert} {
                set result [list_union $result [bdd_abstract $next_sig [AND $low_temp [AND $case $and_const_combined]] $high_temp $x_name $constants $cut_points]]
            } else {
                set result [list_union $result [bdd_abstract $next_sig $high_temp [AND $low_temp [AND $case $and_const_combined]] $x_name $constants $cut_points]]
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
proc bdd_abstract {sig high low name {constants ""} {cut_points ""}} {
    # puts "abstracting $sig $high $low // $constants"

    # quick continue if we somehow get passed a bdd node
    # FIXME can wire names be purely digits? i doubt it but good to check
    if {[string is digit $sig]} {
            return [bdd_mux_abstract $sig $high $low $name $constants $cut_points]
    }

    if {[is_subset [freevars $sig] $constants]} {
        # puts ">>>>>>>>>>>>>>>> $sig <<<<<<<<<<<<<<<<<< $constants $cut_points"

        set t [transitive_simulate $sig]
        return [list [list $t $high $low]]
    }


    if {[is_VAR $sig $cut_points]} {
        set t [VAR $sig]
        return [list [list $t $high $low]]
    }


    time {set bdd [simulate_unit $sig $cut_points]}
    return [bdd_mux_abstract $bdd $high $low $name $constants $cut_points]
}

# main abstraction entry point
proc autoabstract {sig high low {constants ""} {constraints ""}} {

    puts "Step 1: Resolving Environmental Constraints"
    

    
    puts "Step 2: Backpropagation"

    # find the total area of the circuit covered by constants
    set constants [forward_prop_const $constants]

    # find any fanout points 
    set cut_points [get_fanout_points $sig]
    
    # force any symbolic constants to appear as first in any BDDs
    # this means we cannot have situations where a MUX gate has a constant on a signalling wire but not a switching one
    # note this might overwrite any user-defined variable ordering!
    if {[llength $constants] > 0} {
        #puts "Applying constants variable ordering..."

        # HACK to force the variable order to actually be replaced. Normally, if the given list is already consistent with the variable ordering
        # the current ordering will be maintained, which is contrary to our goal of ensuring our constants are first
        check_symsim -var_order -set [list H2 H1]
        check_symsim -var_order -set $constants
        #puts [check_symsim -var_order -get]
    }

    set initial_abstraction [bdd_abstract $sig $high $low x $constants $cut_points]

    set abstractions [dict create]

    foreach cut_point $cut_points {
        
        # remove the current cut point from the list, so the abstraction algorithm doesn't immediately halt
        set i [lsearch -exact $cut_points $cut_point]
        set cut_points_without [lreplace $cut_points $i $i]

        #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TOPLEVEL ABSTRACTING $cut_point // $cut_points_without"
        # run the abstraction for the cut point, using new base names $cut_point\_x for uniqueness.
        dict set abstractions [VAR $cut_point] [bdd_abstract $cut_point [VAR vh_$cut_point] [VAR vl_$cut_point] $cut_point\_x $constants $cut_points_without]
        PRR [dict get $abstractions [VAR $cut_point]]
    }

    # now we need to merge all the sets of triples in the abstractions dict. 
    # starting with the initial one, we look for wires that are represented in the dict, do the substitution, and merge them in
    # note that everything is simplified, because we only want to deal with single triples for each substitution
    set changed true
    set result $initial_abstraction

    puts "Step 3: Merging"

    while {$changed} {
        set changed false 
        set result [simplify_abs_list $result]

        foreach ab $result {
            set ab_var [lindex $ab 0]
            set h_v [lindex $ab 1]
            set l_v [lindex $ab 2]

            

            if {[dict exists $abstractions $ab_var]} {
                #puts "> Merging abstraction for [PR $ab_var]"
                set T_O [dict get $abstractions $ab_var]
                set T_O_updated [list]

                set abstractions [dict remove $abstractions $ab_var]

                foreach triple $T_O {
                    set replaced_var [lindex $triple 0]
                    set high [lindex $triple 1]
                    set low [lindex $triple 2]
                    #puts ">> Substituting through [PR $replaced_var]"

                    set subs [dict create vh_[trim [PR $ab_var]] $h_v vl_[trim [PR $ab_var]] $l_v ]
                    

                    set high [check_symsim -expression -substitute $high $subs]
                    set low [check_symsim -expression -substitute $low $subs]

                    lappend T_0_updated [list $replaced_var $high $low]
                }


                set result [list_union $result $T_0_updated]

                # break out of the loop because we need to do another simplification step
                # and mutating the loop we're iterating over could lead to strange states
                set changed true
                break
            }
        }
    } 

    # clear out the memoization dictionary; the circuit may be changed before we're called again
    global memo
    unset memo 

    return $result

}