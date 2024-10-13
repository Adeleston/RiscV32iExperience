timescale 1ns / 1ps
module instruction_memory(
    input wire clk, //clock puls
    input wire write_enable, // write to Instruction Memory
    input wire [31:0] address_inst_mem,// address of instruction
    input wire [31:0] data_input,//input data to instruction memory
    output reg [31:0] data_out//output data from instruction memory
    );
    localparam Depth=2048;// Amount of addresses
    reg [7:0] instruction_mem [0:Depth-1]; // Defining memory with 8 bit word length
    initial begin
    $readmemh("D:\list_of_instructions.txt", instruction_mem); //Dump to memory initial values from txt file in hex format
    end
    always @(negedge clk) //Write to intrcution memory at negative edges
        if (write_enable) // When write option is 1
            begin
                    //Write to memory instructions byte by byte
                instruction_mem[address_inst_mem]<=data_input[7:0];// for first byte
                instruction_mem[address_inst_mem+1]<=data_input[15:8];//Second byte
                instruction_mem[address_inst_mem+2]<=data_input[23:16];//Third byte 
                instruction_mem[address_inst_mem+3]<=data_input[31:24];//Fourth byte
            end
        else//Otherwise read from memory an instruction
            begin
                //Put instruction on datapath byte by byte
                data_out[7:0]<=instruction_mem[address_inst_mem];// for first byte
                data_out[15:8]<=instruction_mem[address_inst_mem+1];//Second byte
                data_out[23:16]<=instruction_mem[address_inst_mem+2];//Third byte
                data_out[31:24]<=instruction_mem[address_inst_mem+3];//Fourth byte
            end
endmodule