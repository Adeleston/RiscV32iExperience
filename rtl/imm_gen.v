module imm_gen (
    input   [31:0] inst,  //instruction
    input   [2:0] imm_control,        
    output  reg [31:0] i_imm,    //addi,slti,sltu,xori,ori,andi,lb,lh,lw,lbu,lhu,jalr
    output  reg [31:0] b_imm,    //beq,bne,blt,bge,bltu,bgeu
    output  reg [31:0] j_imm,    //jal
    output  reg [31:0] s_imm,    //sb,sh,sw
    output  reg [31:0] ii_imm    //lui,aıpic
    );
        always@(*) begin
            case (imm_control)
                3'b000: i_imm = {{21{inst[31]}}, inst[30:20]};                                             
                3'b001: b_imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};            //1'b0 hizalama biti           
                3'b010: j_imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};      
                3'b011: s_imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};                    
                3'b100: ii_imm = {inst[31:12], 12'b0};                                 
                default: begin
                    i_imm = 32'b0;
                    b_imm = 32'b0;
                    j_imm = 32'b0;
                    s_imm = 32'b0;
                    ii_imm = 32'b0;
                end
            endcase
        end
endmodule
