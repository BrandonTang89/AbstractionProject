// =====================================================================
// Content Addressable Memory (CAM) Example
//
// Definition of the design being verified.
// =====================================================================


module cam_top #(
    parameter DATA_WIDTH = 8,  // Width of the data bus
    parameter ADDR_WIDTH = 4   // Width of the address bus
)(
    input logic clk,                       // Clock signal
    input logic [DATA_WIDTH-1:0] query,    // Value to check bus
    input logic trigger,                   // Trigger signal
    output logic hit                       // Hit signal (true if data is found, 1 cycle after trigger)
);

    // Memory array
    logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

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
        if (trigger) begin
            hit <= |match;  // Set hit if any match is found
        end else begin
            hit <= 0;       // Reset hit signal
        end
    end

endmodule