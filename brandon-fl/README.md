# VOSS II Examples - Brandon
Small examples from [VossII](https://github.com/TeamVoss/VossII) that showcase the use of STE to perform formal verification.

## Files
- `ThreeWayAndGate_correct.fl`: 
    - Contains fl code for a 0-delay 3-way AND gate
    - Shows a proof that involves
        - Parameterised input constraints
        - Symbolic indexing transformation of paramed antecedent and consequent
        - Symbolic simulation of the circuit with verified proof
- `ThreeWayAndGate_wrong.fl`: 
    - Similar to `ThreeWayAndGate_correct.fl` but with a wrong property and thus a failed proof
- `vossii-fl-1.3.1.vsix`: 
    - An extension for VS Code syntax highlighting, built from [vossii-fl](https://github.com/dlesbre/vossii-fl/tree/master)