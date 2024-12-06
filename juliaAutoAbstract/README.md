# Automated Abstraction

- `bp_test.sv` : Contains the example circuit from the Automated Abstraction paper (Adams, 2007 figure 2)
- `load.tcl` : A startup script that loads and elaborates bp_test
- `auto_abstract_simple.tcl` : The automatic abstraction (bp_simple) algorithm
- `auto_abstract.tcl` : The full automatic abstraction algorithm
    - Note: the algorithm is not yet complete - find_big_ands will only find small ands, and the XNOR case is currently non functional