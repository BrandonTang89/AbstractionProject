
// creates a really large recursively generated AND gate
// WIDTH must be a power of two

module andComponent #(
    parameter WIDTH=2
) (
    input [WIDTH-1:0] operands,
    output logic result
);

generate
        if (WIDTH == 2) begin
            assign result = operands[0] & operands[1];
        end
        
        else begin
            // divide in half and recurse
            andComponent #(WIDTH/2) l (operands[WIDTH/2-1:0], lResult);
            andComponent #(WIDTH/2) h (operands[WIDTH-1:WIDTH/2], hResult);
            assign result = lResult & hResult;
        end
endgenerate

endmodule


module megaAnd #(
    parameter WIDTH=16
) (
    input [WIDTH-1:0] operands,
    input logic trigger,
    input logic clk,
    output logic result 
);


logic pre_result;

andComponent #(WIDTH) m (operands, pre_result);

// to make it more interesting; have it do nothing until trigger is hit, then one cycle later output the result, then one cycle after that it's negation
// this is mainly just to add more interesting properties to validate


logic trigger_1;
logic trigger_2;

logic pre_result_1;
logic pre_result_2;

always_ff @(posedge clk) begin 
    trigger_1 <= trigger;
    trigger_2 <= trigger_1;
    pre_result_1 <= pre_result;
    pre_result_2 <= pre_result_1;
end

assign result = trigger_1 ? pre_result_1 : (trigger_2 ? ~pre_result_2 : 0);

endmodule