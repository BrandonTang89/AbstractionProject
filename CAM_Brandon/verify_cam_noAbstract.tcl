################################################################################
# Symbolic simulation of the CAM with no abstraction
################################################################################

set DATA_WIDTH 2; # log d
set ADDR_WIDTH 2; # log n
set TEST_ITERATIONS 1

set DATA_LENGTH [expr 2**$DATA_WIDTH]
set NUM_ENTRIES [expr 2**$ADDR_WIDTH]

unset -nocomplain memo
clear -all
analyze -sv cam.sv
analyze -sva cam_spec.sva
analyze -sv bind_cam.sv
elaborate -top cam_top -parameter DATA_LENGTH $DATA_LENGTH -parameter ADDR_WIDTH $ADDR_WIDTH -loop_limit 100000
clock -both_edges clk
reset -none

source ../juliaAutoAbstract/utils.tcl
source ../CommonUtils_Brandon/helpers.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
set_symsim_expr_pretty_print_threshold 30

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
set signals [check_symsim -model $model_id -list signal]

# == Set up property to check ==
set properties [dict create \
    spec.assert_next_hit 2 \
]
    # spec.assert_hit 4 \

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
set input_ticks [list 2]
set ant_query [create_dual_rail_antecedent query [list 2]]

set ant_mem [list]
for {set i 0} {$i < $NUM_ENTRIES} {incr i} {
    set ant [create_dual_rail_antecedent "mem\[$i\]" [list 2]]
    puts $ant
    set ant_mem [merge_dual_rail_antecedents $ant_mem $ant]
}

set antv [merge_dual_rail_antecedents $ant_query $ant_mem]

set eval_time [time {
    # Create resolved sequence
    set antecedent_seq [check_symsim -sequence -create $antv -name my_sequence]
    set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

    # Run the symbolic simulation
    set num_ticks [expr $max_property_tick + 2]
    set eval_out [check_symsim  -eval $model_id \
                                -resolved_sequence $resolved_seq_id \
                                -start_tick 1 \
                                -num_ticks $num_ticks \
                                -init_states false\
                                -canonize on]

    set eval_seq [dict get $eval_out sequence_id]
} $TEST_ITERATIONS ]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list hit] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# Check the properties (since no abstraction we just need to check that the relevant proeprties are high at the required tick)
set check_time [time {
    set prop_high [TRUE]
    set prop_low [FALSE]

    # PR $prop_high
    # PR $prop_low

    check_properties_against_sim $properties $eval_seq $prop_high $prop_low
}  $TEST_ITERATIONS ]

# === Timing Information ===
puts "No Indexing Symbolic Simulation of the CAM"
puts "Eval time: $eval_time"

puts "Check time: $check_time"
puts "Total Time: [expr {[lindex $eval_time 0] + [lindex $check_time 0]}]"

puts "NUM_ENTRIES: $NUM_ENTRIES"
puts "DATA_LENGTH: $DATA_LENGTH"