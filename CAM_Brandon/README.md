# CAM Verification

This circuit is a read-only CAM that has the following behavior:
> Suppose that `trigger` is high at time `t` then at time `t+1`, hit is true if and only if at time `t`, we had `query` present in the CAM.

Note that with `addr_width = 13` and `data_width = 512`, Jasper takes a long long time to parse the circuit but can prove the property.
Any more entries and it seems like parsing (but not proving) is the main limiting factor.


## Files
- `verify_cam.tcl`: Proof without using symbolic simulation
- `simulate_noabs.tcl`: Does a fully running rSTE proof with no abstraction.
- `simulate_manual_index.tcl`: WIP rSTE with manually written indexing relation