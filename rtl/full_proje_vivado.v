`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 03:55:50 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench;
    reg resetn;
    reg clk;
    wire [31:0] nextPc;
    wire [31:0] instructions_address;
    wire [31:0] instructions_out;
    // Initialize clock
    initial clk = 0;
    always #20 clk = ~clk; // Generate clock signal
    // Instantiate modules
    programcounter PC_uut(.NextPc(nextPc), .clk(clk), .Pc(instructions_address) ,.resetn(resetn));    
    instruction_memory inst_mem_uut(
        .clk(clk),
        .write_enable(1'b0),
        .resetn(resetn),
        .address_inst_mem(instructions_address), 
        .data_input(0), 
        .data_out(instructions_out)
    );
    // Control signals
    wire [2:0] ExtOp;
    wire RegWr;
    wire ALUASrc;
    wire [1:0] ALUBSrc;
    wire [3:0] ALUCtr;
    wire [2:0] Branch;
    wire MemtoReg;
    wire MemWr;
    wire [2:0] MemOp;   
    wire JumpS;
    control_unit c_uut(
        .inst(instructions_out),
        .ExtOp(ExtOp), 
        .RegWr(RegWr), 
        .ALUASrc(ALUASrc), 
        .ALUBSrc(ALUBSrc), 
        .ALUCtr(ALUCtr), 
        .Branch(Branch), 
        .MemtoReg(MemtoReg), 
        .MemWr(MemWr), 
        .MemOp(MemOp), 
        .JumpS(JumpS)
    );
    // Register file signals
    wire [31:0] rs1;
    wire [31:0] rs2;
    wire [31:0] busW;
    wire [31:0] imm_out;
    wire [31:0] mux1_out;
    wire [31:0] mux2_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;
    reg_file reg_f_uut(
        .inst(instructions_out), 
        .busW(busW), 
        .RegWr(RegWr),
        .Wr_Clk(clk),
        .resetn(resetn), 
        .rs1(rs1), 
        .rs2(rs2)
    );
    imm_gen img_uut(
        .inst(instructions_out[31:7]), 
        .ExtOp(ExtOp), 
        .imm_out(imm_out)
    );
    wire PCAsrc, PCBsrc;
    mux2x1_1 mux1_uut(
        .PCASRC(PCAsrc), 
        .imm(imm_out),
        .mux_1out(mux1_out)
    );
    mux2x1_2 mux2_uut(
        .rs1(rs1), 
        .pcountervalue(instructions_address), 
        .PCBSRC(PCBsrc),
        .mux_2out(mux2_out)
    );
    mux2x1_3 mux3_uut(
        .rs1(rs1), 
        .pcountervalue(instructions_address), 
        .ALUAsrc(ALUASrc),
        .mux_3out(mux3_out)
    );
    mux3x1_4 mux4_uut(
        .rs2(rs2), 
        .imm_v(imm_out), 
        .ALUBsrc(ALUBSrc), 
        .mux_4out(mux4_out)
    );
    adder adder_uut(
        .mux_1out(mux1_out), 
        .mux_2out(mux2_out), 
        .NextPc(nextPc)
    );
    wire less, zero; // Ensure 'zero' is correctly defined
    wire [31:0] result;
    alu alu_uut(
        .rsA(mux3_out), 
        .rsB(mux4_out), 
        .ALUctr(ALUCtr), 
        .less(less), 
        .zero(zero),
        .result(result)
    );
    Branch_Module Branch_M_UUT(
        .JumpS(JumpS),
        .Branch(Branch), 
        .Less(less), 
        .Zero(zero),  // Ensure this is consistent
        .PCASRC(PCAsrc), 
        .PCBSRC(PCBsrc)
    );
    wire [31:0] data_mem_out;
    data_memory data_mem_uut(
        .MemWr(MemWr),
        .MemOP(MemOp), 
        .clkR(clk), 
        .clkW(clk),
        .resetn(resetn), 
        .data_mem_address(result), 
        .data_mem_input(rs2),
        .data_mem_output(data_mem_out)
    );
    lastmux2x1 last_mux_uut(
        .rslt(result), 
        .DataOut(data_mem_out), 
        .MemtoReg(MemtoReg), 
        .out(busW)
    );
    // Simulation control
    initial begin
        resetn = 0;
        #40;
        resetn = 1;
        $monitor("Time: %t | Next PC: %h | Instructions Address: %h | Instructions Out: %h | rs1: %h | rs2: %h | ALU Result: %h",
                 $time, nextPc, instructions_address, instructions_out, rs1, rs2, result);
        #2500; // Run the simulation for 1000 ns
        $finish;
    end
endmodule



