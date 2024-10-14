module imm_gen (
    input [31:0] inst,  
    input [2:0] ExtOp,        
    output reg [31:0] imm_out,    // Çıkış olarak tek bir immediate değeri kullan
    output reg [4:0] shamt
    );

    always @(*) begin
        case (ExtOp)
            3'b000: imm_out = {{21{inst[31]}}, inst[30:20]}; //ı-type
            3'b001: imm_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; //b-type
            3'b010: imm_out = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};//j-type
            3'b011: imm_out = {{21{inst[31]}}, inst[30:25], inst[11:7]}; //s-type
            3'b100: imm_out = {inst[31:12], 12'b0}; //luı aupcı
            3'b101: shamt = inst[24:20]; //shamt
        endcase
    end

endmodule
