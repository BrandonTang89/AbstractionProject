# Progress Notes

- To deal with relational constraints, we observe that each SV assertion can have its logic be shifted out of the property and into the surrounding specification circuit. This means that we only need to check properties that are of the form `##k signal_name` where $k$ is the number of clock cycles required to establish a certain property and `signal_name` is the name of the signal that corresponds to the property being true. From this, we can apply the weak preimage image operation on the output constraints similar to what you would do for regular STE
    - In fact, even if we have multiple properties to check, we will always be taking weak preimages of `TRUE` and `FALSE` so do not need to repeatedly the preimage operation
    - Furthermore, the preimage of `FALSE` is always `FALSE`
    - the preimage of `TRUE` is generally always any assignmnets to XS that have any mapping to the targets TS
    - The checking of the property being satisfied in the end is done by just checking that the transformed property's dual rail expressions imply that of the relevant wire in the symboic simulation.
    - This is illustrated in the two cycle and gate `simulate_index_transform.tcl`

- The CAM example is working
    - It seems like jasper's proof engines are able to prove the CAM in general (with the limiting factor being the elaboration time for the circuit)
    - I have gotten a no abstraction symbolic simulation proof working (with some new API for my helper functions that mirror what `symsim_utils.tcl` does)
    - Working on implementing a manual indexing relation.