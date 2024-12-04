// =====================================================================
// Synchronous Memory
//
// Definition of the design being verified.
// =====================================================================


module sync_ram #(
    parameter DATA_WIDTH = 8,  // Width of the data bus
    parameter ADDR_WIDTH = 4   // Width of the address bus
)(
    input logic clk,                       // Clock signal
    input logic we,                        // Write enable
    input logic [ADDR_WIDTH-1:0] addr,     // Address bus
    input logic [DATA_WIDTH-1:0] data_in,  // Data input bus
    output logic [DATA_WIDTH-1:0] data_out // Data output bus
);

    // Memory array
    logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // Synchronous read and write
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr] <= data_in;  // Write data to memory
            data_out <= 0;          // Output 0 during write cycle
        end
        else begin
            data_out <= mem[addr];      // Read data from memory
        end
    end

endmodule