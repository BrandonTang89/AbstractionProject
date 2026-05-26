# Copyright 2025 University of Oxford
# Licensed under the Apache License, Version 2.0 (see LICENSE for details).
# The underlying commands and reports of this script are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help
# promote and foster the next generation of innovators.
# Original Authors: Brandon Tang Yu Han and Julia Irvine

# === Implementation of the Automatic Abstraction algorithm from Adams, 2007 ===

# We're going to use the logical structure in the symsim module, and symsim_utils gives a much nicer way of expressing that
source ../CommonUtils_Brandon/symsim_utils.tcl

namespace import symsim::*
proc IMPL {x y} {check_symsim -expression -implies $x $y}

# A (pretty terrible) way to get the type of gate driving a given signal
# This is really bad, because the only way I've found to do this is to get the verilog expression driving a signal
# This code is naieve and presumes that every signal we're going to care about is driven by either binary and, unary not, or binary xnor.
# (This can be extended in the future assuming we find a better way of extracting the driving expression)

proc extract_gate_expr {sig} {
    set expr_list [get_fanin -show_expr $sig]
    return [lindex $expr_list 0]
}

proc is_AND {sig} {
    set expr [extract_gate_expr $sig]
    set nScanned [scan $expr {(%s && %s)} opA opB]
    # return true if both tokens were scanned successfully i.e. this is a && expr
    if {$nScanned == 2} {
        return 1
    }
    return 0
}

proc destruct_AND {sig} {
    return [get_fanin $sig]
}

proc is_NOT {sig} {
    set expr [extract_gate_expr $sig]
    set nScanned [scan $expr {(~%s)} opA]

    if {$nScanned == 1} {
        return 1
    }
    return 0
}

proc strip_NOT {sig} {
    return [get_fanin $sig]
}

proc is_VAR {sig} {
    set inclusion [expr {$sig in [check_symsim -model [check_symsim -model -get] -list input]}]
    set fanin_size [llength [check_symsim -model -get_sig_fanin $sig]]
    if {$inclusion || $fanin_size == 0} {
        return 1
    }
    return 0
}

variable ivar_index
set ivar_index 0

# Convention: free variables have name `x_*`, variables generated from a signal have name `v_*`

proc fresh_var {} {
    variable ivar_index
    set ivar_index [expr {$ivar_index + 1}]
    puts [concat "generating fresh var" $ivar_index]
    return [VAR "x_$ivar_index"]
}

proc simple_bp {root high low} {
    if {[is_VAR $root]} {
        set t [VAR v_$root]
        return [AND [IMPL $high $t] [IMPL $low [NOT $t]]]
    } elseif {[is_NOT $root]} {
        return [simple_bp [strip_NOT $root] $low $high]
    } else {
        if {[expr {![is_AND $root]}]} {
            error [concat "unknown expression in fanin for " $root]
            return 0
        }

        set x [fresh_var]

        set e1e2 [destruct_AND $root]
        set e1 [lindex $e1e2 0]
        set e2 [lindex $e1e2 1]
        set r1 [simple_bp $e1 $high [AND $low $x]]
        set r2 [simple_bp $e2 $high [AND $low [NOT $x]]]
        puts $r1
        puts [PR $r2]
        return [AND $r1 $r2]
    }
}
