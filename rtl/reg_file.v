module reg_file(
    input [31:0] inst,
    input [31:0] busW,
    input RegWr,
    input Wr_Clk,
    output [31:0] rs1,
    output [31:0] rs2
    );

    wire [4:0] Ra = inst[19:15];
    wire [4:0] Rb = inst[24:20];
    wire [4:0] Rw = inst[11:7];

    reg [31:0] register [31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            register[i] = 32'b0;
        end
    end
    
    assign rs1 = register[Ra];
    assign rs2 = register[Rb];
    
    always @(negedge Wr_Clk) begin
        if (RegWr && (Rw != 0))
            register[Rw] <= busW;
    end

endmodule
