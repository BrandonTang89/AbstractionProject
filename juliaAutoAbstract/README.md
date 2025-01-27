# Automated Abstraction

- `bp_test.sv` : Contains the example circuit from the Automated Abstraction paper (Adams, 2007 figure 2)
- `load.tcl` : A startup script that loads and elaborates bp_test
- `auto_abstract_simple.tcl` : The automatic abstraction (bp_simple) algorithm
- `auto_abstract.tcl` : The full automatic abstraction algorithm
    - Note: the algorithm is not yet complete - find_big_ands will only find small ands, and the XNOR case is currently non functional


# Steps towards symsim for aa 

- Add MUX gate support to the algorithm, which we'll use to synthesise our BDDs
    - but this seems somewhat inefficient, can we recognise common gates out of the BDDs directly?
    - this would let us use the same AND, XNOR, NOT gates from the current algorithm
        - they also work as test cases for the pure MUX case
        - alternatively: keep the current naieve impl for those gates to avoid simulating everything
    - MUX gates are weird in that we now have the issue of effectively implementing env conditions in signals that are defined to be high or low by the specification
        - however we can just replace these cases with different gates to solve the issue!
        - yay
    
- figure out how to inspect BDDs using tcl
    - check_symsim -expression -top_cofactor \<expr\> gives us what we need
- run individual symbolic simulations for each component in the circuit, to build up a BDD of each component's behavior
    - ooh, we can use -get_sig_excitation to get the behavior of each line, in dual rail format... since we're not using any abstraction yet, just using one rail is enough
        - BUG: -top_cofactor doesn't seem to work on the returned expressions... No expression with id "0" exists!
        - but this appears to be resolved if the expr is actually used anywhere...
        - there are a number of :symsim_syn_* intermediate wires but if we recursively follow the tree we can probably just traverse them as if they were normal ones...
            - unclear where exactly they come from!


- Next todo: sort out get_case_exprs for when n is not a power of two
    - recurse over the binary expansion of n? weird but sure
    - also add the names stuff from the original algorithm
    - figure out how to merge cases