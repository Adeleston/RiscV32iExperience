`timescale 1ns / 1ps
module reg_file(
    input [31:0] inst,
    input [31:0] busW,
    input RegWr,
    input Wr_Clk,
    input resetn,
    output reg [31:0] rs1,
    output reg [31:0] rs2
    );
    integer i;
    reg [4:0] Ra;
    reg [4:0] Rb;
    reg [4:0] Rw;
    reg [31:0] register [31:0];
    initial begin
                for(i=0;i<32;i=i+1)begin
                 register[i] <= 0;
        end
    end
    always@(*) begin
        if(!resetn)begin
            rs1 <= 32'h00000000;
            rs2 <= 32'h00000000;
        end 
        Ra = inst[19:15]; 
        Rb = inst[24:20]; 
        Rw = inst[11:7];  
    end
    always @(negedge Wr_Clk or negedge resetn) begin
        if(!resetn)begin
        end
        else if (RegWr && (Rw != 0))
            register[Rw] <= busW;
        end
endmodule
