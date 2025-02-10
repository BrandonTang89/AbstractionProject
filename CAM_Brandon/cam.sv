// =====================================================================
// Content Addressable Memory (CAM) Example
//
// Definition of the design being verified.
// =====================================================================

module cam_top #(
    parameter DATA_LENGTH = 2,  // Length of the each data entry (should be a power of 2)
    parameter ADDR_WIDTH = 2    // Width of the address bus (this means that the CAM stores 2^ADDR_WIDTH entries)
)(
    input logic clk,                       // Clock signal
    input logic q01, q02, q11, q12,
    output logic hit                       // Hit signal (true if data is found, 1 cycle after trigger)
);

    logic [DATA_LENGTH-1:0] query;    // Value to check bus

    // Memory array
    logic [DATA_LENGTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // Temporary variable for hit detection
    logic [2**ADDR_WIDTH-1:0] match;

    // Generate block to create parallel comparison logic
    genvar i;
    generate
        for (i = 0; i < (2**ADDR_WIDTH); i++) begin : compare
            always_comb begin
                match[i] = (mem[i] == query);
            end
        end
    endgenerate

    // Synchronous logic to set the hit signal
    always_ff @(posedge clk) begin
        hit <= |match;  // Set hit if any match is found
    end

    assign query[0] = q01 & q02;
    assign query[1] = q11 & q12;

endmodule