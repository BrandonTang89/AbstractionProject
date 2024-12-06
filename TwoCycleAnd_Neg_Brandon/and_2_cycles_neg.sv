// =====================================================================
// AND Gate that is true if all inputs are true for the past 2 cycles
//
// Definition of the design being verified.
// =====================================================================

module and_2_cycles_neg_top #()
(
 input logic  clk,
 input logic  a,b,c,
 output logic o,
 output logic no
);

logic  x;
assign x = a & b & c;
logic y;
always_ff @(posedge clk) begin
  y <= x;
end

always_ff @(posedge clk) begin
  o <= y & x;
  no <= ~(y & x);
end

   
endmodule
