% help check_symsim
----------------------------------------
Syntax: 	check_symsim Symbolic Model Creation/Removal
        	-------------------------------
        	check_symsim -model -create
        	        -main [-verbose]
        	
        	check_symsim -model -create
        	        [-name <model_name>]
        	        [-target <target_list>]
        	        [-task <task_name>]
        	        [-verbose]
        	
        	check_symsim -model [<symbolic_model_ID>] -remove
        	
        	Symbolic Model Query
        	--------------------
        	check_symsim -model <symbolic_model_ID>
        	    -list (input | output | signal | state | flop | latch |
        	                    assert | assume | cover) [-bit_blast] [-all]
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -get_sig_fanin <signal_name>
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -get_sig_fanout <signal_name>
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -get_sig_excitation <signal_name>
        	    [-sequence <sequence_ID> -tick <N>]
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -get_sig_info <signal_name>
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -get_sig_info <signal_name>
        	    [-bit_blast |-indexes |-width]
        	
        	check_symsim -model -get
        	    [-task <task_name>]
        	
        	Symbolic Model Save and Restore
        	-------------------------------
        	check_symsim -model -save -file <file_name>
        	
        	check_symsim -model -restore -file <file_name>
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -print -file <file_name>
        	    [-verilog |-sv]
        	
        	Symbolic Model Design-Under-Test Identification
        	-----------------------------------------------
        	check_symsim -model [<symbolic_model_ID>]
        	    -are_signals_in_dut <sig_list>
        	
        	check_symsim -model [<symbolic_model_ID>]
        	    -mark_dut [<instance_list>] [-signals <signal_list>]
        	
        	Constraint Signature Computation
        	--------------------------------
        	check_symsim -constraint_signature
        	    [-model <symbolic_model_ID>]
        	    -constraint <constraint_dict> [<-separate>]
        	
        	Expression Creation
        	-------------------
        	check_symsim -expression
        	    -const (true | false | <integer> | <verilog_constant>)
        	    [-width <constant_expression_width>] [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -var <var_name>
        	    [-width <variable_expression_width>] [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -ite <if_expr_ID> <then_expr_ID> <else_expr_ID>
        	    [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -and <expr_ID_list> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -or <expr_ID_list> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -xor <expr_ID_list> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -xnor <expr_ID_list> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -not <expr_ID> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -implies <expr_ID1> <expr_ID2>
        	    [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -substitute <expr_ID> <subsititution_dict>
        	    [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -exist_quantify <expr_ID> <var_list>
        	    [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -forall_quantify <expr_ID> <var_list>
        	    [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -canonize <expr_ID> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -map <expr_ID> -from_tag <tag1>
        	    -to_tag <tag2> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -concat <expr_ID_list> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -range_select <expr_ID> <range>
        	    [-in_bank <bank_name>]
        	
        	Expression Query
        	----------------
        	check_symsim -expression
        	    -depends <expr_ID>
        	
        	check_symsim -expression
        	    -size <expr_ID>
        	
        	check_symsim -expression
        	    -canonical_size <expr_ID>
        	
        	check_symsim -expression
        	    -top_cofactor <expr_ID> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -get_canonical <expr_ID> [-in_bank <bank_name>]
        	
        	check_symsim -expression
        	    -pretty_print <expr_ID>
        	
        	check_symsim -expression
        	    -width <expr_ID>
        	
        	check_symsim -expression
        	    -bdd_graph_size
        	
        	check_symsim -expression
        	    -num_minterms <expr_ID> <num_vars>
        	
        	Expression Save and Restore
        	---------------------------
        	check_symsim -expression
        	    -save -file <file_name> <expr_ID_list>
        	    [-with_bdds]
        	
        	check_symsim -expression
        	    -restore <file_name> [-with_bdds]
        	
        	Expression Garbage Collection
        	-----------------------------
        	check_symsim -expression
        	    -sweep
        	
        	check_symsim -expression
        	    -clear_bdd
        	
        	check_symsim -bank <bank_name>
        	    -clear
        	
        	check_symsim -bank <bank_name>
        	    -add_expression <expr_ID_list>
        	
        	check_symsim -bank <bank_name>
        	    -remove_expression <expr_ID_list>
        	
        	check_symsim -scope
        	    -push [<scope_name>]
        	
        	check_symsim -scope
        	    -pop [<scope_name>]
        	
        	check_symsim -scope
        	    -add_to_parent <expr_ID_list>
        	
        	Expression Pick Assignment
        	--------------------------
        	check_symsim -expression
        	   -pick_assignment <expr_ID_list>
        	   -small -prefer (true | false)
        	
        	check_symsim -expression
        	   -pick_assignment <expr_ID_list>
        	   -vars <var_list>
        	   -prefer (true | false)
        	
        	check_symsim -expression
        	   -pick_assignment <expr_ID_list>
        	   -forced
        	
        	check_symsim -expression
        	   -pick_assignment <expr_ID_list>
        	   -vars <var_list>
        	   -random [-fair]
        	
        	
        	Sequence Creation and Manipulation
        	----------------------------------
        	check_symsim -sequence
        	    -create [<stimuli_dict>]
        	    [-name <sequence_name>]
        	    [-weak]
        	
        	check_symsim -sequence <seq_ID>
        	    -remove
        	
        	check_symsim -sequence <seq_ID>
        	    -clear
        	
        	check_symsim -sequence <seq_ID>
        	    -union <seq_ID_list>
        	
        	check_symsim -sequence <seq_ID>
        	    -override <seq_ID2>
        	
        	check_symsim -sequence <seq_ID>
        	    -cut [-from <N>] [-to <M>]
        	
        	check_symsim -sequence <seq_ID>
        	    -crop [-from <N>] [-to <M>]
        	
        	check_symsim -sequence <seq_ID>
        	    -copy
        	
        	check_symsim -sequence <seq_ID>
        	    -to_observability
        	
        	check_symsim -sequence <seq_ID>
        	    -add <stimuli_dict>
        	
        	check_symsim -sequence <seq_ID>
        	    -canonize
        	
        	check_symsim -sequence <seq_ID>
        	    -substitute <subsititution_dict>
        	
        	check_symsim -sequence
        	    -resolve> -antecedent <antecedent_seq_ID>
        	    [-weakening <weakening_seq_ID>]
        	    [-cond_weakening <cond_weakening_seq_ID>]
        	    [-cond_binding <cond_binding_seq_ID>]
        	    [-x_filling <x_filling_seq_ID>]
        	    [-name <seq_name>]
        	
        	Sequence Query
        	--------------
        	check_symsim -sequence <seq_ID>
        	    -get_value <signal_name> -tick <N>
        	
        	check_symsim -sequence <seq_ID>
        	    -get [<sig_list>]
        	    [-regexp <regexp_expr>]
        	    [-tick <N>]
        	    [-bit_blast] [-verbose]
        	
        	check_symsim -sequence <seq_ID>
        	    -diff <seq_ID2> [-canonize] [-verbose]
        	
        	check_symsim -sequence <seq_ID>
        	    -length
        	
        	check_symsim -sequence <seq_ID>
        	    -get_name
        	
        	check_symsim -sequence <seq_ID>
        	    -is_weakening
        	
        	check_symsim -sequence <seq_ID>
        	    -get_boolean_constants -bdd_size <size>
        	    [-from <from_tick>] [-to <to_tick>]
        	
        	check_symsim -sequence <seq_ID>
        	    -get_non_trivial_constants -bdd_size <size>
        	    [-from <from_tick>] [-to <to_tick>]
        	
        	check_symsim -sequence <seq_ID>
        	    -depends
        	
        	check_symsim -sequence <seq_ID>
        	    -get_relevant_drivers [-model <symbolic_model_ID>]
        	    -signal <signal_name> -tick <N>
        	
        	Sequence Save and Restore
        	-------------------------
        	check_symsim -sequence <seq_ID>
        	    -save -file <prefix>
        	
        	check_symsim -sequence
        	    -restore <prefix>
        	
        	Symbolic Evaluation
        	-------------------
        	check_symsim -eval [<symbolic_model_ID>]
        	    -resolved_sequence <resolved_sequence_ID>
        	    -start_tick <N>
        	    [-input_sequence <sequence_ID> [-overwrite_sequence]]
        	    [-num_ticks <M>]
        	    [-observation <obs_dict>]
        	    [-debug_mode (true | false)]
        	    [-canonize (on | off | auto)]
        	    [-bdd_limit <limit>]
        	    [-bdd_limit_handling (weaken | skip)]
        	    [-bit_level_weaken (true | false)]
        	    [-prefix <prefix_string>]
        	    [-init_states (true | false)] [-verbose]
        	
        	check_symsim -eval
        	    -get_last_result
        	    [-dynamically_weakened_signals <tick>]
        	
        	Variable Ordering
        	-----------------
        	check_symsim -var_order
        	    -set <var_name_list>
        	
        	check_symsim -var_order
        	    -set -file <file_name>
        	
        	check_symsim -var_order
        	    -get
        	
        	check_symsim -var_order
        	    -save -file <file_name>
        	
        	check_symsim -var_order
        	    -restore -file <file_name>
        	
        	Transitive Fanin
        	----------------
        	check_symsim -transitive_fanin
        	    [-model <symbolic_model_ID>]
        	    -signals <sig_list> -barrier <sig_list>
        	
        	Param
        	-----
        	check_symsim -param -expressions <expr_list>
        	    -variables <var_list>
        	
        	check_symsim -param -expressions <expr_list>
        	    -exclude_symbols <exclude_symbols_arg>
        	
        	check_symsim -param -sequence <seq_ID>
        	    -args <param_arg> [-disjoint] [-verbose]
        	
        	Non-Causal Fanout Weakening
        	---------------------------
        	check_symsim -non_causal_fanout_weakening -simplified
        	    [-model <symbolic_model_ID>] -sequence <seq_ID>
        	    -start_signals <obs_dict> [-name <weak_seq_name>]
        	
        	check_symsim -non_causal_fanout_weakening
        	    [-model <symbolic_model_ID>] -sequence <seq_ID>
        	    -barrier <seq_ID_list> -min_tick <min_tick>
        	    -max_tick <max_tick> -start_frontier <signal_tick_list>
        	    -max_fanin_size <max_fanin_size>
        	
        	check_symsim -non_causal_fanout_weakening
        	    -causal_fanin_init -start_frontier <signal_tick_list>
        	
        	check_symsim -non_causal_fanout_weakening
        	    -causal_fanin_step [-model <symbolic_model_ID>]
        	    -sequence <seq_ID> -barrier <seq_ID_list>
        	    -soft_barrier <sig_list> -tick <N>
        	    -max_fanin_size <max_fanin_size>
        	
        	check_symsim -non_causal_fanout_weakening
        	    -update_frontier <frontier_dict>
        	
        	check_symsim -non_causal_fanout_weakening
        	    -construct_weakening [-model <symbolic_model_ID>]
        	    -min_tick <min_tick> -max_tick <max_tick>
        	    -name <weakening_seq_name>
        	
        	Recipe Creation and Configuration
        	---------------------------------
        	check_symsim -recipe <recipe_name_path> -config
        	    -partition_on_cin [-create <case_name_list>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -partition_on_cout [-create <case_name_list>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -assume_guarantee [-create <case_name_list>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -var_order <var_name_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_antc <extra_antc_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -antc_all_ignore <antc_ignore_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_antv <extra_antv_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -antv_all_ignore <antv_ignore_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_x_fill_antv <x_fill_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -ant_resolve_conflicts (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -varbind_check (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -ant_check (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_cin <extra_cin_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_all_ignore <cin_ignore_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_cout <extra_cout_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_cond_antv <cond_antv>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_cin_observation <cin_observation_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_cout_observation <cout_observation_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_wl <wl_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -add_extra_cond_wl <cond_wl>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -weaken_ant (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -untimed_ncfow (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -untimed_ncfow_min_tick <min_tick>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -untimed_ncfow_max_size <max_size>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -untimed_ncfow_max_passes <max_passes>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -untimed_ncfow_use_aborted (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -num_param_stages <num_stages>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -num_param_substages <num_substages>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -param_exclude_symbols <exclude_symbols_arg>
        	    [-param_stage <stage>]
        	    [-param_substage <substage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -param_constants_only (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -param_bdd_limit <limit>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -param_disjoint (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -vacuity_check_pass (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -vacuity_check_exclude <exclude_arg>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -antv_auto (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -x_fill_auto (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_dyn_wlim <limit>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_main_dyn_wlim <limit>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_dyn_wlim <limit>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_main_dyn_wlim <limit>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_dyn_wlim_per_tick <limit_per_tick_range_list>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_main_dyn_wlim_per_tick <limit_per_tick_range_list>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_dyn_wlim_per_tick <limit_per_tick_range_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_main_dyn_wlim_per_tick <limit_per_tick_range_list>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_bit_level_weaken (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_main_bit_level_weaken (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_bit_level_weaken (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_main_bit_level_weaken (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_canonize (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_main_canonize (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_canonize (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_main_canonize (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_assume_clocks (true | false)
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_min_tick <min_tick>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cin_ncfow_max_size <fanout_max_size>
        	    [-param_stage <stage>]
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_assume_clocks (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_min_tick <min_tick>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -cout_ncfow_max_size <fanout_max_size>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -constant_propagation (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -constant_propagation_dyn_wlim <dyn_wlim>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -constant_propagation_max_size <max_size>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -constant_propagation_min_tick <min_tick>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -constant_propagation_max_tick <max_tick>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -use_sat_solver (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -conjver_fail_on_first (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -conjver_max_passes <conjver_max_passes>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -conjver_max_goal_size <conjver_max_goal_size>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -conjver_strategy <conjver_strategy_dict>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -sat_solver_time_limit <time_limit>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -sat_solver_sequential (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -sat_solver_fail_on_first (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -sat_solver_vacuity_check (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -sat_solver_top_check (true | false)
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -reference_tick <tick>
        	
        	check_symsim -recipe <recipe_name_path> -config
        	    -init_states (true | false)
        	
        	check_symsim -recipe <recipe_name> -remove
        	
        	Recipe Query
        	------------
        	check_symsim -recipe <recipe_name_path> -get
        	    { [var_order] [add_extra_antc] [antc_all_ignore] [add_extra_antv]
        	      [antv_all_ignore] [add_x_fill_antv] [ant_resolve_conflicts]
        	      [varbind_check] [ant_check] [add_extra_cin] [cin_all_ignore]
        	      [add_extra_cout] [add_extra_cond_antv] [add_cin_observation]
        	      [add_cout_observation] [add_wl] [add_extra_cond_wl]
        	      [weaken_ant] [vacuity_check_pass] [vacuity_check_exclude]
        	      [num_param_stages] [num_param_substages] [param_exclude_symbols]
        	      [param_constants_only] [param_bdd_limit] [param_disjoint]
        	      [antv_auto] [x_fill_auto] [cout_x_fill_auto]
        	      [cin_ncfow_dyn_wlim] [cin_main_dyn_wlim] [cout_ncfow_dyn_wlim]
        	      [cout_main_dyn_wlim] [cin_ncfow_dyn_wlim_per_tick]
        	      [cin_main_dyn_wlim_per_tick] [cout_ncfow_dyn_wlim_per_tick]
        	      [cout_main_dyn_wlim_per_tick] [cin_ncfow_bit_level_weaken]
        	      [cin_main_bit_level_weaken] [cout_ncfow_bit_level_weaken]
        	      [cout_main_bit_level_weaken] [cin_ncfow_canonize]
        	      [cin_main_canonize] [cout_ncfow_canonize] [cout_main_canonize]
        	      [untimed_ncfow] [untimed_ncfow_use_aborted]
        	      [untimed_ncfow_min_tick] [untimed_ncfow_max_size]
        	      [untimed_ncfow_max_passes] [cin_noncausal_fanout_weaken]
        	      [cin_ncfow_assume_clocks] [cin_ncfow_min_tick] [cin_ncfow_max_size]
        	      [cout_ncfow] [cout_ncfow_assume_clocks] [cout_nocfow_min_tick]
        	      [cout_ncfow_size] [reference_tick] [use_sat_solver]
        	      [sat_solver_time_limit] [sat_solver_sequential]
        	      [sat_solver_fail_on_first] [sat_solver_vacuity_check]
        	      [sat_solver_top_check] [conjver_fail_on_first] [conjver_max_passes]
        	      [conjver_max_goal_size] [conjver_strategy] [constant_propagation]
        	      [constant_propagation_dyn_wlim] [constant_propagation_max_size]
        	      [constant_propagation_min_tick] [constant_propagation_max_tick]
        	      [init_states]}
        	
        	check_symsim -recipe -list
        	
        	Resolved Recipe Creation, Deletion and Query
        	--------------------------------------------
        	check_symsim -resolved_recipe -create
        	    -recipe <recipe_name_path>
        	    -antv <antv_dict>
        	    -cin <cin_list>
        	    [-model <symbolic_model_ID>]
        	    [-antc <antc_dict> ]
        	    [-cout <cout_dict>]
        	    [-cond_antv <cond_antv_list>]
        	    [-cond_wl <cond_wl>]
        	    [-name <resolved_recipe_name>] [-force]
        	
        	check_symsim -resolved_recipe <resolved_recipe_name>
        	    -remove
        	
        	check_symsim -resolved_recipe -list
        	
        	Prove
        	------
        	check_symsim -prove
        	    -resolved_recipe <resolved_recipe_name_path>
        	    [-start_from proof_ID
        	                          (  cin_generate_ncfow | cin_main_simulation
        	                           | generate_param | apply_param
        	                           | cout_ncfow_simulation | cout_generate_ncfow
        	                           | cout_main_simulation | cout_verification ) <stage_num>]
        	    [-stop_after (  cin_generate_ncfow | cin_main_simulation
        	                           | generate_param | apply_param
        	                           | cout_ncfow_simulation | cout_generate_ncfow
        	                           | cout_main_simulation | cout_verification ) <stage_num>]
        	    [-debug_mode]
        	
        	Prove Results Query and Deletion
        	--------------------------------
        	check_symsim -prove [<proof_ID>] -get_result
        	    [-intermediate]
        	
        	check_symsim -prove [<proof_ID>] -get_result
        	    -non_causal_fanout_weakening
        	    [-stage <stage>] [-why] [-relevant]
        	
        	check_symsim -prove [<proof_ID>] -remove_result
        	
        	Prove Results Save and Restore
        	-------------------------------
        	check_symsim -prove <proof_ID> -save_result
        	    -file <file_name>
        	
        	check_symsim -prove -restore_result -file <file_name>
        	
        	Property Status Query
        	---------------------
        	check_symsim -get_status <property>
        	
        	Symbolic Schematic Viewer
        	-------------------------
        	check_symsim -symbolic_schematic -show
        	    -signal <signal_list>
        	    -visualize_window <visualize_window_name>
        	    [-window <window_name>]
        	
        	check_symsim -symbolic_schematic -add
        	    -signal <signal_list>
        	    -visualize_window <visualize_window_name>
        	    -window <window_name>
        	
        	check_symsim -symbolic_schematic -remove
        	    -signal <signal_list>
        	    -visualize_window <visualize_window_name>
        	    -window <window_name>
        	
        	check_symsim -symbolic_schematic -save <file_name>
        	    -window <window_name>
        	
        	check_symsim -symbolic_schematic -restore <file_name>
        	    -visualize_window <visualize_window_name>
        	    [-window <window_name>]

Summary:	Runs Symbolic Simulation.
Returns:	Various, context sensitive return values.

Detailed description:
Use the "check_symsim" command for Datapath Formal Verification (DFV).

Symbolic Model Creation/Removal
-------------------------------
-model -create -main
    [-verbose]

    Builds a main Symbolic Model of the elaborated design to reuse with all
    tasks in the Jasper session. Use "-verbose" to print info messages
    detailing the Symbolic Model build. This command returns ID zero.

    NOTE: It is not mandatory to build a main Symbolic Model. The tool uses the
    main Symbolic Model for incremental model builds, which reduces time.

-model -create
    [-target {target_list}]
    [-task task]
    [-name model_name]
    [-word_level]
    [-verbose]

    Builds a Symbolic Model. The properties in the specified task are
    used when building the Symbolic Model. If you do not specify the "-task"
    switch, this command applies to the current task. This command returns the
    ID of the Symbolic Model created.

    . Use "-target" to include only signals in the transitive fanin of the
      signals in the target_list.
    . Use "-name" to specify a name for the created Symbolic Model.
    . Use "-word_level" to keep word level logic and avoid a default bit level
      synthesys of the the model logic.
    . Use "-verbose" to print info messages detailing the Symbolic Model build.

-model [symbolic_model_ID] -remove

    Removes the specified Symbolic Model. If symbolic_model_ID is not specified,
    the tool removes the latest valid model created for the current task.

Symbolic Model Query
--------------------
-model symbolic_model_ID
    -list (input | output | signal | state | flop | latch | assert | assume | cover)
    [-bit_blast] [-all]

    Get model information.

    Supported "-list" Enums
    -----------------------
    Each command supports the "-bit_blast" switch, which ensures that the result
    is bit blasted. When this switch is not used, the result is word-level signals.
    Use "-all" switch to get also non-user-given signals.
    . output: List all outputs of the Symbolic Model.

    . input: List all inputs of the Symbolic Model.

    . signal: List all signals in the Symbolic Model.
      The result includes signals that were introduced during synthesis. These
      signal names are prefixed with ":symsim_syn_", for example,
      ":symsim_syn_2092".

    . state: List all states in the Symbolic Model. This includes both flops
      and latches.
      The result includes signals that were introduced during synthesis. These
      signal names are prefixed with ":symsim_syn_", for example,
      ":symsim_syn_2092".

    . flop: List all flops in the Symbolic Model.
      The result includes signals that were introduced during synthesis. These
      signal names are prefixed with ":symsim_syn_", for example,
      ":symsim_syn_2092".

    . latch: List all latches in the Symbolic Model.
      The result includes signals that were introduced during synthesis. These
      signal names are prefixed with ":symsim_syn_", for example,
      ":symsim_syn_2092".

    . assert: List all properties of type assert included in the Symbolic Model.

    . assume: List all properties of type assume included in the Symbolic Model.

    . cover: List all properties of type cover included in the Symbolic Model.

-model [symbolic_model_ID] -get_sig_fanin signal_name

    List the signals in the immediate fanin of the given signal.
    The order of the signals returned corresponds to the Boolean symbols (H0, L0...)
    returned by "check_symsim -model -get_sig_excitation" command.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -get_sig_fanout signal_name

    List the signals in the immediate fanout of the given signal.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -get_sig_excitation signal_name
    [-sequence sequence_ID -tick N]

    Get the (high_rail_expression_ID, low_rail_expression_ID) value of the
    given signal. The expressions returned are formulated over Boolean symbols
    H0, L0, H1, L1, and so forth. The letters H and L refer to high and low rail
    expressions, and the numbers 0, 1, ... refer to the position of the
    corresponding input in the fanin list.

    . Use "-sequence" and "-tick" to get a simplified excitation expression
      where any constants that occur at tick "N" (or tick "N-1") in the given
      sequence have been substituted in the expressions of the excitation.
      If you do not specify "-tick", the tool uses the last tick of the
      sequence.

    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -get_sig_info signal_name

    Get detailed information about the given signal. The information is returned
    in a Tcl dictionary format with the following mandatory key/value pairs:
    . type "state", subtype "ff/latch/sampler". For "ff/sampler" subtype, there is
      a mandatory key "sensitivity" with possible values: "posedge"/"negedge".
    . type "wire", subtype "combinational/mux/buffer/virtual_buffer/inverter"
    There is also an optional key "roles". Roles data is in Tcl dictionary format.

    The roles data can be as follows:
    Type    Subtype     Roles Key       Roles Data          Mandatory Role
    ----    ----------  -----------     -----------------   --------------
    state   ff/sampler  clock           signal name         Y
                        data            signal name         Y
                        async_ctrl      signal name         N
                        async_data      signal name         N
    state   latch       enable          signal name         Y
                        sensitivity     1 / 0               Y
                        data            signal name         Y
                        async_ctrl      signal name         N
                        async_data      signal name         N
    wire    mux         selector        list of signals     Y
                        sensitivity     list of 1 / 0       Y
                                        per selector
                        data            list of signals     Y
                        default         signal name         N

    Important things to know about roles for latches:
    . async_ctrl and async_data are optional, but if one is present both must be present.
    . 1 in the sensitivity is active high, 0 is active low.

    Important things to know about roles for muxes:
    . There must be equal numbers of "selector", "sensitivity", and "data".
    . The indexes in the "data", "selector", and "sensitivity" lists correspond to each
      other. For example: index 0 in all lists is the first selector/data/sensitivity
      tuple of the mux.

    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -get_sig_info signal_name -bit_blast

    List the bits that comprise the given signal. If the given signal is one
    bit wide, the command returns the signal name. If symbolic_model_ID is not
    specified, the tool uses the latest model created for the current task.

    Example: If the given signal is a three-bit word defined as sig[2:0],
    the command returns {sig[2]} {sig[1]} {sig[0]}.

-model [symbolic_model_ID] -get_sig_info signal_name -indexes
    Return details about the signal: MSB, LSB, and signal type information.

    The command returns one of the following:
    . "Bit" (in cases where the specified signal is not indexed)
    . "1D_Array" followed by the MSB and LSB indexes

    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -get_sig_info signal_name -width
    Return the width of the signal. If symbolic_model_ID is not specified,
    the tool uses the latest valid model created for the current task.

-model -get [-task task_name]
    Returns the latest model created for the given task.
    If the task is not specified, returns the latest model for the current task.
    If no valid model exists for the given task, returns 0.

Symbolic Model Save and Restore
---------------------------
-model -save -file file_name
    Saves the main Symbolic Model to the specified file.

-model -restore -file file_name
    Restores and builds the main Symbolic Model from the specified file.
    This command returns ID zero.

-model [symbolic_model_ID] -print -file file_name [-sv] [-verilog]
    Prints the model logic in either System Verilog or Verilog-2000 format.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.
    The defaut format is System Verilog.

Symbolic Model Design-Under-Test Identification
-----------------------------------------------
The DFV prove flow uses Design-Under-Test (DUT) identification to differentiate
design logic from verification logic. When the tool creates the model, the
top-level module is marked as the DUT. If this marking does not meet your needs
(for example, your top module is a "miter" containing a DUT instance and a SPEC
instance), you might choose to mark the model differently using the "-mark_dut"
switch.

-model [symbolic_model_ID] -are_signals_in_dut sig_list
    Returns a list of 0's and 1's corresponding to sig_list.
    For each signal in sig_list the returned list contains 1 if the signal is
    in the DUT; otherwise, it contains 0.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

-model [symbolic_model_ID] -mark_dut [instance_list] [-signals signal_list]
    Clear previous marking and mark the given instances as the DUT. For more
    precise control, you can pass an optional list of signals. The tool marks
    as DUT all signals in the fan-in cone of influence of the given instances.
    In addition, it marks as DUT the signals in signal_list.

    NOTE: Signals are marked as a whole, treating all bits the same. For
    example, "-signals {foo[3]}" has the same effect as "-signals {foo}".

    If you do not supply an instance list or a signals list, the tool applies
    the default marking (that is, the top-level module).
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

Constraint Signature Computation
--------------------------------
-constraint_signature
    [-model symbolic_model_ID] -constraint constraint_dict [-separate]

    Compute the timed signature for all the constraint-tick pairs specified in
    the constraint_dict, which consists of a mapping from constraint to
    tick vector.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

    The timed signature of a constraint-tick pair consists of all the
    signals/ticks that are in the fanin of the constraint and are on the DUT
    boundary. It is computed by performing a timed dfs fanin until reaching a
    user-given signal on the DUT boundary.

    The timed fanin of a signal s1 @ tick t1 is the signals/ticks in its fanin
    that might affect the value of signal s1 @ tick t1.

    Example: For combinational logic, all the inputs of signal s1 @ tick t1
    might affect its value @ tick t1.

    NOTE: use "-separate" if you want to get the timed signature for each pair
    of constraint and tick separately.

Expression Creation
-------------------
Use the commands in this section to create expressions. Each command supports the
"-in_bank" switch, which guards the returned (non-zero) expression from garbage
collection, while preventing it from being added to the current garbage collection scope.

-expression -const (true | false | integer_value | verilog_constant)
    [-width const_expession_width] [-in_bank bank_name]

    Get the expression ID for the expression representing the Verilog constant.
    . Use "-width" to adjust the constant word width in the resulting expression.

-expression -var var_name [-width var_expession_width] [-in_bank bank_name]

    Get the expression ID for the expression representing the given
    variable. If such an expression does not exist, the tool creates
    a new variable expression with this name.
    If you would like to create a variable together with a tag that
    can be used for mapping purposes, use the naming convention "tag::name".
    . Use "-width" to adjust the variable word width in the resulting expression.

-expression -ite if_expr_ID then_expr_ID else_expr_ID [-in_bank bank_name]
    Get the expression ID for the expression representing
    "if-then-else" constructed from the given expressions.

-expression -and expr_ID_list [-in_bank bank_name]

    Get the expression ID for the expression representing the
    conjunction of the expressions specified in the expression ID list.
    If the expression ID list is empty, the command returns the expression
    ID of one that represents the constant true.

-expression -or expr_ID_list [-in_bank bank_name]

    Get the expression ID for the expression representing the
    disjunction of the expressions specified in the expression ID list.
    If the expression ID list is empty, the command returns the expression
    ID of one that represents the constant false.

-expression -xor expr_ID_list [-in_bank bank_name]

    Get the expression ID for the expression representing the
    exclusive disjunction of the expressions specified in the expression
    ID list.
    If the expression ID list is empty, the command returns the expression
    ID of one that represents the constant false.

-expression -xnor expr_ID_list [-in_bank bank_name]

    Get the expression ID for the expression representing the
    logical negation of the exclusive disjunction of the expressions
    specified in the expression ID list.
    If the expression ID list is empty, the command returns the expression
    ID of one that represents the constant true.

-expression -not expr_ID [-in_bank bank_name]

    Get the expression ID for the expression representing the
    logical negation of expr_ID.

-expression -implies expr_ID1 expr_ID2 [-in_bank bank_name]

    Get the expression ID for the expression representing the
    logical implication of "expr_ID1 => expr_ID2".

-expression -substitute expr_ID subsititution_dict [-in_bank bank_name]

    Get the expression ID for the expression obtained by
    substituting all the variables within the substitution dictionary
    with their accompanying expression.

    NOTE: substitution_dict is a Tcl dictionary that maps a variable
    name to an expression ID.

-expression -exist_quantify expr_ID var_list [-in_bank bank_name]

    Get the expression ID for the expression obtained by
    existentially quantifying the variables in var_list.
    If the var_list is empty, the command returns expr_ID.

-expression -forall_quantify expr_ID var_list [-in_bank bank_name]

    Get the expression ID for the expression obtained by
    universally quantifying the variables in var_list.

-expression -canonize expr_ID [-in_bank bank_name]

    Get the expression ID of the expression that is the
    canonical representation of the expression "expr_ID".
    If the tool was unable to calculate the canonical representation, the
    command returns 0.

-expression -map expr_ID -from_tag tag1 -to_tag tag2 [-in_bank bank_name]

    Get the expression ID for the expression obtained by
    substituting all the tags in the expression variables.
    For example, variable "tag1::var" becomes "tag2::var" for each var in expr.

    NOTE:
    . Each new variable is installed at the same level as the old variable.
    . For a variable to have a tag, the variable name must have the format
      tag::name.

-expression -concat expr_ID_list [-in_bank bank_name]

    Get the expression ID for the wide expression build by concatenating
    the expression IDs in the list.
    The order of the bits of the wide expression is according to the
    order of the list. The ID in index 0 of the list is the msb of
    the new wide expression.

    For example:
    check_symsim -expression -concat {$ID1 $ID2 $ID3}
    --> a new expression that looks like {$ID1, $ID2, $ID3}

-expression -range_select expr_ID range [-in_bank bank_name]

    Get the expression ID for the sub-range of expr_ID specified by range.
    "range" can have either of the following formats: "MSB:LSB" or "BIT".

    Returns 0 if any of the range information is out of bounds of the
    expr_ID width.

    NOTE: Expressions are always normalized (width:0) since the expression
    does not hold non-standard range info.

Expression Query
----------------
Use the commands in this section to query expressions. Some commands support the
"-in_bank" switch, which guards the returned (non-zero) expressions from garbage
collection, while preventing them from being added to the current garbage collection scope.

-expression -depends expr_ID

    Get the names of the variables used in the expression.
    If the expression is canonical, the order of the returned variables
    respects the global BDD order. That is, "x" appears before "y" in the depends
    list if and only if "x" comes before "y" in the global BDD order.

-expression -size expr_ID

    Get the expression size.

-expression -canonical_size expr_ID

    Get the BDD size of the canonical representation of the expression if one exists.
    The command returns 0 if the canonical representation does not exist.

-expression -top_cofactor expr_ID [-in_bank bank_name]

    Get the expression "destruction" triple with parent and children:
    the name of the top variable and the expression IDs for the two children.

-expression -get_canonical expr_ID [-in_bank bank_name]

    Get the expression ID of the expression that is the canonical representation
    of expr_ID.
    The command returns 0 if the canonical representation has not been calculated yet.

-expression -pretty_print expr_ID

    Print the expression.
    If the expression size is below a certain threshold, it prints in full,
    for example,"A + !C".
    If the size of the expression exceeds the threshold, the command prints
    general information such as:
    . Operator type
    . Expression width
    . Expression size
    . Size of the depends list

    NOTE: Run "set_symsim_expr_pretty_print_threshold N" to set this threshold.
    The default threshold size is 20.

-expression -width expr_ID

    Get the width of the expression (number of bits).

-expression -bdd_graph_size

    Get the size of the BDD graph. This information is useful when canonizing
    many expressions.

-expression -num_minterms expr_ID num_vars

    Get the number of satisfying assignments, assuming there are num_vars
    variables. In other words, return (p * 2^num_vars), where p is the
    proportion of satisfying assignments for the given expression. If the
    expression does not have a canonical representation, return 0.

Expression Save and Restore
---------------------------
-expression -save -file file_name expr_ID_list [-with_bdds]
    Save the expression IDs in the list to a file.
    Use "-with_bdds" to also store the canonical representation of the expression.

-expression -restore file_name [-with_bdds]
    Restore the expressions from the file.
    If you used the switch "-with_bdds", any canonical representations that
    were saved are also restored.

Expression Garbage Collection
-----------------------------
Use the commands in this section to manage expression garbage collection.
During expression garbage collection, unprotected expressions that are not
used by the tool might be removed.

To protect the lifespan of expressions (the time from creation until they are
no longer needed) within Tcl flows, we offer a stack of scopes, which is
similar to a call stack. Every expression has a scope in which it was created.
If you do not define a scope, the default scope is "global".
The tool preserves expressions in the "global" scope unless you run "clear
-all". An expression is protected from garbage collection as long
as its scope is open.

Banks protect expressions in a user-defined "context".
. Expressions within a bank are protected.
. Expressions can be unbanked.
. Expressions can be banked regardless of the scope.
. Expressions each have a reference counter to keep track of the number of times
  an expression has been added or removed from the bank.

NOTE: You can have a variety of banks, and an expression can belong to more than one.

-expression -sweep
    Run garbage collection.
    Expressions that are neither in use by the tool nor protected by
    scopes or banks might be cleared during the sweep.

-expression -clear_bdd
    Clear the canonical representation of all expressions.

-bank bank_name -clear
    Clear the specified bank from all expressions.
    If no bank with the specified name exists, the tool creates a new empty
    bank.

-bank bank_name -add_expression expr_ID_list
    Add the expressions in the expr_ID_list to the specified bank.
    If this expression already existed in the bank, its reference is
    increased.

-bank bank_name -remove_expression expr_ID_list
    Reduce the reference counter for the expressions in the expr_ID_list
    in the specified bank. If any expression's reference counter is reduced
    to zero, the expression is removed from the bank.

-scope -push [scope_name]
    Create a new scope at the top of the scope stack.
    Any new expression is automatically protected by this scope
    (unless you have used the "-in_bank" switch).
    If you provide a "scope_name", this scope will be named.

-scope -pop [scope_name]
    Pop the scope at the top of the scope stack.
    Expressions created while this scope was open will not be protected anymore.
    If any expressions still need protection, you can add them to a bank or use
    the command "check_symsim -scope -add_to_parent expr_ID_list".

-scope -add_to_parent expr_ID_list
    Add the specified expressions to the parent scope.
    This command ensures that the expressions in the expr_ID_list are protected
    by the parent scope as well as the current scope.
    This command is useful for aligning scopes with your code structure and
    protecting return values from a function call.

Expression Pick Assignment
--------------------------
-expression -pick_assignment expr_ID_list
   -small -prefer (true | false)

   Returns a substitution dict whose assigments satisfy the expressions in
   "expr_ID_list". A greedy algorithm is used to try and find a small
   assignment; however, the assignment is not guaranteed to be minimal.
   Use "-prefer true|false" to indicate the desired choice of value when choice
   is possible.

-expression -pick_assignment expr_ID_list
   -vars var_list -prefer (true | false)

   Returns a substitution dict whose domain is "var_list" and whose assigments
   satisfy the expressions in "expr_ID_list". There will be some value assigned
   to each element of "var_list", even for variables not in the support of the
   expressions in "expr_ID_list".
   Use "-prefer true|false" to indicate the desired choice of value when choice
   is possible.

-expression -pick_assignment expr_ID_list -forced

   Returns a substitution dict that includes those variable->value mappings that
   are in every satisfying assignment to the expressions in "expr_ID_list".

-expression -pick_assignment expr_ID_list
   -vars var_list -random [-fair]

   Returns a random substitution dict whose domain is "var_list" and whose 
   assigments satisfy the expressions in "expr_ID_list". There will be some value
   assigned to each element of "var_list", even for variables not in the support
   of the expressions in "expr_ID_list".
   If "-fair" is specified, there is an attempt to distribute assignments
   uniformly over the space of satisfying assignments.

Sequence Creation and Manipulation
----------------------------------
-sequence -create [stimuli_dict]
    [-name sequence_name] [-weak]

    Create a sequence. If you specify stimuli_dict, the command creates a
    sequence with the dictionary values.
    This command returns the ID of the Sequence created.

    . Use "-name" to specify a name for the created sequence. If you do not
      specify a name, the created sequence will be unnamed. Sequence names can
      contain only letters, digits, underscores, and colons. They need not be
      unique.

    . Use "-weak" to specify that this sequence should be interpreted as a
      weakening sequence.

    NOTE: stimuli_dict is a Tcl dictionary that maps a signal to a list
    of tuples of the format: "(High Expr ID, Low Expr ID, from:to)".
    . "from" must be a non-negative integer.
    . "to" can be a non-negative integer or a "$" sign. "$" denotes the end of
      simulation.

-sequence seq_ID
    -remove

    Remove the sequence seq_ID.

-sequence seq_ID
    -clear

    Clear all stimuli from seq_ID.

-sequence seq_ID
    -union seq_ID_list

    Append all the stimuli from the sequences list to the seq_ID.
    The tool combines any stimuli that exist in both seq_ID_list and seq_ID
    with lattice operations.

-sequence seq_ID
    -override seq_ID2

    Append seq_ID2 stimuli to seq_ID.
    If you specify a stimuli in both seq_ID2 and seq_ID, the stimuli in
    seq_ID2 overrides the previous stimuli.

-sequence seq_ID
    -cut [-from N] [-to M]

    Cut any parts of the sequence before cycle N and after cycle M in seq_ID.

    . If you do not specify "-from", N = 0.
    . If you do not specify "-to", M = last cycle.

    NOTE: You must specify at least one end of the range (either "-from" or
    "-to").

-sequence seq_ID
    -crop [-from N] [-to M]

    Crop any parts of the sequence from cycle N and up to cycle M in seq_ID.

    . If you do not specify "-from", N = 0.
    . If you do not specify "-to", M = last cycle.

    NOTE: You must specify at least one end of the range (either "-from" or
    "-to").

-sequence seq_ID
    -copy

    Create a new sequence that is the copy of seq_ID. The command returns the
    ID of the new sequence.

-sequence seq_ID
    -to_observability

    Translate the sequence to a Tcl dictionary that maps from a signal to a
    list of ranges of the format "from, to".
    You can use this Tcl dictionary with the "check_symsim -eval -observation"
    command.

-sequence seq_ID
    -add stimuli_dict

    Add the stimuli specified in the stimuli_dict to the sequence.

    NOTE: stimuli_dict is a Tcl dictionary that maps a signal to a list
    of tuples of the format: "(High Expr ID, Low Expr ID, from:to)".

    . "from" must be a non-negative integer.
    . "to" can be a non-negative integer or a "$" sign. "$" denotes the end of
      simulation.

-sequence seq_ID
    -canonize

    Canonize all the expressions in the sequence. The command returns 1 if
    the tool was able to canonize all of the expressions.

-sequence seq_ID
    -substitute subsititution_dict

    Get the sequence ID for the new sequence obtained by
    substituting all the variables within the substitution dictionary
    with their accompanying expression in all expressions in the sequence.

    NOTE: substitution_dict is a Tcl dictionary that maps a variable
    name to an expression ID.

-sequence -resolve
    -antecedent antecedent_seq_ID
    [-weakening weakening_seq_ID]
    [-cond_weakening cond_weakening_seq_ID]
    [-cond_binding cond_binding_seq_ID]
    [-x_filling x_filling_seq_ID]
    [-name seq_name]

    Create a new sequence that is a resolution of all the sequences given
    as input to the command.
    . Use "-antecedent" to specify the antecedent sequence that will be
      part of the resolved sequences.
    . Use "-weakening" to specify a weakening sequence that will be part of the
      resolved sequences.
    . Use "-cond_weakening" to specify a conditional weakening sequence that
      will be part of the resolved sequences.
    . Use "-cond_binding" to specify a conditional binding sequence that will
      be part of the resolved sequences.
    . Use "-x_filling" to specify an x-filling sequence that will be part
      of the resolved sequences.
    . Use "-name" to specify a name for the created sequence. If you do not
      specify a name, the created sequence will be unnamed.

    NOTE:
    . The sequences provided as arguments to the "-weakening" and
      "-cond_weakening" switches must be weakening sequences; that is,
      they must be sequences created using the "-weak" switch.
    . The sequences provided as arguments to the "-antecedent",
      "-cond_binding", and "-x_replacement" switches must not be weakening
      sequences.
    . The resulting resolved sequence drives the simulation ("check_symsim
      -eval"). It has a "resolved" type, and you cannot use it as input to the
      "check_symsim -sequence -resolve" command.

Sequence Query
--------------
-sequence seq_ID
    -get_value sig_name -tick N

    Get the value (High Expr ID, Low Expr ID) of signal "sig_name" at tick "N".
    You must specify "-tick".

-sequence seq_ID
    -get [sig_list]
    [-regexp regexp_expr]
    [-tick N]
    [-bit_blast]
    [-verbose]

    Get the value changes for each signal in the sequence.
    The result of the command is a Tcl dictionary that maps a signal to a list of
    tuples of the format: "(High Expr ID, Low Expr ID, from, to)".

    . Specify "sig_list" to include only information on signals in the list.
    . Use "-regexp" to include only information on signals that match the given
      regexp.
    . Use "-tick" to include only information at tick "N".
    . Use "-bit_blast" to get the signals bit blasted.
    . Use "-verbose" to print the values of the requested signals to the console.

    NOTE: A signal that was not traced in the sequence will have an "X" value.

-sequence seq_ID
    -diff seq_ID2 [-canonize] [-verbose]

    Get the difference between "seq_ID" and "seq_ID2".
    The result of the command is a Tcl dictionary that maps a signal to a list
    of tuples of the format: "(start tick, end tick)".  Each tuple represents a
    tick range where the signal has a different value in each sequence.

    . Use "-canonize" to compare the canonical representation of each expression.

    . Use "-verbose" to print a list of signals and the different expressions for
      each relevant tick range to the console.

      For example:

        Sequence: 6
        Name: Trace

        Signal: vld
        +--------+--------+----------------------------------------+----------------------------------------+
        | From   | To     | High                                   | Low                                    |
        +--------+--------+----------------------------------------+----------------------------------------+
        | 0      | 3      | 1'b0                                   | 1'b0                                   |
        +--------+--------+----------------------------------------+----------------------------------------+
        | 4      | 5      | 1'b1                                   | 1'b0                                   |
        +--------+--------+----------------------------------------+----------------------------------------+

-sequence seq_ID
    -length

    Get the last tick of interest in the sequence.

-sequence seq_ID
    -get_name

    Get the name the sequence was given during its creation.

    NOTE: If no name was given during the sequence creation, the command
    returns an empty string.

-sequence seq_ID
    -is_weakening

    Return 1 if the sequence was created as a weakening sequence; otherwise,
    return 0.

-sequence seq_ID
    -get_boolean_constants -bdd_size size
    [-from from_tick]
    [-to to_tick]

    Get the sequence ID for the new sequence obtained by including only the tuples
    from sequence "seqID" whose BDDs are constants within ticks "N" and "M".

    . If you do not specify "-from", N = 0.
    . If you do not specify "-to", M = last tick.

-sequence seq_ID
    -get_non_trivial_constants -bdd_size size
    [-from from_tick]
    [-to to_tick]

    Get the sequence ID for the new sequence obtained by including only the tuples
    from sequence "seqID" whose BDDs are below the given size threshold and are within
    ticks "N" and "M".

    . If you do not specify "-from", N = 0.
    . If you do not specify "-to", M = last tick.

-sequence seq_ID
    -depends

    Get the names of the variables used in all the sequence expressions.

-sequence seq_ID -get_relevant_drivers
    [-model symbolic_model_ID] -signal signal_name -tick N

    List the relevant drivers of signal "signal_name" at tick "N"
    according to the model "symbolic_model_ID".
    NOTE: If "-model" is not specified, the tool uses the latest valid model
    created for the current task.

    The return value from this command is a Tcl dictionary that maps relevant
    drivers to additional information about them.
    The additional information is a Tcl dictionary that includes the following
    keys:
    . "ticks": A list of ticks when the driver is relevant.
    . "role": The driver's role. Appears only if the subtype of the signal
      supplied to the command is one of mux, ff, sampler, or latch.

Sequence Save and Restore
-------------------------
-sequence seq_ID -save -file prefix

    Write the information from "seq_ID" into two files: <prefix>.bdds and <prefix>.seq.
    NOTE: The expressions in the sequence must be canonized before they can be written.
    You can use the command "check_symsim -sequence seqID -canonize" to ensure the
    expressions are canonized.

-sequence -restore prefix

    Read two files, <prefix>.bdds and <prefix>.seq, and return the
    sequence ID for the newly created sequence.
    The sequence is named "prefix".

Symbolic Evaluation
-------------------
-eval [symbolic_model_ID]
    -resolved_sequence resolved_sequence_ID
    -start_tick N
    [-input_sequence sequence_ID [-overwrite_sequence]]
    [-num_ticks M]
    [-observation obs_dict]
    [-debug_mode (true | false)]
    [-canonize (on | off | auto)]
    [-bdd_limit limit]
    [-bdd_limit_handling (weaken | skip)]
    [-bit_level_weaken (true | false)]
    [-prefix prefix_string]
    [-init_states (true | false)] [-verbose]

    Run Symbolic Simulation.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.
    The command returns a Tcl dictionary with the following keys:
    1. End tick K which is the tick that was reached during the simulation.
       If simulation was successful, then K = N + M.
    2. Sequence ID.

    . Use "-input_sequence" to start the simulation at tick "N" of the sequence
      specified by sequence_ID.
      Use "-overwrite_sequence" to overwrite the input sequence with the results
      of the current simulation.
    . Use "-num_ticks" to specify the number of ticks the simulation should run.
      If you do not specify "-num_ticks", M = 1.
    . Use "-observation" to specify the signals and ticks the tool should
      track during the simulation. "obs_dict" is a Tcl dictionary that maps
      signals to a list of tuples of the following format: "from:to".
      If you do not specify "-observation", the tool tracks all signals
      and ticks.
      NOTE: "from" tick must be a non-negative number. "to" tick can be either
      a non-negative number or the "$" sign, which denotes the end of the
      simulation.
    . Use "-debug_mode true" to track all signals in the COI (Cone Of Influence)
      of the signals in the "obs_dict" (if specified). The default is "false".
    . Use "-canonize" to determine the canonization behavior during the simulation.
      . Use the the value "on" or "off" to turn canonization on or off during
        the evaluation.
      . Use the value "auto" to use the behavior defined by the global
        "auto-canonize" behavior (check_symsim -get_auto_canonize).
      The default canonization behavior is "off".
    . Use "-bdd_limit" to specify a limit on the size of the BDDs generated
      during the evaluation.
      NOTE: This switch overrides the global threshold, but it has no effect if
      canonization is not performed during the evaluation.
    . Use "-bdd_limit_handling" to specify how to handle the case where the BDD
      exceeded the set limit.
      . Use "weaken" to replace expressions that exceed the limit with a false
        expression.
      . Use "skip" to ignore the BDD and maintain only the non-canonical
        expression if an expression exceeds the limit.
      NOTE: This switch has no effect if canonization is not performed
      during the evaluation.
    . Use "-bit_level_weaken" to determine how the weakening will be performed,
      namely, whether to weaken per bit or per word. If word-level weakening
      is selected and the BDD computed per one bit (or more) exceeded the limit,
      then the expression for all bits of the signal will be replaced with a
      false expression.
      NOTE:
      . This switch has no effect if canonization is not performed
        during the evaluation or if "skip" is performed.
      . If you do not specify "-bit_level_weaken", the weakening will be
        performed per bit.
    . If you did not specify "-overwrite_sequence", use "-prefix" to specify a
      prefix for the name of the sequence generated by the command.
      For example, if you specify "pref", the name of the sequence will
      be pref_seq.
      NOTE: The specified prefix string must not include spaces.
    . Use "-init_states" to initialize the design to the reset states given by
      the reset command when performing the simulation. If set to "false", the
      design is initialized to an arbitrary state (all non-constant state
      elements are initialized to "X"). The default is "true".
    . Use "-verbose" to print progress information as the command runs.

    The value for signal s at cycle k is computed as follows:
    HighRail = HighInputTrace(s) OR HighStimuli(s,k)
    LowRail  = LowInputTrace(s)  OR LowStimuli(s,k)

    Where:
    . HighStimuli/LowStimuli are the values specified in "resolved_sequence_ID".
    . HighInputTrace/LowInputTrace are the values specified in "sequence_ID".

    NOTE: The encoding of X value is (F,F), where F denotes False value.

-eval -get_last_result
    [-dynamically_weakened_signals tick]

    Retrieve the results of the last evaluation.

    The "check_symsim -eval -get_last_result" command without additional
    arguments returns a dictionary with the following keys:
    1. end_tick
    2. sequence_id
    3. frontier_id

    Use "-dynamically_weakened_signals" to retrieve a list of the dynamically
    weakened signals that are stored at "tick" of the last evaluation.

    NOTE: Running this command before running an evaluation triggers an error.

Variable Ordering
-----------------
-var_order
    -set var_name_list

    Set the BDD variable order based on the order of the variables specified
    by "var_name_list".

    Important things to know:
    . The specified variables are first in the BDD ordering.
    . The tool respects the listed order, first variable to last.
    . Any subsequent additions follow the specified list in order.
    . If a specified variable does not yet exist, the tool creates it.
    . The command returns the total number of BDD nodes in use after setting
      the order.

-var_order
    -set -file file_name

    Set the BDD variable order based on the order of the variables specified
    in "file_name".

    Important things to know:
    . The specified variables are first in the BDD ordering.
    . The tool respects the listed order, first variable to last.
    . Any subsequent additions follow the specified list in order.
    . If a specified variable does not yet exist, the tool creates it.
    . The command returns the total number of BDD nodes in use after setting
      the order.

-var_order
    -get

    Get the list of existing, ordered BDD variables.

-var_order
    -save -file file_name

    Save the BDD variable order to "file_name".

-var_order
    -restore -file file_name

    Restore the BDD variable order from "file_name".

Transitive Fanin
----------------
-transitive_fanin
    [-model symbolic_model_ID] -signals sig_list -barrier sig_list

    List the signals in the transitive fanin of the signal list supplied as the argument
    to "-signals". The transitive fanin is computed up to either inputs or signals
    specified in the signal list supplied as the argument to "-barrier".
    If symbolic_model_ID is not specified, the tool uses the latest valid mode
    created for the current task.

Param
-----
-param -expressions expr_list -variables var_list

   Compute a parametric assignment for the variables in "var_list" which satisifies
   the expressions in "expr_list".

-param -expressions expr_list -exclude_symbols exclude_symbols_arg

   Compute a parametric assignment for the variables in the depends of the expressions
   in "expr_list" which satisifies the expressions in "expr_list".
   Variables that match the regex "exclude_symbols_arg" are kept as is and excluded
   from parametric substitution.

-param -sequence seq_ID -args param_arg [-disjoint] [-verbose]

    Compute a parametric substitution according to "param_arg".
    "param_arg" is a list of pairs, one pair per param substage.
    Each pair is composed of a Tcl dictionary and a regex.
    . The dictionary maps signals (input constraints) to a list of ticks.
    . The regex specifies symbols that should be kept as is during the
      parametic substitution computation (and not be substituted).
    The expressions associated with the given signals/tick are extracted from
    trace_seq_ID, and a parametric assignment is computed for all the
    variables they depend on except those variables that are specified by the
    given regex. The computed parametric substitution should satisfy the
    extracted expressions, assuming they are satisfiable.

    Use "-verbose" to print progress information as the command runs
    as well as include a more detailed result that can be used in
    debugging in case that the command resulted in some error.

    Use "-disjoint" to process the constraints one by one.

    Returns a Tcl dictionary which can contain the following key/value pairs:

    Key                    Value
    -------------------    --------------------------------------------------
    exit_status            Status of the run. Possible statuses are:
                           . "completed" - the command ran to its end
                           . "aborted" - the command was interrupted
                           . "stopped_by_error" - the command stopped due to
                             an error

    error_type             The error that caused the command to stop
                           (applies if the command exited with
                           "stopped_by_error" status). See below for
                           possible error types.

    param_res              The result of the parametric substitution
                           computation (see below for additional information).

    The "param_res" value is a Tcl dictionary, which can contain the below keys:
    . "exlude_symbols": Includes the variables which were kept as is and excluded
      from parametric substitution.
    . "const_subst": Includes the list of constant substitutions, that is, the
      variables that are substituted by a constant 0 or 1.
    . "symb_subst": Includes the list of symbolic substitutions, that is, the
      variables that are substituted by a symbolic expression.
    . "symb_exprs": Includes the expressions that remain after performing all the
      substitutions.
    . "is_sat_exprs": For each expression in the "symb_exprs" list, there is an
      equivalent expression that is obtained by existentially quantifying all
      the variables that appear in the expression and are not symbolic constants.
    . "const_subst_source": Includes a list of pairs. Each pair consists of a pair
      that represents the constant mapping (namely, a variable and a constant value
      of 0 or 1) and a pair of (property,tick) that forces this constant mapping.
    . "symb_exprs_source": a Tcl dictionary that maps each expression in the
      "symb_exprs" list to a list of the (property,tick) pairs that contribute to
      that expression.

     NOTE: "const_subst_source", "symb_exprs_source" are only computed in case
     "-verbose" switch is used.

    If any of the expressions in the "is_sat_exprs" list equals to "false", then
    the list of expressions on which the PARAM was applied is unsatisfiable.

    The possible values for "error_type" key are:
    . "vacuous": the expression computed for some input constraint at the given
      tick  is false.
    . "non_boolean_cins": the expression computed for some input constraint at
      the given tick is not Boolean.
    . "param_contradiction_constant": a contradiction was detected in phase 1 of
      the flow that computes the constant substitution.
    . "param_contradiction_symbolic": a contradiction was detected in phase 3 of
      the flow that computes the parametric substitution.
    . "param_bdd_limit": the BDD size limit exceeded in phase 3 of the flow that
      computes the parametric substitution.


Non-Causal Fanout Weakening
---------------------------
-non_causal_fanout_weakening -simplified
    [-model symbolic_model_ID] -sequence seq_ID -start_signals obs_dict
    [-name weak_seq_name]

    Compute a non-causal fanout weakening sequence for the signals specified
    in "obs_dict". The weakening sequence contains signals in the cone defined by the
    signals in "trace_seq_ID" on one side and the signals in "obs_dict" on the
    other side that do not affect the signals in "obs_dict". In addition, it
    includes the signals in "seq_ID". If symbolic_model_ID is not specified,
    the tool uses the latest valid model created for the current task.
    The flow first performs a transitive-fanin traversal from the observed signals up
    to either inputs or signals in "seq_ID". It then computes fanout for all
    signals in "seq_ID". Each signal in the computed fanout that is not in
    the set of signals computed previously is inserted into the weakening sequence
    with the full tick range (0 to inifinity).
    In addition, the signals in "seq_ID" are inserted into the weakening
    sequence with the same tick range that appears in "seq_ID".

    Use "-name" to provide a name to the created weakening sequence.

    NOTE: This is a simplified and less accurate non-causal fanout weakening
    computation compared to the next API.

    Returns the ID of the created weakening sequence.

-non_causal_fanout_weakening
    [-model symbolic_model_ID] -sequence seq_ID
    -barrier seq_ID_list -min_tick min_tick
    -max_tick max_tick -start_frontier signal_tick_list
    -max_fanin_size max_fanin_size

    Compute a non-causal fanout weakening sequence for the signal/tick pairs specified
    as the start frontier based on the trace "seq_ID". The non-causal fanout weakening
    sequence contains the signals/ticks that do not contribute to the signals at the frontier
    at the specified ticks.
    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

    The flow first computes a timed causal fanin based on "seq_ID", starting from
    "start_frontier". The computation is performed from "max_tick" down to "min_tick".
    The noncausal fanout weakening is computed based on the timed causal fanin.

    . Use "-barrier" to specify a stopping condition for the causal fanin traversal.
      The causal fanin traversal stops at signals appearing in one of the
      sequences specified as a barrier.
    . Use "-max_fanin_size" to limit the size of the causal fanin computed. If
      the causal fanin exceeds the threshold in tick k, the computed causal
      fanin (or frontier) includes all the signals that appear in the causal
      fanin in ticks max_tick down to "k+1".

    Returns the ID of the created weakening sequence.

-non_causal_fanout_weakening
    -causal_fanin_init -start_frontier signal_tick_list

    Initialize the non-causal fanout weakening computation with the signal/tick
    pairs specified by "-start_frontier".

-non_causal_fanout_weakening
    -causal_fanin_step [-model symbolic_model_ID]
    -sequence seq_ID -barrier seq_ID_list
    -soft_barrier sig_list -tick N
    -max_fanin_size max_fanin_size

    Perform one step "N" of the causal fanin computation based on trace "seq_ID".
    . Use "-barrier" to specify a stopping condition for the causal fanin traversal.
      The causal fanin traversal stops at signals appearing in one of the
      sequences specified as a barrier.
    . Use "-max_fanin_size" to limit the size of the causal fanin computed. If
      the causal fanin exceeds the threshold, the computed causal fanin (or
      frontier) returned will be empty.
    . Use "-soft_barrier" to specify a list of signals that the fanin will stop
      on if reached.

    If symbolic_model_ID is not specified, the tool uses the latest valid model
    created for the current task.

    Returns a list of signal/tick pairs on which the causal fanin stopped due
    to the signal list specified by "-soft_barrier".

-non_causal_fanout_weakening
    -update_frontier frontier_dict

    Update the causal fanin (or frontier) according to the "frontier_dict". The
    "frontier_dict" includes a mapping from an index of a (signal, tick) pair
    to a list of (signal, tick) pairs that were added to the causal fanin due
    to it.

-non_causal_fanout_weakening
    -construct_weakening [-model symbolic_model_ID]
    -min_tick min_tick -max_tick max_tick
    -name weakening_seq_name

    Create a non-causal fanout weakening sequence based on the causal fanin
    computed from ticks "max_tick" down to "min_tick".
    Use "-name" to give a name to the created weakening sequence.
    If symbolic_model_ID is not specified, the tool uses the latest valid model created
    for the current task.

Recipe Creation and Configuration
---------------------------------
Use recipe objects in DFV to:
(1) Decompose the proof,
(2) Control proof complexity, and
(3) Guide the proof flow, by controlling, for example, the sanity checks that are performed
    and performing local modifications to the verification problem.

Use "-config" with the commands below to create and configure recipe objects.

NOTE: some of the configuration switches are cumulative; whereas, others
override any previously configured value.

-recipe recipe_name_path -config
    -partition_on_cin [-create case_name_list]

    Configure the recipe as a "case-split" recipe on input constraints ("cin").
    Use "-create" to create and name the cases. It is possible to create
    additional cases later as well.

-recipe recipe_name_path -config
    -partition_on_cout [-create case_name_list]

    Configure the recipe as a "case-split" recipe on output constraints ("cout").
    Use "-create" to create and name the cases. It is possible to create
    additional cases later as well.

-recipe recipe_name_path -config
    -assume_guarantee [-create case_name_list]

    Configure the recipe as an "assume-guarantee" recipe.
    Use "-create" to name the assume and guarantee cases. If not used, the tool
    creates the two cases with default names of "assume" and "guarantee".

-recipe recipe_name_path -config
    -var_order var_name_list

    Configure the BDD variable order that will be used for DFV prove using the recipe.
    The default BDD variable order is the globally set one.

-recipe recipe_name_path -config
    -add_extra_antc extra_antc_dict

    Include the specified additional elements in the constant binding antecedent ("antc").
    "extra_antc_dict" is a Tcl dictionary that maps signals to a list of tuples
    with the following format: "(value, from:to)", where value is either 0 or 1.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "extra_antc" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -antc_all_ignore antc_ignore_list

    Ignore the specified constant binding antecedent components.
    "antc_ignore_list" is a list of regexp pairs where the first regexp matches
    signal name and the second matches signal tick.

-recipe recipe_name_path -config
    -add_extra_antv extra_antv_dict

    Include the specified additional elements in the variable binding antecedent ("antv").
    "extra_antv_dict" is a Tcl dictionary that maps signals to a list of tuples
    with the following format: "(var, from:to)", where var is a variable name.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "extra_antv" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -antv_all_ignore antv_ignore_list

    Ignore the specified variable binding antecedent components.
    "antv_ignore_list" is a list of regexp pairs where the first regexp matches
    signal name and the second matches signal tick.

-recipe recipe_name_path -config
    -add_x_fill_antv x_fill_dict

    Configure elements (namely, signals and ticks) that will be forced to a
    Boolean value during the symbolic simulation using the given variable.
    In particular, if the simulated value is X, it is replaced with the variable.
    "x_fill_dict" is a Tcl dictionary that maps signals to a list of tuples
    with the following format: "(var, from:to)", where var is a variable name.

-recipe recipe_name_path -config
    -ant_resolve_conflicts (true | false)

    Configure whether to automatically resolve duplicate bindings of different variables
    to the same signal at the same tick in the constant and variable binding antecedents ("ant").
    If the automatic conflict resolution is set to "true":
    . If both a constant and a variable are bound to the same signal at the
      same tick, the variable binding is ignored.
    . If two variables are bound to the same signal at the same tick, the
      variable that appears later in the variable ordering is ignored.
    . If two different constants (both T and F) are bound to the
      same signal at the same tick, the conflict is not resolved and results in
      an overconstrained value in the simulation.
    . If two variables are conditionally bound to the same signal at the same tick, or
      if two varialbes are bound to the same signal at the same tick, one conditionally
      and one unconditionally, the conflict is not resolved.

    If the automatic conflict resolution is set to "false", automatic conflict
    resolution is not performed.

    The default value is "true".

-recipe recipe_name_path -config
    -varbind_check (true | false)

    Configure whether to check that the variable binding ("varbind") is safe (when set to "true");
    namely, that the same variable is not bound to multiple signal-tick pairs.
    Such multiple binding implicitly constrains the signal values. If set to "false" the
    check is not performed.

    The default value is "true".

-recipe recipe_name_path -config
    -ant_check (true | false)

    Configure whether to check that the constant binding antecedent and the variable binding
    antecedent together do not bind two different values to the same signal at the same tick,
    resulting in an overconstrained value in the circuit simulation.

    The default value is "true".

-recipe recipe_name_path -config
    -add_extra_cin extra_cin_list

    Include the specified additional elements in the input constraints.
    "extra_cin_list" is a Tcl list of Tcl dictionaries. Each Tcl dictionary specifies one
    assumption instance (namely, an assumption + tick pair) and stores information on when/if to
    parameterize it. This Tcl dictionary comprises of the following keys:
       name             (mandatory)
       tick             (mandatory)
       param            (optional, default to true)
       param_stage      (optional, tells what stage to param in, default to 0 meaning param
                         in the first stage, maybe the only stage)
       param_substage   (optional, tells what order to param within a stage. default to 0 
                         meaning param in the first substage)
       comment          (optional, and you can put some string in there)

    NOTE: This switch is cumulative. If you use it multiple ticks, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "extra_cin" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -cin_all_ignore cin_ignore_list

    Ignore the specified input constraint components.
    "cin_ignore_list" is a list of regexp pairs where the first regexp matches
    signal name and the second matches signal tick.

-recipe recipe_name_path -config
    -add_extra_cout extra_cout_dict

    Include the specified additional elements in the output constraints.
    "extra_cout_dict" is a Tcl dictionary that maps signals to a list of ticks.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "extra_cout" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -add_extra_cond_antv cond_antv_list

    Configure additional conditional variable bindings. "cond_antv_list"
    is a Tcl list of prioritized conditional bindings lists.
    Each prioritized conditional bindings list is a Tcl list of pairs of the
    following format: "(cond, binding_dict)", where "cond" is an expression ID
    and "binding_dict" is a Tcl dictionary that maps signals to a list of
    tuples with the following format: "(var, from:to)", where var is a variable
    name. The condition determines whether the signals specified in the
    "binding_dict" will be bound (assuming that the conditions specified in the
    preceding pairs in the list do not hold).

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "extra_cond_antv" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -add_cin_observation cin_observation_dict

    Add the specified elements to be observed during the simulations performed
    on cins during the verification flow.
    "cin_obervation_dict" is a Tcl dictionary that maps signals to a list of
    ticks.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "add_cin_observation" for the recipe will accumulate over all its ancestor
    recipes as well.

-recipe recipe_name_path -config
    -add_cout_observation cout_observation_dict

    Add the specified elements to be observed during the simulations performed
    on couts during the verification flow.
    "cout_obervation_dict" is a Tcl dictionary that maps signals to a list of
    ticks.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "add_cout_observation" for the recipe will accumulate over all its ancestor
    recipes as well.

-recipe recipe_name_path -config
    -add_wl wl_dict

    Configure an explicit weakening list ("wl") to be used in the main simulation stage.
    "wl_dict" is a Tcl dictionary that maps signals to a list of ticks.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "wl" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -add_extra_cond_wl cond_wl

    Configure additional explicit conditional weakening list ("cond_wl") to use
    in the main simulation stage. "cond_wl" is a list of conditional weakenings.
    Each conditional weakening is a pair of the following format:
    "{cond, weakening_dict}" where "cond" is an expression ID and
    "weakening_dict" is a Tcl dictionary that maps a signal to a list of tick
    intervals. The condition in each pair determines whether the signals
    specified in the corresponding weakening_dict will be weakened.

    NOTE: This switch is cumulative. If you use it multiple times, the values
    accumulate. Also, if the recipe is a leaf-recipe in a hierarchy of recipes,
    "cond_wl" for the recipe will accumulate over all its ancestor recipes
    as well.

-recipe recipe_name_path -config
    -weaken_ant (true | false)

    Configure whether to automatically add signals/ticks in the antecedent to
    the weakening list. This is useful when binding variables or constants to
    internal signals because if a signal already contains a non-X value and
    you bind a variable to it, you will get an overconstraint.

    The default value is "true".

-recipe recipe_name_path -config
    -untimed_ncfow (true | false)

    Configure whether to perform an untimed static cone-of-influence style
    weakening; namely, weaken everything outside of a static fanin cone of
    the signals of interest.

    The default value is "false".

-recipe recipe_name_path -config
    -untimed_ncfow_min_tick min_tick

    Configure the earliest simulation tick to be used in the untimed causal
    fanin analysis.
    The actual first tick is the maximum of the given tick and the earliest
    tick with variable bindings.

    The default value is "0".

-recipe recipe_name_path -config
    -untimed_ncfow_max_size max_size

    Configure the maximum size of the causal fanin cone used for untimed
    noncausal fanout weakening. When the causal fanin cone reaches the size,
    further traversal of it is abandoned, and untimed noncausal fanout
    weakening list computation stops.

    The default value is "200000". A limit of "0" means "no limit".

-recipe recipe_name_path -config
    -untimed_ncfow_max_passes max_passes

    Configure the maximum number of passes in the fanin cone calculation used
    for untimed noncausal fanout weakening. Each pass consists of combinational
    fanin analysis up to a flip-flop boundary. When the fanin cone calculation
    reaches the number of passes it is abandoned, and untimed noncausal fanout
    weakening list computation stops.

    The default value is "0", meaning "no limit".
    
-recipe recipe_name_path -config
    -untimed_ncfow_use_aborted (true | false)

    Configure whether to use the untimed noncausal fanout weakening list even
    if the fanin analysis did not complete; namely, the fanin analysis was
    aborted due to reaching the "max_size" or the "max_pass" threshold.

    NOTE: If the analysis did not complete, the resulting weakening list
    might include nodes that are actually in the fanin of nodes of interest,
    which might lead to spurious X-values.

    The default value is "false".

-recipe recipe_name_path -config
    -num_param_stages num_stages

    Configure that the PARAM substitution computation will be performed in
    "num_stages" stages. At each stage, symbolic simulation and PARAM are
    computed for the given constraints, feeding the next stage, and
    enabling the use of parametric substitutions based on internal signal
    values simlulated on the design.

-recipe recipe_name_path -config
    -num_param_substages num_substages [-param_stage stage]

    Configure that the constraint PARAMing will be performed in ordered
    "num_substages" substages.

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

-recipe recipe_name_path -config
    param_exclude_symbols exclude_symbols_arg
    [-stage stage] [-substage substage]

    Configure symbols that will be excluded from parametric substitution.
    "exclude_symbols_arg" is a regexp specifying symbols that should be
    kept as is during the PARAM substitution computation.

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.
    Use "-param_substage" to configure a specific substage. If you do not specify
    "-param_substage", the default substage is 0.

-recipe recipe_name_path -config
    -param_constants_only (true | false) [-stage stage]

    Configure whether to only use the parametric substitutions that result in a constant
    (1 or 0) value being substituted for a variable.
    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

-recipe recipe_name_path -config
    -param_bdd_limit limit [-param_stage stage]

    Configure the BDD limit for the constraint PARAMing stage in DFV prove.
    A limit equal to 0 means no limit.
    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "0".

-recipe recipe_name_path -config
    -param_disjoint (true | false) [-param_stage stage]

    Configure whether to parametrize the constraints in sequence, one at a time.
    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "false".

-recipe recipe_name_path -config
    -vacuity_check_pass (true | false)

    Configure how the tool handles vacuity if detected during the run:
    . false: issue a run-time error
    . true: complete the run with all goals marked as vacuous

    The default value is "false".

-recipe recipe_name_path -config
    -vacuity_check_exclude exclude_arg

    Configure nonparamed cins to exclude from the vacuity check.
    "exclude_arg" is a regex that specifies which nonparamed cins to exclude.

-recipe recipe_name_path -config
    -antv_auto (true | false) [-param_stage stage]

    Control automatic driving of variables on undriven signals in the DUT
    boundary (the signature of the constraints of "stage") that are not driven
    by the user-specified antecedent.

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "false".

-recipe recipe_name_path -config
    -x_fill_auto (true | false) [-param_stage stage]

    Control automatic driving of "x_fill" variables on internal signals in the
    DUT boundary (the signature of the constraints of "stage") that are not
    driven by the user-specified antecedent.

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "false".

-recipe recipe_name_path -config
    -cin_ncfow_dyn_wlim limit [-param_stage stage]

    Configure the dynamic weakening limit ("dyn_wlim") for the noncausal fanout simulation
    on input constraints in DFV prove. A limit equal to 0 means no limit.
    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "0".

-recipe recipe_name_path -config
    -cin_main_dyn_wlim limit [-param_stage stage]

    Configure the dynamic weakening limit for the main simulation on input constraints
    in DFV prove. A limit equal to 0 means no limit.
    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

    The default value is "0".

-recipe recipe_name_path -config
    -cout_ncfow_dyn_wlim limit

    Configure the dynamic weakening limit ("dyn_wlim") for the noncausal fanout simulation
    on output constraints in DFV prove. A limit equal to 0 means no limit.

    The default value is "0".

-recipe recipe_name_path -config
    -cout_main_dyn_wlim limit

    Configure the dynamic weakening limit for the main simulation on output constraints
    in DFV prove. A limit equal to 0 means no limit.

    The default value is "0".

-recipe recipe_name_path -config
    -cin_ncfow_dyn_wlim_per_tick limit_per_tick_range_list [-param_stage stage]

    Configure a specific dynamic weakening limit ("dyn_wlim") per tick range(s) for the
    noncausal fanout simulation on input constraints in DFV prove.
    "limit_per_tick_range_list" is a Tcl list of tuples with the following format:
    "(limit from:to)".

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

-recipe recipe_name_path -config
    -cin_main_dyn_wlim_per_tick limit_per_tick_range_list [-param_stage stage]

    Configure a specific dynamic weakening limit ("dyn_wlim") per tick range(s) for the
    main simulation on input constraints in DFV prove.  "limit_per_tick_range_list" is
    a Tcl list of tuples with the following format: "(limit from:to)".

    Use "-param_stage" to configure a specific stage. If you do not specify
    "-param_stage", the default stage is 0.

-recipe recipe_name_path -config
    -cout_ncfow_dyn_wlim_per_tick limit_per_tick_range_list

    Configure a specific dynamic weakening limit ("dyn_wlim") per tick range(s) for the
    noncausal fanout simulation on output constraints in DFV prove.
    "limit_per_tick_range_list" is a Tcl list of tuples with the following format:
    "(limit from:to)".

-recipe recipe_name_path -config
    -cout_main_dyn_wlim_per_tick limit_per_tick_range_list

    Configure  a specific dynamic weakening limit ("dyn_wlim") per tick range(s) for the
    main simulation on output constraints in DFV prove. "limit_per_tick_range_list" is
    a Tcl list of tuples with the following format: "(limit from:to)".

-recipe recipe_name_path -config
    -cin_ncfow_bit_level_weaken (true | false) [-param_stage stage]

    Configure whether to perform the dynamic weakening per bit or per word
    for the noncausal fanout simulation on input constraints in DFV prove.
    If you do not specify "-param_stage", the default stage is 0.

    The default value is "true".

-recipe recipe_name_path -config
    -cin_main_bit_level (true | false) [-param_stage stage]

    Configure whether to perform the dynamic weakening per bit or per word
    for the main simulation on input constraints in DFV prove.
    If you do not specify "-param_stage", the default stage is 0.

    The default value is "true".

-recipe recipe_name_path -config
    -cout_ncfow_bit_level_weaken (true | false)

    Configure whether to perform the dynamic weakening per bit or per word
    for the noncausal fanout simulation on output constraints in DFV prove.

    The default value is "true".

-recipe recipe_name_path -config
    -cout_main_bit_level_weaken (true | false)

    Configure whether to perform the dynamic weakening per bit or per word
    for the main simulation on output constraints in DFV prove.

    The default value is "true".

-recipe recipe_name_path -config
    -cin_ncfow_canonize (true | false) [-param_stage stage]

    Configure the canonization behavior during the noncausal fanout simulation
    on input constraints in DFV prove.
    Use "-param_stage" to configure a specific stage. If "-param_stage" is
    not used, the default stage is 0.

    The default value is "true".

-recipe recipe_name_path -config
    -cin_main_canonize (true | false) [-param_stage stage]

    Configure the canonization behavior during the main simulation on input constraints
    in DFV prove.
    Use "-param_stage" to configure a specific stage. If "-param_stage" is
    not used, the default stage is 0.

    The default value is "false".

-recipe recipe_name_path -config
    -cout_ncfow_canonize (true | false)

    Configure the canonization behavior during the noncausal fanout simulation
    on output constraints in DFV prove

    The default value is "true".

-recipe recipe_name_path -config
    -cout_main_canonize (true | false)

    Configure the canonization behavior during the main simulation on output constraints
    in DFV prove.

    The default value is "false".

-recipe recipe_name_path -config
    -cin_ncfow (true | false) [-param_stage stage]

    Configure whether to perform an aggressive cone-of-influence style weakening;
    namely, weaken everything outside of a typically very tight approximation to
    the cone-of-influence, called noncausal fanout weakening. This involves performing
    a light-weight simluation stage before the main simulation stage to determine dependencies.
    Use "-param_stage" to configure a specific stage. If "-param_stage" is not used,
    the default stage is 0.

    The default value is "false".

-recipe recipe_name_path -config
    -cin_ncfow_assume_clocks (true | false) [-param_stage stage]

    Configure whether to assume for all latches and flops in the fanin cone
    that all partially toggling clocks (that is, clocks with symbolic values)
    toggle whenever the value of the element is actually used by the datapath.
    This allows for more aggressive non-causal fanout weakening, but might
    weaken logic that is actually used by the design.
    Use "-param_stage" to configure a specific stage. If "-param_stage"
    is not used, the default stage is 0.

    The default is "false".

-recipe recipe_name_path -config
    -cin_ncfow_min_tick min_tick [-param_stage stage]

    Configure the earliest simulation tick to be used in the causal fanin
    analysis.
    The actual first tick is the maximum of the given tick and the earliest
    tick with variable bindings.
    Use "-param_stage" to configure a specific stage. If "-param_stage" is
    not used, the default stage is 0.

    The default is "0".

-recipe recipe_name_path -config
    -cin_ncfow_max_size fanout_max_size [-param_stage stage]

    Configure the maximum size of the causal fanin cone used for noncausal fanout weakening.
    When the causal fanin cone reaches the size, further traversal of it is abandoned,
    and noncausal fanout weakening list computation stops.
    Use "-param_stage" to configure a specific stage. If "-param_stage" is
    not used, the default stage is 0.

    The default is "200000".

-recipe recipe_name_path -config
    -cout_ncfow (true | false)

    Specify whether the tool performs an aggressive cone-of-influence style
    weakening during the processing of output constraints; namely, weaken
    everything outside of a typically very tight approximation to the
    cone-of-influence, called noncausal fanout weakening. This involves
    performing a light-weight simluation stage before the main simulation
    stage to determine dependencies.

    The default value is "false".

-recipe recipe_name_path -config
    -cout_ncfow_assume_clocks (true | false)

    During the processing of output constraints, specify whether the tool
    assumes that, for all latches and flops in the fanin cone, all partially
    toggling clocks (that is, clocks with symbolic values) toggle whenever the
    value of the element is actually used by the datapath. This provides more
    aggressive non-causal fanout weakening, but might weaken logic that is
    actually used by the design.

    The default is "false".

-recipe recipe_name_path -config
    -cout_ncfow_min_tick min_tick [-param_stage stage]

    Specify the earliest simulation tick to be used in the causal fanin
    analysis performed during the processing of output constraints.
    The actual first tick is the maximum of the given tick and the earliest
    tick with variable bindings.

    The default is "0".

-recipe recipe_name_path -config
    -cout_ncfow_max_size fanout_max_size

    Specify the maximum size of the causal fanin cone used for noncausal fanout
    weakening when processing the output constraints. When the causal fanin
    cone reaches the specified size, further traversal of it is abandoned, and
    noncausal fanout weakening list computation stops.

    The default is "200000".

-recipe recipe_name_path -config
    -constant_propagation (true | false)

    Configure a canonical symbolic simulation run prior to the main
    non-canonical simulation run. The results of the canonical run are used to
    propagate constants and "near-constants" through the circuit, to help simplify
    expressions in the later non-canonical simulation. The threshold for
    "near constants" is configured by "-constant_propagation_max_size"
    configuration.

    NOTE: If noncausal fanout weakening is also enabled
    (via "-noncausal_fanout_weaken true" configuration), then the same canonical
    simulation run is used in both computations. 

    The default value is "false".

-recipe recipe_name_path -config
    -constant_propagation_dyn_wlim dyn_wlim

    Configure the dynamic weakening limit ("dyn_wlim") for the canonical
    symbolic simulation run.
    NOTE: This option is relevant only when "-constant_propagation" is "true"
    and "-noncausal_fanout_weaken" is "false" (namely, non-causal fanout
    weakening is turned off). If both non-causal fanout weakening and
    constant propagation are enabled, the dynamic weakening limit specified
    for non-causal fanout weakening is used for both.

    The default value is "100".

-recipe recipe_name_path -config
    -constant_propagation_max_size max_size

    Configure the threshold for "near-constants" expressions that are
    transferred from the constant propagation simulation to the main
    non-canonical simulation. All expressions whose canonical size is under
    "max_size" are transferred.
    NOTE: This option is relevant only when "-constant_propagation" is "true".

    The default value is "0", which corresponds to transferring only constants
    "0" and "1".

-recipe recipe_name_path -config
    -constant_propagation_min_tick min_tick

    Configure the earliest simulation tick for which to transfer constants to
    the main non-canonical simulation. The actual first tick used is the maximum
    of the given tick and the earliest tick specified in the variable antecedent
    (or conditional variable antecedent).
    NOTE: This option is relevant only when "-constant_propagation" is "true".

    The default value is "1".

-recipe recipe_name_path -config
    -constant_propagation_max_tick max_tick

    Configure the latest simulation tick for which to transfer constants to
    the main non-canonical simulation. The actual last tick used is the minimum
    of the given tick and the last tick referred to by an output constraint.
    If the given tick is 1, however, the last tick shall be the last tick
    referred to by an output constraint.
    NOTE: This option is relevant only when "-constant_propagation" is "true".

    The default value is "1".

-recipe recipe_name_path -config
    -use_sat_solver (true | false)

    Configure the implication check of the output constraints to use SAT
    solver (Satver) or BDDs (Conjver).

    The default is "false".

-recipe recipe_name_path -config
    -conjver_fail_on_first (true | false)

    Configure conjunction verification of the output constraints to stop at the
    first failure (true) or continue on and try to prove the following output
    constraints (false).
    NOTE: This option is relevant only when "-use_sat_solver" is "false".

    The default is "true".

-recipe recipe_name_path -config
    -conjver_max_passes conjver_max_passes

    Configure the maximum number of passes performed to prove each output
    constraint. If the tool reaches the maximum number of passes before the
    output constraint is proven, it abandons the proof of this output constraint.
    NOTE: This option is relevant only when "-use_sat_solver" is "false".

    The default is "3".

-recipe recipe_name_path -config
    -conjver_max_goal_size conjver_max_goal_size

    Configure the maximum canonical size reached in an attempt to prove an output
    constraint. If the tool reaches the maximum size before the output
    constraint is proven, it abandons the proof of this output constraint.
    NOTE: This option is relevant only when "-use_sat_solver" is "false".

    The default is "1000000".

-recipe recipe_name_path -config
    -conjver_strategy conjver_strategy_dict

    Configure a custom strategy for the conjunction verification, specifying per
    output constraint, the set of input constraints applied in its verification
    and the order in which they are applied.
    "conjver_strategy_dict" is a Tcl dictionary that maps an output constraint,
    which is a tuple of "(signal tick)", to a list of input constraints that are
    also tuples of "(signal tick)".
    NOTE: This option is relevant only when "-use_sat_solver" is "false".

    The default is to use the default conjver strategy.

-recipe recipe_name_path -config
    -sat_solver_time_limit time_limit

    Configure a "time_limit" to use for each call to the SAT solver.
    A value of 0 means unlimited.
    NOTE: This option is relevant only when "-use_sat_solver" is "true".

    The default is "0".

-recipe recipe_name_path -config
    -sat_solver_sequential (true | false)

    Configure whether to prove each of the output constraints separately (true)
    or all together (false).
    NOTE: This option is relevant only when "-use_sat_solver" is "true".

    The default is "false".

-recipe recipe_name_path -config
    -sat_solver_fail_on_first (true | false)

    Configure conjunction verification of the output constraints to stop at the
    first failure (true) or continue and try to prove subsequent output
    constraints (false).
    NOTE: This option is relevant only when "-use_sat_solver" is "true".

    The default is "true".

-recipe recipe_name_path -config
    -sat_solver_vacuity_check (true | false)

    Configure whether to check the input constraints for vacuity.
    NOTE: This option is relevant only when "-use_sat_solver" is "true".

    The default is "false".

-recipe recipe_name_path -config
    -sat_solver_top_check (true | false)

    Configure whether to check the input constraints for TOP value.
    NOTE: This option is relevant only when "-use_sat_solver" is "true".

    The default is "false".

-recipe recipe_name_path -config
    -reference_tick tick

    All the ticks in all the rest of the configurations are relative to the
    specified reference tick.

    The default is "0".

-recipe recipe_name_path -config
    -init_states (true | false)

    Configure whether to initialize the design to the reset states given by
    the reset command when proving this recipe. If set to "false", the design
    is initialized to an arbitrary state (all non-constant state elements are
    initialized to "X").

    The default is "true".

-recipe recipe_name -remove

    Removes the specified recipe.
    NOTE: Only a top-level recipe can be removed.

Recipe Query
------------
-recipe recipe_name_path -get
    { [var_order] [add_extra_antc] [antc_all_ignore] [add_extra_antv]
      [antv_all_ignore] [add_x_fill_antv] [ant_resolve_conflicts]
      [varbind_check] [ant_check] [add_extra_cin] [cin_all_ignore]
      [add_extra_cout] [add_extra_cond_antv] [add_cin_observation]
      [add_cout_obervation] [add_wl] [add_extra_cond_wl]
      [weaken_ant] [vacuity_check_pass] [vacuity_check_exclude]
      [num_param_stages] [num_param_substages] [param_exclude_symbols]
      [param_constants_only] [param_bdd_limit] [param_disjoint]
      [antv_auto] [x_fill_auto] [cout_x_fill_auto]
      [cin_ncfow_dyn_wlim] [cin_main_dyn_wlim] [cout_ncfow_dyn_wlim]
      [cout_main_dyn_wlim] [cin_ncfow_dyn_wlim_per_tick]
      [cin_main_dyn_wlim_per_tick] [cout_ncfow_dyn_wlim_per_tick]
      [cout_main_dyn_wlim_per_tick] [cin_ncfow_bit_level_weaken]
      [cin_main_bit_level_weaken] [cout_ncfow_bit_level_weaken]
      [cout_main_bit_level_weaken] [cin_ncfow_canonize]
      [cin_main_canonize] [cout_ncfow_canonize] [cout_main_canonize]
      [untimed_ncfow] [untimed_ncfow_use_aborted] [untimed_ncfow_min_tick]
      [untimed_ncfow_max_size] [untimed_ncfow_max_passes]
      [cin_ncfow] [cin_ncfow_assume_clocks] [cin_ncfow_min_tick]
      [cin_ncfow_max_size] [cout_ncfow] [cout_ncfow_assume_clocks]
      [cout_ncfow_min_tick] [cout_ncfow_max_size] [reference_tick]
      [use_sat_solver] [sat_solver_time_limit] [sat_solver_sequential]
      [sat_solver_fail_on_first] [sat_solver_vacuity_check]
      [sat_solver_top_check] [conjver_fail_on_first] [conjver_max_passes]
      [conjver_max_goal_size] [conjver_strategy] [constant_propagation]
      [constant_propagation_dyn_wlim] [constant_propagation_max_size]
      [constant_propagation_min_tick] [constant_propagation_max_tick]
      [init_states]}

    Retrieve the configuration values for the given configurations. Returns a list
    of specified values where each element in the returned list is the value of
    the corresponding configuration.

    NOTE:
    . The command only returns the value of a configuration if it was set by
      the user. The tool does not return default values for configurations.
    . For "cummulative" configurations, the tool returns only the value
      accumulated for the given recipe. It does not return the value
      accumulated over ancestor recipes.
    . Use "check_symsim -recipe recipe_name_path -get" without additional
      arguments to return all user-specified configurations for the recipe.

-recipe -list

    List all existing recipes.

Resolved Recipe Creation, Deletion and Query
--------------------------------------------
-resolved_recipe -create
    -recipe recipe_name_path
    -antv antv_dict
    -cin cin_list
    [-model symbolic_model_ID]
    [-antc antc_dict] [-cout cout_dict]
    [-cond_antv cond_antv_list]
    [-cond_wl cond_wl]
    [-name resolved_recipe_name] [-force]

    Create a resolved recipe configuration. The resolution is performed based
    on the values configured for the various configurations or, if no value has
    been configured, based on the default configuration values.
    For "cummulative" configurations, the tool also takes into account the value
    accumulated over ancestor recipes when resolving a recipe configuration.
    While resolving the recipe configuration, the tool also performs sanity
    checks that have been configured.
    "antv_dict" is a Tcl dictionary that maps signals to a list of tuples
    with the following format: "(var, from:to)", where var is a variable name.
    "cin_list" is a Tcl list of Tcl dictionaries. Each Tcl dictionary specifies one
    assumption instance (namely, an assumption + tick pair) and stores information on when/if to
    parameterize it. This Tcl dictionary comprises of the following keys:
       name             (mandatory)
       tick             (mandatory)
       param            (optional, default to true)
       param_stage      (optional, tells what stage to param in, default to 0 meaning param
                         in the first stage, maybe the only stage)
       param_substage   (optional, tells what order to param within a stage. default to 0 
                         meaning param in the first substage)
       comment          (optional, and you can put some string in there)

    . Use "-model" to specify the model used. If you do not specify the model, the
      latest valid model for the current task is used.
    . Use "-antc" to specify constant antecedents. "antc_dict" is a Tcl dictionary
      that maps signals to a list of tuples with the following format:
      "(value, from:to)", where value is either 0 or 1.
    . Use "-cout" to specify output constraints. "cout_dict" is a Tcl dictionary
      that maps signals to a list of ticks.
    . Use "-cond_antv" to specify conditional variable bindings. "cond_antv_list"
      is a Tcl list of prioritized conditional bindings lists.
      Each prioritized conditional bindings list is a Tcl list of pairs of the
      following format: "(cond, binding_dict)", where "cond" is an expression ID
      and "binding_dict" is a Tcl dictionary that maps signals to a list of\
      tuples with the following format: "(var, from:to)", where var is a variable
      name. The condition determines whether the signals specified in the
      binding_dict will be bound (assuming that the conditions specified in the
      preceding pairs in the list do not hold.
    . Use "-cond_wl" to specify conditional weakening. "cond_wl" is a list of
      conditional weakenings. Each conditional weakening is a pair of the
      following format: "{cond, weakening_dict}" where "cond" is an expression
      ID and "weakening_dict" is a Tcl dictionary that maps a signal to a list
      of tick intervals.
      The condition in each pair determines whether the signals specified in
      the corresponding weakening_dict will be weakened.
    . Use "-name" to specify a name for the resolved recipe. If you do not use
      this option, the created resolved recipe gets the same name as that of
      the recipe it is based on.
    . Use "-force" to override an existing resolved recipe. If you do not use
      this option, and a resolved recipe by this name already exists, the tool
      issues an error.

-resolved_recipe resolved_recipe_name -remove

    Removes the specified resolved recipe, including all the sequences
    generated during its creation.
    NOTE: Only a top-level resolved recipe can be removed.

-resolved_recipe -list

    List all existing resolved recipes.

Prove
------
-prove -resolved_recipe resolved_recipe_name_path
    [-start_from proof_ID
                 (  generate_untimed_ncfow | cin_ncfow_simulation
                  | cin_generate_ncfow | cin_main_simulation| generate_param
                  | apply_param | cout_ncfow_simulation | cout_generate_ncfow
                  | cout_constant_propagation | cout_main_simulation
                  | cout_verification ) stage_num]
    [-stop_after (  generate_untimed_ncfow | cin_ncfow_simulation
                  | cin_generate_ncfow | cin_main_simulation| generate_param
                  | apply_param | cout_ncfow_simulation | cout_generate_ncfow
                  | cout_constant_propagation | cout_main_simulation
                  | cout_verification ) stage_num]
    [-debug_mode]

    Run the Datapath Formal Verification proof flow on the resolved recipe
    specified by "resolved_recipe_name_path".

    The flow runs a series of steps in the order shown below:
    . generate_untimed_ncfow
    . cin_ncfow_simulation (*)
    . cin_generate_ncfow (*)
    . cin_main_simulation (*)
    . generate_param (*)
    . apply_param (*)
    . cout_ncfow_simulation
    . cout_generate_ncfow
    . cout_constant_propagation
    . cout_main_simulation
    . cout_verification

    NOTE: If your proof flow includes staged PARAM, the steps marked with (*) 
    will be performed multiple times, once per each stage. The stages are
    numbered starting from 0. Some of the steps are optional and are run
    depending on the recipe configuration.

    . Use "-start_from" to start the proof flow from a specific intermediate
      step/stage using the results of a previous proof run specified by
      "proof_ID" as the basis for the current run.

      NOTE:
      . The "start_from" step can be any step up to the last step reached in
        the "proof_ID" run or the step immediately following it in the proof
        flow. Any other "start_from" step results in an error.
      . If the "start_from" step preceeds the last step reached in the
        "proof_ID" run, the tool overwrites the results of any step from the
        "start_from" step and up to the last step obtained by "proof_ID".

    . Use "-stop_after" to stop the proof flow after a specific intermediate
      step/stage.

    . Use "-debug_mode" to enable higher verbosity during the proof flow and
      to include all nodes in the observation list during the various
      simulations performed during the proof flow. This eases debugging
      because the values of all the signals are included in the output traces.

      NOTE:
      . If you do not specify "-debug_mode", only the target properties for
        each evaluation are included in the observation list.
      . Using "-debug_mode" can increase memory consumption.

    Returns a Tcl dictionary that contains the following key/value pairs:

    Key                    Value
    -------------------    ------------------------------------------------
    recipe_type            The recipe type on which the proof flow operated.
                           Either "leaf", "assume_guarantee",
                           "case_split_on_cin", or "case_split_on_cout".

    recipe_results         The results of the proof flow. (see below for
                           additional information)

    The "recipe_results" value varies according to the "recipe_type". In case
    of a non-"leaf" recipe type, this field consists of a Tcl dictionary
    with the recipe cases as keys and the proof results for each case as
    the value. In addition, it includes entries of "exit_status" and
    "run_status" (see below for further details). The "exit_status" and
    "run_status" values for a a non-"leaf" recipe type are a rollup of the
    values over its entire sub-recipe-tree.
    In case of a "leaf" recipe, the recipe_results value consists
    of a a Tcl dictionary, which can contain the following key/value pairs:

    Key                    Value
    -------------------    -----------------------------------------------
    proof_id               The ID assigned to the proof run

    exit_status            Status (See below for additional explanation.)

    run_status             Either "success" or "failure" (applies if the
                           flow exited with "completed" status)

    exit_step              The last step performed (applies if the flow
                           exited with "stopped_by_step" status)

    exit_stage             The stage corresponding to the last step
                           performed (applies if the flow exited with
                           "stopped_by_step" status and this is a staged
                           PARAM proof run)

    intermediate_result    A dictionary that holds the results of the
                           various intermediate steps run by the flow
                           (applies if the flow exited with either
                           "stopped_by_step" or "stopped_by_timeout"
                           status)

    error_type             The error that caused the flow to stop
                           (applies if the flow exited with
                           "stopped_by_error" status). Possible error
                           types: failed_to_set_bdd_order, vacuous_run,
                           non_boolean_cins, param_failed.

    solved_goals           List of passing output constraints (applies
                           if the flow exited with "completed" status)

    vacuous_goals          List of vacuous output constraints (applies
                           if the flow exited with "completed" status)

    unsolved_goals         List of failing output constraints (applies
                           if the flow exited with "completed" status)

    remaining_goals        List of output constraints that the flow
                           did not completely process (applies
                           if the flow exited with "completed" status)

    Interpret the exit status as follows:
    
    Status                 Definition
    ------------------     --------------------------------------------
    completed              The command ran to its end.

    stopped_by_step        The command was stopped because the step/stage
                           specified by "-stop_after" was reached.

    stopped_by_timeout     The command was stopped because it reached
                           the command time limit.

    stopped_by_interrupt   The command was stopped due to an interrupt.

    stopped_by_error       The command stopped due to an error.


Prove Results Query
-------------------
-prove [proof_ID] -get_result
    [-intermediate]

    Get the results of proof run "proof_ID".

    Use "-intermediate" to get the intermediate results of the proof run.
    These can be useful when debugging a failing run. If this switch is not
    used, the final proof results are returned. See "check_symsim -prove
    -resolved_recipe" for details on the format of the final proof results.

-prove [proof_ID] -get_result
    -non_causal_fanout_weakening
    [-stage stage] [-why] [-relevant]

    Get the results of the non-causal fanout weakening run performed as part of the proof.
    The command returns a Tcl dictionary with the following keys:
    . frontier: a map from (signal, tick) to an index.
    . why: a map from index of a (signal, tick) pair to the index of the
      (signal, tick) pair that caused it to be added to the frontier.
    . relevant: a map from (signal, tick) pair to a list of (signal, tick)
      pairs, which were added to the frontier due to it.

    . Use "proof_ID" to specify a proof other than the last proof run.
    . Use "-stage" to specify a stage other than the first stage in case of a staged-PARAM run.
    . Use "-why" or "-relevant" to get only the dictionary containing
      "why" and "relevant" results, accordingly.
      If you do not use these switches, the tool returns both "why" and
      "relevant" results.

    NOTE: The tool always returns the "frontier".

-prove [proof_ID] -remove_result

    Remove the intermediate results of the proof run "proof_ID", including all
    the intermediate sequences generated during the proof run.

Prove Results Save and Restore
-------------------------------
-prove proof_ID -save_result -file file_name

    Save the results of the proof run "proof_ID" to the specified file.

-prove -restore_result -file file_name

    Restores the proof results from the specified file, and returns the ID
    of the restored proof results.

Property Status Query
---------------------
-get_status property

    Get the DFV proof sub-status of a property. This complements the general
    property status. Possible return values follow:
    . unknown
    . unsolved
    . undetermined_x
    . undetermined_falsifiable
    . vacuous
    . solved

Symbolic Schematic Viewer
-------------------
-symbolic_schematic -show -signal signal_list
    -visualize_window visualize_window_name
    [-window window_name]

    Open a new Symbolic Schematic Viewer window adding the drivers of the
    provided signals. The Symbolic Schematic Viewer window will be attached to
    the provided Symbolic Visualize window.

    NOTE:
    . Use "-window window_name" to specify a name for the window.
    . If you reuse a window name, this command replaces its contents.

-symbolic_schematic -add -signal signal_list
    -visualize_window visualize_window_name
    -window window_name

    Add the drivers of the provided signals to the given window, center them,
    and select the first signal in the list.

    NOTE: The Symbolic Schematic Viewer window must already exist.

-symbolic_schematic -remove -signal signal_list
    -visualize_window visualize_window_name
    -window window_name

    Remove the provided signals and their drivers from the given window.

    NOTE: The Symbolic Schematic Viewer window must already exist.

-symbolic_schematic -save file_name
    -window window_name

    Save the Symbolic Schematic Viewer contents from the specified window into a file.

-symbolic_schematic -restore file_name
    -visualize_window visualize_window_name
    [-window window_name]

    Restore a saved Symbolic Schematic Viewer from a file into a new window or
    into a specified window. The Symbolic Schematic Viewer window will be attached to
    the provided Symbolic Visualize window.

    . Use "-window window_name" to specify a name for the window.
    . If you reuse a window name, this command replaces its contents.

Example:
% check_symsim -model -create
% check_symsim -model N -list input
% check_symsim -model N -get_sig_excitation in
% check_symsim -expression -var A
% check_symsim -expression -and $ID1 $ID2
% check_symsim -sequence $seq1 -union $seq2
% check_symsim -recipe R -config -noncausal_fanout_weaken 1
% check_symsim -recipe R -config -cin_main_dyn_wlim 1000
% check_symsim -recipe R -config -cout_ncfow_dyn_wlim_per_tick {{100 20:22}}
% check_symsim -recipe R -config -assume_guarantee
% check_symsim -recipe R -get {noncausal_fanout_weaken cin_main_dyn_wlim}

----------------------------------------

