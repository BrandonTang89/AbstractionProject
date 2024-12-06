## Files
**Common Files**
- `symsim_utils.tcl`: A tcl script that contains recepies and procedures to help with DFV proofs
    - Note that around line 490, we change the line to use `dict set` rather than `dict lappend` to add a new key to the dictionary.
- `helpers.tcl`: Generic tcl helper functions
- `symsim_helpers_brandon.tcl`: Additional helper functions specific to `check_symsim`, complementing `symsim_utils.tcl`
- `check_symsim_ref.tcl`: Output of `help check_symsim` in jasper.