// Content Addressable Memory - Julia
// Real circuit, with clocking and write logic
// see spec.sv for a simplified clock-free version to run the automatic abstraction algorithm on!
// TODO: in simple cases where it's combinatorial triggered on a cycle, can we automatically remove the clocking logic? 


module cam #(
    parameter MEM_SIZE = 2**4,
    parameter WORD_SIZE = 32
) (
    input logic [WORD_SIZE-1:0] inp, // the input to be compared
    input logic clk,
    input logic rst,
    input logic [MEM_SIZE-1:0] write [WORD_SIZE-1:0], // when reset goes high, copy the write inputs to the internal memory

    output logic o
);

logic [MEM_SIZE-1:0] m;
logic out_comb;
reg [MEM_SIZE-1:0] memory [WORD_SIZE-1:0];

// reset logic
always_ff @(posedge rst) begin
        memory <= write;
end

generate
    for (genvar i = 0; i < MEM_SIZE; i++) begin
        always_comb begin
            m[i] = (memory[i] == inp);
        end
    end
endgenerate

assign out_comb = |m; 

always_ff @( posedge clk ) begin
    o <= out_comb;
end

endmodule