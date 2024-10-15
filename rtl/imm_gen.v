module imm_gen (
    input [31:0] inst,  
    input [2:0] ExtOp,        
    output reg [31:0] imm_out,  
    );
        always@(*) begin
            case (ExtOp)
                3'b000: imm_out = {{21{inst[31]}}, inst[30:20]};  //addi,slti,sltu,xori,ori,andi,lb,lh,lw,lbu,lhu,jalr                                           
                3'b001: imm_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; //beq,bne,blt,bge,bltu,bgeu          
                3'b010: imm_out = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0}; //jal     
                3'b011: imm_out = {{21{inst[31]}}, inst[30:25], inst[11:7]};  //sb,sh,sw                  
                3'b100: imm_out = {inst[31:12], 12'b0}; //lui,aıpic
                default: imm_out = 32b'0;
            endcase
        end
endmodule
