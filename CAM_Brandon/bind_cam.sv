// =====================================================================
// Bindfile to plug properties into the DUT
// =====================================================================

bind cam_top cam_spec #(.DATA_LENGTH(DATA_LENGTH), .ADDR_WIDTH(ADDR_WIDTH)) spec(.*);
