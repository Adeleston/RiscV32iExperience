`include "BranchUnit.v"
`include "ProgramCounter.v"
`include "Uart.v"
`include "adder.v"
`include "alu.v"
`include "data_memory(2KB).v"
`include "imm_gen.v"
`include "instruction_memory(2KB).v"
`include "muxes.v"
`include "reg_file.v"
module full_Project(
input wire clk
);
	wire [31:0] nextPc;
    wire [2:0] ExtOp;
    wire RegWr;
    wire ALUASrc;
    wire [1:0] ALUBSrc;
	wire[4:0] ALUCtr;
    wire Branch;
    wire MemtoReg;
    wire MemWr;
    wire [2:0] MemOp;
    wire [31:0] imm;    //addi,slti,sltu,xori,ori,andi,lb,lh,lw,lbu,lhu,jalr
	wire [31:0] busW;
	wire [31:0] rs1;
	wire [31:0] rs2;
	wire PCASRC;
	wire PCBSRC;
	wire [31:0] mux_1out;
	wire [31:0] mux_2out;
	wire [31:0] mux_3out;
	wire [31:0] mux_4out;
	wire [31:0] PC;
	wire less,zero;
	wire [31:0] result;
	wire jump;
	wire [31:0] data_mem_output;
wire [31:0] Data_out;
instruction_memory instructmem(.clk(clk),.write_enable(1b'0),.address_inst_mem(nextPc),.data_input(32h'00000000),.data_out(Data_out));
control_unit cu(.jump(jump),.inst(Data_out),.ExtOp(ExtOp),.RegWr(RegWr),.ALUASrc(ALUASrc),.ALUBSrc(ALUBSrc),.ALUCtr(ALUCtr),.Branch(Branch),.MemtoReg(MemtoReg),.MemWr(MemWr),.MemOp(MemOp));
imm_gen immgen(.inst(Data_out),.ExtOp(ExtOp),.imm(imm));
reg_file rg(.inst(Data_out),.busW(busW),.RegWr(RegWr),.Wr_Clk(clk),.rs1(rs1),.rs2(rs2));
mux2x1_1 mu1x2x1(.imm(imm),.PCASRC(PCASRC),.mux_1out(mux_1out));
mux2x1_2 mu2x2x1(.rs1(rs1),.imm_v(PC),.PCBSRC(PCBSRC),.mux_2out(mux_2out));
mux2x1_3 mu3x2x1(.rs1(rs1),.imm_v(PC),.ALUASrc(ALUASrc),.mux_3out(mux_3out));
mux3x1_4 mu4x3x1(.rs2(rs2),.imm_v(PC),.ALUBSrc(ALUBSrc),.mux_4out(mux_4out));
alu alalabilirsen(.rs1(mux_3out),.rs2(mux_4out),.ALUCtr(ALUCtr),.less(less),.zero(zero),.result(result));
adder add(.mux_1out(mux_1out),.mux_2out(mux_2out),.NextPc(nextPc));
BranchUnit BU(.Branch(Branch),.Zero(zero),.Less(less),.Jump(jump),.PCASRC(PCASRC),.PCBSRC(PCBSRC));
ProgramCounter ProgramEater(.NextPc(nextPc),.clk(clk),.PC(PC));
data_memory datamem(.MemWr(MemWr),.MemOp(MemOp),.clkR(clk),.clkW(clk),.data_mem_address(result),.data_mem_input(rs2),.data_mem_output(data_mem_output));
lastmux2x1 lastmux(.rslt(result),.DataOut(data_mem_output),.MemtoReg(MemtoReg),.out(busW));
