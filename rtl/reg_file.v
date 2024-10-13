module reg_file(
    input [31:0] inst,
    input [31:0] busW,
    input RegWr,
    input Wr_Clk,
    output [31:0] rs1,
    output [31:0] rs2
    );

    reg [4:0] Ra;
    reg [4:0] Rb;
    reg [4:0] Rw;
    reg [31:0] register [31:0];
    
    always@(*) begin
        Ra = inst[19:15]; 
        Rb = inst[24:20]; 
        Rw = inst[11:7];  
    end
    
    assign rs1 = register[Ra];
    assign rs2 = register[Rb];
    
    always @(negedge Wr_Clk) begin
        if (RegWr && (Rw != 0))
            register[Rw] <= busW;
        end
    
endmodule
