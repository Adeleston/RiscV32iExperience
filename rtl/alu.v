module alu (
    input   wire        [31:0] rsA,    //reg koyarsam bi pipeline a?amas? daha ??kar
    input   wire        [31:0] rsB,
    input   wire        [3:0] ALUctr,
    output  wire        less,
    output  wire        zero,
    output  reg         [32:0] result 
    );
    
    reg signed [31:0] signed_rsA;
    reg signed [31:0] signed_rsB;
    initial result=0;
    always @(*) begin
        signed_rsA = rsA;
        signed_rsB = rsB;
        
        //* signed/unsigned farketmeyenler

        case (ALUctr)
            4'b0000: result =  rsA + rsB;                                              //add *
            4'b0001: result =  rsA - rsB;                                              //sub *
            4'b0010: result =  rsA << rsB[4:0];                                        //sll * sola kayd?r
            4'b0011: result = (signed_rsA < signed_rsB) ? 1 : 0;                       //slt signed kar??la?t?rma
            4'b0100: result = (rsA < rsB) ? 1 : 0;                                     //sltu unsigned kar??la?tr?ma
            4'b0101: result =  rsA ^ rsB;                                              //xor *
            4'b0110: result =  rsA >> rsB[4:0];                                        //srl sa?a kayd?r unsigned
            4'b0111: result =  signed_rsA >>> rsB[4:0];                                //sra signed sa?a kayd?r
            4'b1000: result =  rsA | rsB;                                              //or *
            4'b1001: result =  rsA & rsB;                                              //and *
            4'b1010: result = rsB;                                                   //LUI
            default: result = 32'b0;
        endcase
    end
    
           assign      zero = (result == 0);           
           assign      less = (result[32] == 0);       //sonu? negatif mi
    
endmodule
