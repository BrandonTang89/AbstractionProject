# facilites for manufacturing unique and same names

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]
source [file join $baseDir utils.tcl]

set BASE x

proc make_unique_names {base n} {
    set names [list]
    for {set i 0} {$i < $n} {incr i} {
        lappend names $base\_$i
    }
    return $names
}

proc make_same_names {base n} {
    set names [list]
    for {set i 0} {$i < $n} {incr i} {
        lappend names $base\_
    }
    return $names
}

# creates fresh boolean variables for at least n cases, and returns those cases
proc get_case_exprs {n name} {
    set case_names [make_unique_names $name $n]
    return [lrange [get_case_exprs_rec $n $n $case_names] 0 [expr {$n - 1}]]
}

proc get_case_exprs_rec {n i names} {
    set x_name [lpop names]
    set x [VAR $x_name]

    if {$i == 1} {
        return [TRUE]
    }

    set merging [expr $i % 2 == 1]
    if {$merging} {
        set i [expr $i + 1]
    }
    set i [expr $i / 2]


    set cases [get_case_exprs_rec $n $i $names]
    set cases_pos [lmap case $cases {AND $x $case}]
    set cases_neg [lmap case $cases {AND [NOT $x] $case}]

    set result [list_union $cases_pos $cases_neg]

    if {$merging} {
        set result [merge_cases $result]
    }

    return $result
}

# Takes a list of cases, and returns a new list where exactly two of them have been merged together into one.
proc merge_cases {cases} {
    set left [lpop cases]
    set right [lpop cases]
    lappend cases [OR $left $right]
    return $cases
}
