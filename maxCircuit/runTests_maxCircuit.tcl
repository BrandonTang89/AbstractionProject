file mkdir output

# === MaxCircuit Manual Indexing ===
set data_widths [list 4]
set addr_widths [list 3]
set filename "output/maxCircuit_manualAbstract2.txt"

set file_handle [open $filename "w"]
puts $file_handle "NUM_ENTRIES, DATA_LENGTH, abstraction_time, transform_time, eval_time, check_time"
close $file_handle

foreach DATA_WIDTH $data_widths {
    foreach ADDR_WIDTH $addr_widths {
        source verify_maxCircuit_manualAbstract.tcl

        set file_handle [open $filename "a"]
        puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $abstraction_time 0], [lindex $transform_time 0], [lindex $eval_time 0], [lindex $check_time 0]"
        close $file_handle
        check_symsim -expression -sweep
    }
}


# === MaxCircuit No Abstraction ===
set data_widths [list 4]
set addr_widths [list 3]
set filename "output/maxCircuit_noAbstract2.txt"
set file_handle [open $filename "w"]
puts $file_handle "NUM_ENTRIES, DATA_LENGTH, eval_time, check_time"
close $file_handle

foreach DATA_WIDTH $data_widths {
    foreach ADDR_WIDTH $addr_widths {
        source verify_maxCircuit_noAbstract.tcl

        set file_handle [open $filename "a"]
        puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $eval_time 0], [lindex $check_time 0]"
        close $file_handle
        check_symsim -expression -sweep
    }
}

# === MaxCircuit Automatic Abstraction ===
# set filename "output/maxCircuit_AutoAbstract.txt"
# set file_handle [open $filename "w"]
# puts $file_handle "NUM_ENTRIES, DATA_LENGTH, abstraction_time, transform_time, eval_time, check_time"
# close $file_handle

# foreach DATA_WIDTH $data_widths {
#     foreach ADDR_WIDTH $addr_widths {
#         source verify_maxCircuit_autoAbstract.tcl

#         set file_handle [open $filename "a"]
#         puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $abstraction_time 0], [lindex $transform_time 0], [lindex $eval_time 0], [lindex $check_time 0]"
#         close $file_handle
#         check_symsim -expression -sweep

#     }
# }