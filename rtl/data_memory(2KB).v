module data_memory(
    input wire MemWr,//Memory write signal
    input wire [2:0] MemOP,//Memory Operations signals for LBU, LB, LH, LHU, LW and S types
    input wire clkR, //clock puls for reading
    input wire clkW, //clock puls to write
    input wire [31:0] data_mem_address,//Address of data memory
    input wire [31:0] data_mem_input,//Incoming data to memory
    output reg [31:0] data_mem_output//Outcoming data from memory
);
    localparam Depth=2048;//memories depth
    reg [7:0] data_mem [0:Depth-1];//memory size 8x2048
    integer i;
    initial begin//Intializing memory to zero for all cells
    for (i=0; i<Depth; i=i+1)
        data_mem[i]<=0;
    end
    always @(posedge clkR)//Clock for reading from memoy
        if (~MemWr)//if write signals is 0
            begin
                if (MemOP[2]) //If Memory operation's left most significant bit is 1 then Load Word
                    begin
                        //Loading Word byte by byte
                        data_mem_output[7:0]<=data_mem[data_mem_address];
                        data_mem_output[15:8]<=data_mem[data_mem_address+1];
                        data_mem_output[23:16]<=data_mem[data_mem_address+2];
                        data_mem_output[31:24]<=data_mem[data_mem_address+3];
                    end
                else//If it is not Load Word
                begin
                    data_mem_output[7:0]<=data_mem[data_mem_address];//Load first byte (it is common for all types)
                    if (MemOP[1]) // If it is half word
                        data_mem_output[15:8]<=data_mem[data_mem_address+1];//load second byte
                    else//Otherwise fill up with zero
                        data_mem_output[15:8]<=0;
                    //It is not Word command therefore last 2 byte will be filled with zero/ones
                    data_mem_output[23:16]<=0;
                    data_mem_output[31:24]<=0;
                    if (MemOP[0] && data_mem_output[15] && MemOP[1])//If it is signed Half Word number with negative symbol
                        begin
                            //Rewrite last two bytes with ones
                            data_mem_output[23:16]<=8'b1;
                            data_mem_output[31:24]<=8'b1;  
                        end else
                    if (MemOP[0] && data_mem_output[7] && ~MemOP[1])//If it is signed Byte Word number with negative symbol
                        begin
                            //Rewrite last three bytes with one
                            data_mem_output[15:8]<=8'b1;
                            data_mem_output[23:16]<=8'b1;
                            data_mem_output[31:24]<=8'b1;
                        end
                end
            end
     always @(negedge clkW)//Clock puls for writing to memory
        if (MemWr)// If Memory Write signal is 1
            begin
                data_mem[data_mem_address]<=data_mem_input[7:0];//Write the first byte
                if (MemOP[1])//Write the second byte if it is Half word
                    data_mem[data_mem_address+1]<=data_mem_input[15:8];
                if (MemOP[2])// Write the third and fourth bytes if it is Word
                    begin
                        data_mem[data_mem_address+1]<=data_mem_input[15:8];
                        data_mem[data_mem_address+2]<=data_mem_input[23:16];
                        data_mem[data_mem_address+3]<=data_mem_input[31:24];
                    end
            end
endmodule
