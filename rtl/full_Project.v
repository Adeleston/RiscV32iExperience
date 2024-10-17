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
    reg clk;
    wire [31:0] nextPc;
    wire [31:0] instructions_address;
    wire [31:0] instructions_out;
