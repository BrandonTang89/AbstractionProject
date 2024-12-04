# === Procedure to create a list of integers from a to b ===
proc create_list {a b} {
    set result {}
    for {set i $a} {$i <= $b} {incr i} {
        lappend result $i
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