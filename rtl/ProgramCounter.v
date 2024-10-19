module programcounter(
    input [31:0] NextPc,
    input clk,          
    output reg [31:0] Pc  
);
initial begin
    if(NextPc)begin
    Pc = 32'h00000000;
    end
end
always @(negedge clk) begin
    Pc <= NextPc;
end
endmodule
