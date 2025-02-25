file mkdir output

set data_widths [list 1 2 3]
set addr_widths [list 1 2 3]

# set data_widths [list 4 5]
# set addr_widths [list 3 4]
# === MaxCircuit Manual Indexing ===
# set filename "output/maxCircuit_manual.txt"

# set file_handle [open $filename "w"]
# puts $file_handle "NUM_ENTRIES, DATA_LENGTH, abstraction_time, transform_time, eval_time, check_time"
# close $file_handle

# foreach DATA_WIDTH $data_widths {
#     foreach ADDR_WIDTH $addr_widths {
#         source verify_maxCircuit_manualAbstract.tcl

#         set file_handle [open $filename "a"]
#         puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $abstraction_time 0], [lindex $transform_time 0], [lindex $eval_time 0], [lindex $check_time 0]"
#         close $file_handle
#     }
# }


# === MaxCircuit No Abstraction ===
set filename "output/maxCircuit_noAbstract.txt"
set file_handle [open $filename "w"]
puts $file_handle "NUM_ENTRIES, DATA_LENGTH, eval_time, check_time"
close $file_handle

foreach DATA_WIDTH $data_widths {
    foreach ADDR_WIDTH $addr_widths {
        source verify_maxCircuit_noAbstract.tcl

        set file_handle [open $filename "a"]
        puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $eval_time 0], [lindex $check_time 0]"
        close $file_handle
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
#     }
# }