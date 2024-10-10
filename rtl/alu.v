module alu (
    input   wire        [31:0] a,    //reg koyarsam bi pipeline aşaması daha çıkar
    input   wire        [31:0] b,
    input   wire        [4:0] ALUctr,
    //output  wire        less,
    //output  wire        zero,
    output  reg         [31:0] result 
    );
    
    reg signed [31:0] signed_a;
    reg signed [31:0] signed_b;

    always @(*) begin
        signed_a = a;
        signed_b = b;
        
        //* signed/unsigned farketmeyenler

        case (ALUctr)
            5'b00000: result =  a + b;                                              //add *
            5'b00001: result =  a - b;                                              //sub *
            5'b00010: result =  a << b[4:0];                                        //sll * sola kaydır
            5'b00011: result = ($signed_a < $signed_b) ? 1 : 0;                       //slt signed karşılaştırma
            5'b00100: result = (a < b) ? 1 : 0;                                     //sltu unsigned karşılaştrıma
            5'b00101: result =  a ^ b;                                              //xor *
            5'b00110: result =  a >> b[4:0];                                        //srl sağa kaydır unsigned
            5'b00111: result =  signed_a >>> b[4:0];                                //sra signed sağa kaydır
            5'b01000: result =  a | b;                                              //or *
            5'b01001: result =  a & b;                                              //and *
            5'b01010: result =  a + {{20{b[11]}}, b[11:0]};                         //addı *
            5'b01011: result = ($signed(a) < $signed({{20{b[11]}}, b[11:0]})) ? 1 : 0; // slti signed
            5'b01100: result = (a < {{20{b[11]}}, b[11:0]}) ? 1 : 0;                //sltıu
            5'b01101: result =  a ^ {{20{b[11]}}, b[11:0]};                         //xorı *
            5'b01110: result =  a | {{20{b[11]}}, b[11:0]};                         //orı *
            5'b01111: result =  a & {{20{b[11]}}, b[11:0]};                         //andı *
            5'b10001: result =  a << b[4:0];                                        //slli *
            5'b10010: result =  a >> b[4:0];                                        //srli unsigned
            5'b10011: result =  $signed_a >>> b[4:0];                                //srai signed
            default: result = 32'b0;
        endcase
    end
    
         //   assign      zero = (result == 0);           
         //   assign      less = (result[31] == 1);       //sonuç negatif mi
    
    
endmodule
