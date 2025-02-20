# facilites for creating a list of signals that depend entirely on some other set

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir utils.tcl]

proc forward_prop {constants} {
    set result $constants

    # Stores if we're done; any operation that updates $result in this proc must set it true
    set changed true

    while {$changed} {
        set changed false

        # TODO possible optimisation excluding 'dead' wires
        foreach in_sig $result {
            foreach out_sig [check_symsim -model -get_sig_fanout $in_sig] {
                if {$out_sig in $result} {
                    continue
                }

                if [is_subset [check_symsim -model -get_sig_fanin $out_sig] $result] {
                    set changed true
                    set result [list_union $result [list $out_sig]]
                }
            } 
        }
    }

    return $result
}

# returns if a bdd depends only on values in the constants list, or if a signal is in the constants list
proc is_const {constants bdd} {
    if {!([string is digit $bdd])} {
        if {$bdd in $constants} {
            return 1
        } else {
            return 0
        }
    }

    # note that we don't need to do this transitively -- once we get the signals, anything else is handled by
    # the forward propagation that's already been done.
    set freevars [check_symsim -expression -depends $bdd]
    return [is_subset $freevars $constants]
}