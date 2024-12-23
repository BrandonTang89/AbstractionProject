// Content Addressable Memory - Combinatorial Specification
// (not for verification yet, just for automatic abstraction stuff)

module cam_spec_aa #(
    parameter MEM_SIZE = 2**4,
    parameter WORD_SIZE = 32
) (
    input logic [WORD_SIZE-1:0] inp,
    input logic [MEM_SIZE-1:0] mem [WORD_SIZE-1:0],
    output logic o
);

logic [MEM_SIZE-1:0] m;

generate
    for (genvar i = 0; i < MEM_SIZE; i++) begin
        always_comb begin
            m[i] = (mem[i] == inp);
        end
    end
endgenerate

assign o = |m;

endmodule
