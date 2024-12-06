// =====================================================================
// 
// Bindfile to plug properties into the DUT
// =====================================================================

// ---------------------------------------------------------------------
// Inject the assertion code in module and_spec into the DUT. The various 
// elements of this bind command are:
//
//  - and_top    the module that we are verifying
//  - and_spec   the module containing properties for verification
//  - spec       name of the "instance" of and_spec that will be created
//
// The notation "(.*)" means match - or wire things up - by name.
// ---------------------------------------------------------------------

bind and_2_cycles_neg_top and_2_cycles_neg_spec spec(.*);
