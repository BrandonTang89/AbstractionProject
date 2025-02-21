// =====================================================================
// Max Example Circuit
//
// Definition of the design being verified.
// =====================================================================
module max_circuit_top #(
    parameter DATA_LENGTH = 2,  // Length of each data entry (should be a power of 2)
    parameter ADDR_WIDTH = 2    // Width of the address bus (this means that the CAM stores 2^ADDR_WIDTH entries)
)(
    input logic clk,                       // Clock signal
    input logic [DATA_LENGTH-1:0] ins [(2**ADDR_WIDTH)-1:0],
    output logic [DATA_LENGTH-1:0] maxCircuit_out   // Value to check bus
);
    // Intermediate max values
    logic [DATA_LENGTH-1:0] max_values [(2**(ADDR_WIDTH + 1))-1:0];

    // Generate block to create the tree of max operations
    genvar i, j;
    generate
        // Initialize the first level with memory values
        for (i = 0; i < 2**(ADDR_WIDTH); i++) begin : init
            always_comb begin
                max_values[2**(ADDR_WIDTH) + i] = ins[i];
            end
        end

        // Create the tree of max operations
        for (j = 1; j < 2**(ADDR_WIDTH); j++) begin : tree
            always_comb begin
                if (max_values[j*2] >= max_values[j*2+1]) begin
                    max_values[j] = max_values[j*2];
                end else begin
                    max_values[j] = max_values[j*2+1];
                end
            end
        end
    endgenerate

    // Output the final maximum value
    always_comb begin
        maxCircuit_out = max_values[1];
    end

endmodule