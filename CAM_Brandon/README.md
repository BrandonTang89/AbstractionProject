# CAM Verification

This circuit is a read-only CAM that has the following behavior:
> At each time, the hit signal is true if the query was found in the CAM at time t-1

Note that with `addr_width = 13` and `data_length = 512`, Jasper takes a long long time to parse the circuit but can prove the property.
Any more entries and it seems like parsing (but not proving) is the main limiting factor.


## Files
- `verify_cam.tcl`: Proof without using symbolic simulation
- `simulate_noabs.tcl`: Does a fully running rSTE proof with no abstraction.
- `simulate_manual_index.tcl`: Fully running rSTE proof of the CAM with manually crafted indexing relation.
- `verify_cam_comb.tcl`: rSTE proof with automatic indexing, no symbolic constants
- `verify_cam_comb_efficient.tcl`: rSTE proof with automatic indexing, efficient preimage, no symbolic constants
- `verify_symbolic_constants.tcl`: rSTE proof with automatic indexing, efficient preimage, symbolic constants
    - Verification can be done either by doing the automatic abstraction on
        - the next_hit wire with query as the symbolic constant
        - the spec.found wire with query as the symbolic constant
        - Similar to in the 2007 paper, without the symbolic constants, we get over abstraction if we do abstraction over the circuit.
    - If we do the abstraction from the property wire, we end up losing coverage.
        - This might might be fixed when the automatic abstraction incorporates DAG/multiple fan-out

## Results
The use of efficient preimage computations is actually fairly invaluable in scaling to larger CAM sizes. The manual indexing can only really do up to 4 CAM entries, each 4 bits wide. The bottle neck is actually the computation of the indexing relation as a symsim expression. This issue is also seen in other files that don't make use of the efficient preimage computation.

For files that use the efficient preimage computation, the bottle neck becomes the automatic indexing algorithm.