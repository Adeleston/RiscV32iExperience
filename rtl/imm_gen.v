module imm_gen (
    input   [31:0] inst,  //instruction
    input   [1:0] imm_control,        
    output  reg [31:0] i_imm,
    output  reg [31:0] b_imm,
    output  reg [31:0] j_imm
    );
        always@(*) begin
            case (imm_control)
                2'b00: i_imm = { {21{inst[31]}}, inst[30:20]};
                2'b01: b_imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], {1'b0}};                 //1'b0 hizalama için gereklidir
                2'b10: j_imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], {1'b0}};
                default: begin
                        i_imm = 32'b0;
                        b_imm = 32'b0;
                        j_imm = 32'b0;
                        end
            endcase
        end
endmodule