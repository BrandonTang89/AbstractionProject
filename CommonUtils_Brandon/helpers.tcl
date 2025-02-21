# === Procedure to create a list of integers from a to b ===
proc create_list {a b} {
    set result {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend result $i
    }
    return $result
}

proc make_unique {list} {
    set result {}
    foreach item $list {
        if {$item ni $result} {
            lappend result $item
        }
    }
    return $result
}

# === Procedure to zip two lists into a dictionary ===
proc zip_as_dict {keys values} {
    set result [dict create]
    foreach key $keys value $values {
        dict set result $key $value
    }
    return $result
}

# === Procedure to get the key to the maximum value in a dictionary ===
proc key_to_max_dict {dictionary} {
    set max_value -1
    set max_key ""
    foreach {key value} $dictionary {
        if {$value > $max_value} {
            set max_value $value
            set max_key $key
        }
    }
    return $max_key
}

# === Procedure to get the maximum value in a dictionary ===
proc max_dict_values {dict} {
    return [dict get $dict [key_to_max_dict $dict]]
}

# === Procedure to assign a value to all keys in a list ===
# - Returns a dictionary with all keys in the list assigned the value
proc assign_to_all {keys value} {
    set result [dict create]
    foreach key $keys {
        dict set result $key $value
    }
    return $result
}


# === Assert procedure ===
proc assert {condition message} {
    if {!$condition} {
        error "Assertion failed: $message"
    }
}

# === Procedure to apply a function on all values of a dictionary ===
# to call, do "dict_map $dictionary proc" where dictionary is a dictionary
proc dict_map {dictionary proc} {
    set result [dict create]
    foreach {key value} $dictionary {
        # puts "Key: $key, Value: $value"
        dict set result $key [eval $proc $value]
    }
    return $result
}

# === Procedure to return the intersection of two lists ===
proc intersect {list1 list2} {
    set result {}
    foreach item $list1 {
        if {$item in $list2} {
            lappend result $item
        }
    }
    return $result
}

# === Procedure to return the difference of two lists ===
proc difference {list1 list2} {
    set result {}
    foreach item $list1 {
        if {$item ni $list2} {
            lappend result $item
        }
    }
    return $result
}

proc flatten {list} {
    set result {}
    foreach sublist $list {
        foreach item $sublist {
            lappend result $item
        }
    }
    return $result
}