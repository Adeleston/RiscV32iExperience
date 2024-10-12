module adder(
    input [31:0] mux_1out,
    input [31:0] mux_2out,
    output reg [31:0] NextPc
    );
    
    always@(*)begin
        NextPc = mux_1out + mux_2out;
        end 
        
endmodule