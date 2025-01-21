# facilites for manufacturing unique and same names

# https://stackoverflow.com/a/72614138 to make this sourceable from outside this directory
variable baseDir [file dirname [file normalize [info script]]]

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