# 2-Cycle And Gate Verification

## Files
**Base Set-Up**
- `and_2_cycles.sv`: The SystemVerilog file containing the 2-cycle AND gate.
- `bind_and_2_cycles.sv`: The SystemVerilog file binding the DUT to the specification
- `v_and_2_cycles.sva`: The SystemVerilog file containing the assertions we want to verify
- `verify_and_2_cycles.sby`: The SymbiYosys file containing the commands to run a Jasper proof without `check_symsim`
- `symsim_utils.tcl`: A tcl script that contains recepies and procedures to help with DFV proofs
    - Note that around line 490, we change the line to use `dict set` rather than `dict lappend` to add a new key to the dictionary.
- `helpers.tcl`: Generic tcl helper functions

**Symbolic Simulation Verification**
- `verify_with_utils.tcl`: A tcl script that uses recepies and procedures from `symsim_utils.tcl` to perform a proof of the AND gate
    - DFV can prove the property for all clock phases $\ge 6$ so if we want to fully prove the property then we need to run the last (commented) command to finish up the first 5 clock phases.
    - We set 6 distinct BDD input variables on each of the input signals `a`, `b` and `c` on the 2nd and 4th clock phases. We check the output constraint on the `6th` clock phase. This is correct since the property we are trying to verify uses a `past` from two clock cycles ago.
        - If we try to check the output constraint on an earlier clock phase, the proof will fail since the inputs are `X` before the 2nd clock phase.
        - If we try to check the output constraint on a later clock phase, the proof will fail since the inputs are `X` after the 4th clock phase.
    - We know that the other than this, the proof works since the bound changes from `1-` to `1-5`
- `verify_with_checksymsim.tcl`: Similar to `verify_with_utils.tcl` but uses `check_symsim` directly to perform the proof.

**Symbolic Simulation Runs**
- `simulate_checksymsim.tcl`: Using `check_symsim`, we assume that the input variables are stable and perform a symbolic simulation on the circuit. We can see the output change from `X` to `1` by the 6th clock phase.
- `simulate_param.tcl`: Does a symbolic simulation that has an input constraint which gets parameterized before the symbolic simulation is run.