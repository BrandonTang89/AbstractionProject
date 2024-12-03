# ===== Symbolic Simulation with Indexing Transformations =====
# This script applies an indexing transformation to add abstraction to the simulation
# We still have the following goals:
# - the correct property being satisfied
# - the wrong property being violated
# - a visualisation of the simulation

# We use the following indexing relation:
# p and q and r -> a@2 and b@2 and c@2 and a@4 and b@4 and c@4
# p and q and (not r) -> not a@2
# p and (not q) and r -> not b@2
# (not p) and q and r -> not c@2
# (not p) and (not q) and r -> not a@4
# (not p) and q and (not r) -> not b@4
# p and (not q) and (not r) -> not c@4

# This (should) satisfy the coverage condition that 
    # for each 2^6 possible inputs (across 3 signals on 2 time ticks),
    # we have some value of (p, q, r) that maps to that

# TODO: Figure out how to apply indexing transformation on relational cout in the form of system verilog assertions

# The initial set up is the same as for the no-abstraction simulation
clear -all
source symsim_utils.tcl
source helpers.tcl
source symsim_helpers_brandon.tcl
analyze -sv and_2_cycles.sv
analyze -sva v_and_2_cycles.sva
analyze -sv bind_and_2_cycles.sv
elaborate -top and_2_cycles_top
clock -both_edges clk
reset -none

namespace import symsim::*
set_symsim_expr_pretty_print_threshold 30

# === Symsim Set Up ===
set model_id [check_symsim -model -create]
set assertions [check_symsim -model $model_id -list assert]

# === Set up for a symbolic simulation ===
set inputs [list a b c]
set input_ticks [list 2 4]
set bdd_variables [create_bdd_variables $inputs $input_ticks]

# === Create indexing relation === 
set p [VAR p]
set q [VAR q]
set r [VAR r]

set index_rel [AND \
    [IMPLIES [AND $p $q $r] [AND [VAR a@2] [VAR b@2] [VAR c@2] [VAR a@4] [VAR b@4] [VAR c@4]]] \
    [IMPLIES [AND $p $q [NOT $r]] [NOT [VAR a@2]]] \
    [IMPLIES [AND $p [NOT $q] $r] [NOT [VAR b@2]]] \
    [IMPLIES [AND [NOT $p] $q $r] [NOT [VAR c@2]]] \
    [IMPLIES [AND [NOT $p] [NOT $q] $r] [NOT [VAR a@4]]] \
    [IMPLIES [AND [NOT $p] $q [NOT $r]] [NOT [VAR b@4]]] \
    [IMPLIES [AND $p [NOT $q] [NOT $r]] [NOT [VAR c@4]]] \
]

set index_rel [check_symsim -expression -canonize $index_rel]

# Check that the indexing relation is as expected
check_symsim -expression -depends $index_rel
PR $index_rel

# === Running a symbolic simulation ===
# Create initial un-abstracted stimuli
set stimuli_dict [create_stimuli_dict $inputs $bdd_variables]

# Apply the indexing transformation to the stimuli
set transformed_ant_stimuli [strong_preimage_stim $stimuli_dict $index_rel $bdd_variables]

# Create a sequence from tranformed stimuli
set antecedent_seq [check_symsim -sequence -create $transformed_ant_stimuli -name my_sequence]
set resolved_seq_id [check_symsim -sequence -resolve -antecedent $antecedent_seq -name my_resolved_sequence]

# Run the symbolic simulation
set num_ticks 8
set eval_out [check_symsim  -eval $model_id \
                            -resolved_sequence $resolved_seq_id \
                            -start_tick 1 \
                            -num_ticks $num_ticks \
                            -init_states false\
                            -canonize on]

set eval_seq [dict get $eval_out sequence_id]

# Visualise the simulation
check_symsim -sequence $eval_seq -get [list a b c o] -verbose
# Here we can manually inspect to see that (at tick 6):
# o is high iff p&q&r and low if any input variable is constrained to be low
# remains to see how to automate this checking

# check_symsim -sequence $eval_seq -get $assertions -verbose