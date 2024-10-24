`timescale 1ns / 1ps
module programcounter(
    input [31:0] NextPc,
    input clk,          
    output reg [31:0] Pc  
);
initial begin
    Pc = 32'h00000000;
end
always @(negedge clk) begin
    if(NextPc)begin
    Pc <= NextPc;
    end
end
endmodule
