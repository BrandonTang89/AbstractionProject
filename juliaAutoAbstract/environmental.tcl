# Tools for handling environmental conditions

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir utils.tcl]


# Runs the parameterisation algorithm on the provided expression list, TODO not parameterising over the list of excluded variables 
proc run_param {expr_list} {
    set result [check_symsim -param -expressions $expr_list]

    set success [dict get $result exit_status]

    if {$success != "completed"} {
        error "Failed to resolve paramaterisation! Reason: $success"
    }

    set consts [dict get $result param_res const_subst]
    set symbs [dict get $result param_res symb_subst]

    return [list $consts $symbs]
}

# Similar to the algorithm in forward_prop_constants.tcl, we take a list of wires that have 
# concrete values obtained from the parameterisation process and propagate them through the circuit 
# to obtain an assignment of some wires to concrete values
# NOTE !! using this may break certain assertions in the main backprop algorithm, I need to figure out how they can be resolved.
# We need to take in the symbolic constraints too, since they may lead to additional wires being statically high or low.
# e.g. a env- constraint expressing X xor Y, and then a XOR (X, Y) gate in the circuit. 
proc forward_prop_concrete {consts symbs} {
    # approach 1 idea: run a symbolic simulation of the circuit with everything X except the concrete values and the parameterised nodes
        # but uh oh complexity, runtime, other such issues. kind of want to avoid this
        # although the work only needs to be done once; unlikely for env. conditions to change between runs of a circuit
    # approach 2: manually take a user provided list of wires brought high or low by the env constraints
        # this approach is preferred because then it's not my problem

    # TODO: DISCUSS WITH TOM ON BEST APPROACH TOMORROW
    # for now i'll just do naieve normal const propagation

    
    set result [dict merge $consts $symbs]
     

    # Stores if we're done; any operation that updates $result in this proc must set it true
    set changed true

    while {$changed} {
        set changed false

        # somehow find only things with complete fanin (or as complete as is going to get)
        # substitute in the result dict

        # while not done
            # iterate through the list of constraints
            # substitute the constrained value into the behavior of everything in the fanout
            # if any of those fanout wires are now concrete, add them to the result
            # if nothing changed, done 

        dict for {in_sig in_val} $result {
            foreach out_sig [check_symsim -model -get_sig_fanout $in_sig] {
                # TODO
            } 
        }
    }

    return $result
}

# the idea is to take this set of constants, go one step further subbing them into their own fanout, and using that as the behavior of those wires
# which avoids us _ever_ getting to a state where we're recursing into a constant which is what breaks the algorithm
    # we'll miss some things that could be deduced e.g. the xor constraint on a xor gate. but I think that's fine? some experiementation is needed here
        # a perfect abstraction is not required.


