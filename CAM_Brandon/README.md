# CAM Verification

This circuit is a read-only CAM that has the following behavior:
> At each time, the hit signal is true if the query was found in the CAM at time t-1

Note that with `addr_width = 13` and `data_width = 512`, Jasper takes a long long time to parse the circuit but can prove the property.
Any more entries and it seems like parsing (but not proving) is the main limiting factor.


## Files
- `verify_cam.tcl`: Proof without using symbolic simulation
- `simulate_noabs.tcl`: Does a fully running rSTE proof with no abstraction.
- `simulate_manual_index.tcl`: WIP rSTE with manually written indexing relation