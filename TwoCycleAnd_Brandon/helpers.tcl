proc create_list {a b} {
    set result {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend result $i
    }
    return $result
}

proc zip_as_dict {keys values} {
    set result [dict create]
    foreach key $keys value $values {
        dict set result $key $value
    }
    return $result
}

proc assign_to_all {keys value} {
    set result [dict create]
    foreach key $keys {
        dict set result $key $value
    }
    return $result
}