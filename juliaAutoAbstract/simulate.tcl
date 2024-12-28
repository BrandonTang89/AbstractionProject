# Symbolically simulates **only** the immediate fanin of a wire, to essentially find it's behavior

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir auto_abstract.tcl]


proc simulate_unit {sig} {
    if {[get_signal_info -logic $sig] != "wire"} {
        error "can't simulate $sig : has state!"
        return
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

    # Fill this in if sig_excitation somehow fails!

    # Create a sequence with variables driving each input signal

    # Run a simulation, only caring about our inputs and $sig

    # Extract the observed behavior on the signal

}

