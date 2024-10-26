`timescale 1ns / 1ps
module programcounter(
    input [31:0] NextPc,
    input clk,
    input resetn,          
    output reg [31:0] Pc  
);
always @(negedge clk) begin
    if(!resetn)begin
        Pc = 32'h00000000;
    end
    else begin
    Pc <= NextPc;
    end
end
endmodule
