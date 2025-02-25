############################################
# Verification of simple circuit with automatic abstraction and efficient indexing transformation
############################################
unset -nocomplain memo
clear -all
analyze -sv simple.sv
analyze -sva simple_spec.sva
analyze -sv bind_simple.sv
elaborate -top simple_top

clock -both_edges clk
reset -none

source ../juliaAutoAbstract/simulate.tcl
source ../juliaAutoAbstract/utils.tcl
source ../CommonUtils_Brandon/autoabstraction_helpers_brandon.tcl
source ../CommonUtils_Brandon/symsim_helpers_brandon.tcl
source ../CommonUtils_Brandon/helpers.tcl
set_symsim_expr_pretty_print_threshold 3000

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]
set signals [check_symsim -model $model_id -list signal]

# == Set up properties to check ==
set properties [dict create \
    spec.property_wire 2\
]

set max_property_tick [max_dict_values $properties]

# === Set up Antecedent ===
set input_ticks [list 2]

set ant_a [create_dual_rail_antecedent a [list 2]]
set ant_b [create_dual_rail_antecedent b [list 2]]
set ant_c [create_dual_rail_antecedent c [list 2]]
set ant_d [create_dual_rail_antecedent d [list 2]]
set antv [merge_dual_rail_antecedents $ant_a $ant_b $ant_c $ant_d]

set bdd_variables [get_dual_rail_antecedent_variable_names $antv]

# == Automatic Abstraction ==
# We only need to auto abstract on the property_wire being TRUE (it is a waste to do it on FALSE)
set partition_abstraction [autoabstract spec.property_wire [TRUE] [FALSE] []]

# Check coverage
set coverage [satisfiesCoveragePartitioned $partition_abstraction $bdd_variables]
assert [expr {$coverage == 1}] "Indexing relation does not cover all cases"

set normal_abstraction [normalise_abstraction $partition_abstraction $bdd_variables]
set abstraction_S [lindex $normal_abstraction 0]
set abstraction_T [lindex $normal_abstraction 1]
set dom [get_domain $abstraction_S $abstraction_T]

# === Indexing Transformation ===
# Apply the indexing transformation to the stimuli
set transformed_ant_stimuli [strong_preimage_stim_part $antv $abstraction_T $dom $bdd_variables]

# Create a sequence from tranformed stimuli
set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
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

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list o] -verbose
check_symsim -sequence $eval_seq -get $assertions -verbose

# === Transformation of the property ===
set prop_high $dom
set prop_low [FALSE]

check_symsim -expression -depends $prop_high
PR $prop_high
PR $prop_low

check_properties_against_sim $properties $eval_seq $prop_high $prop_low
check_symsim -expression -get_canonical $prop_high


#######
#######
# set index_rel [combine_abstractions $partition_abstraction]
# set index_rel [combine_abstraction_dict $abstraction_T]
# set expr [AND [VAR a] [VAR b] [VAR c] [VAR d]]
# weak_preimage_part $abstraction_T $dom $expr [list a b c d]
# weak_preimage $index_rel $expr [list a b c d]
# strong_preimage_part $abstraction_T $dom $expr [list a b c d]
# strong_preimage $index_rel $expr [list a b c d]
# set transformed_ant_stimuli [strong_preimage_stim $antv $index_rel $bdd_variables]