module alu (
    input   wire        [31:0] rs1,    //reg koyarsam bi pipeline aşaması daha çıkar
    input   wire        [31:0] rs2,
    input   wire        [4:0] ALUctr,
    output  wire        less,
    output  wire        zero,
    output  reg         [31:0] result 
    );
    
    reg signed [31:0] signed_rs1;
    reg signed [31:0] signed_rs2;

    always @(*) begin
        signed_rs1 = rs1;
        signed_rs2 = rs2;
        
        //* signed/unsigned farketmeyenler

        case (ALUctr)
            5'b00000: result =  rs1 + rs2;                                              //add *
            5'b00001: result =  rs1 - rs2;                                              //sub *
            5'b00010: result =  rs1 << rs2[4:0];                                        //sll * sola kaydır
            5'b00011: result = ($signed_rs1 < $signed_rs2) ? 1 : 0;                       //slt signed karşılaştırma
            5'b00100: result = (rs1 < rs2) ? 1 : 0;                                     //sltu unsigned karşılaştrıma
            5'b00101: result =  rs1 ^ rs2;                                              //xor *
            5'b00110: result =  rs1 >> rs2[4:0];                                        //srl sağa kaydır unsigned
            5'b00111: result =  signed_rs1 >>> rs2[4:0];                                //sra signed sağa kaydır
            5'b01000: result =  rs1 | rs2;                                              //or *
            5'b01001: result =  rs1 & rs2;                                              //and *
            5'b01010: result =  rs1 + {{20{rs2[11]}}, rs2[11:0]};                         //addı *
            5'b01011: result = ($signed(rs1) < $signed({{20{rs2[11]}}, rs2[11:0]})) ? 1 : 0; // slti signed
            5'b01100: result = (rs1 < {{20{rs2[11]}}, rs2[11:0]}) ? 1 : 0;                //sltıu
            5'b01101: result =  rs1 ^ {{20{rs2[11]}}, rs2[11:0]};                         //xorı *
            5'b01110: result =  rs1 | {{20{rs2[11]}}, rs2[11:0]};                         //orı *
            5'b01111: result =  rs1 & {{20{rs2[11]}}, rs2[11:0]};                         //andı *
            5'b10001: result =  rs1 << rs2[4:0];                                        //slli *
            5'b10010: result =  rs1 >> rs2[4:0];                                        //srli unsigned
            5'b10011: result =  $signed_rs1 >>> rs2[4:0];                                //srai signed
            default: result = 32'b0;
        endcase
    end
    
           assign      zero = (result == 0);           
           assign      less = (result[31] == 1);       //sonuç negatif mi
    
endmodule
