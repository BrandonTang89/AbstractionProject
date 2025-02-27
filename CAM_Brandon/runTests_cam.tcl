file mkdir output

# === CAM Manual Indexing ===
# set data_widths [list 4 5 6 7]
# set addr_widths [list 3 4 5]
# set filename "output/CAM_manualAbstract.txt"

# set file_handle [open $filename "w"]
# puts $file_handle "NUM_ENTRIES, DATA_LENGTH, abstraction_time, transform_time, eval_time, check_time"
# close $file_handle

# foreach DATA_WIDTH $data_widths {
#     foreach ADDR_WIDTH $addr_widths {
#         source verify_cam_manualAbstract_eff.tcl
#         set file_handle [open $filename "a"]
#         puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $abstraction_time 0], [lindex $transform_time 0], [lindex $eval_time 0], [lindex $check_time 0]"
#         close $file_handle
#         check_symsim -expression -sweep

#     }
# }


# === CAM No Abstraction ===
set data_widths [list 2 3 4]
set addr_widths [list 2 3 4]
set filename "output/CAM_noAbstract.txt"
set file_handle [open $filename "w"]
puts $file_handle "NUM_ENTRIES, DATA_LENGTH, eval_time, check_time"
close $file_handle

foreach DATA_WIDTH $data_widths {
    foreach ADDR_WIDTH $addr_widths {
        source verify_cam_noAbstract.tcl
        set file_handle [open $filename "a"]
        puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $eval_time 0], [lindex $check_time 0]"
        close $file_handle
        check_symsim -expression -sweep
    }
}

# === CAM Automatic Abstraction ===
set data_widths [list 4 5 6]
set addr_widths [list 3 4]
set filename "output/CAM_autoAbstract.txt"
set file_handle [open $filename "w"]
puts $file_handle "NUM_ENTRIES, DATA_LENGTH, abstraction_time, transform_time, eval_time, check_time"
close $file_handle

foreach DATA_WIDTH $data_widths {
    foreach ADDR_WIDTH $addr_widths {
        source verify_cam_autoAbstract_eff.tcl
        set file_handle [open $filename "a"]
        puts $file_handle " $NUM_ENTRIES, $DATA_LENGTH, [lindex $abstraction_time 0], [lindex $transform_time 0], [lindex $eval_time 0], [lindex $check_time 0]"
        close $file_handle
        check_symsim -expression -sweep

    }
}