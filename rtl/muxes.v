module mux2x1_1(
input [31:0] imm,
input PCASRC,
output [31:0] mux_1out
);
assign mux_1out = PCASRC?32'h00000004:imm;
endmodule
module mux2x1_2(
input [31:0] rs1,
input [31:0] pcountervalue,
input PCBSRC,
output [31:0] mux_2out
);
assign mux_2out = PCBSRC?rs1:pcountervalue;
endmodule
module mux2x1_3(
input [31:0] rs1,
input [31:0] pcountervalue,
input ALUAsrc,
output [31:0] mux_3out
);
assign mux_3out = ALUAsrc?pcountervalue:rs1;
endmodule
module mux3x1_4(
input [31:0] rs2,
input [31:0] imm_v,
input [1:0] ALUBsrc,
output reg [31:0] mux_4out
);
always @(*) begin
    case(ALUBsrc)
        2'b00: mux_4out = 32'h00000004;     // Default increment
        2'b01: mux_4out = imm_v;              // Immediate
        2'b10: mux_4out = rs2;              // Register value (rs2)
        default: mux_4out = 32'h00000000;   // Safe default case
    endcase
end
endmodule
module lastmux2x1(
input [31:0] rslt,
input [31:0] DataOut,
input MemtoReg,
output [31:0] out
);
assign out = MemtoReg?rslt:DataOut;
endmodule
