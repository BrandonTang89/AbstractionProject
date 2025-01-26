// An example specification used to test automatic indexing relation generation
// Circuit taken from Automatic Abstraction in Symbolic Trajectory Evaluation, Adams, 2007, Figure 2

module simple_top #() (
    input logic  clk,
    input logic a, b, c, d,
    output logic o
);

logic y1, y2, y3, y4, y5, y6;

assign y1 = ~a;
assign y2 = ~b;
assign y3 = y1 & y2;
assign y4 = ~y3;
assign y5 = c & d;
assign y6 = y4 & y5;
assign o = y6;


endmodule

