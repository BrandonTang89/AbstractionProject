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
- figure out how to inspect BDDs using tcl
    - check_symsim -expression -top_cofactor \<expr\> gives us what we need
- run individual symbolic simulations for each component in the circuit, to build up a BDD of each component's behavior
