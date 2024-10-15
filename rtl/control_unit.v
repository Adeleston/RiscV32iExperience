module control_unit(
    input [31:0] inst,
    input [31:0] imm_out,        
    output reg [2:0] ExtOp,
    output reg RegWr,
    output reg ALUASrc,
    output reg [1:0] ALUBSrc,
    output reg [4:0] ALUCtr,
    output reg Branch,
    output reg MemtoReg,
    output reg MemWr,
    output reg [2:0] MemOp       
);

    wire [6:0] opcode= inst[6:0];
    wire [2:0] func3= inst [14:12];
    wire [6:0] func7=inst[31:25];

    always @(*)
    begin
        ExtOp = 3'b000;
        RegWr = 1'b0;
        ALUASrc = 1'b0;
        ALUBSrc = 2'b00;
        ALUCtr = 5'b00000;
        Branch = 1'b0;
        MemtoReg = 1'b0;
        MemWr = 1'b0;
        MemOp = 3'b000;

        case(opcode)
            7'b0110011:begin//r-type
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b00;
                case(func7)
                    7'b0000000:begin
                        case(func3)
                        3'b000: ALUCtr = 5'b00000;//add
                        3'b001: ALUCtr = 5'b00001;//sll
                        3'b010: ALUCtr = 5'b00010;//slt
                        3'b011: ALUCtr = 5'b00011;//sltu
                        3'b100: ALUCtr = 5'b00100;//xor
                        3'b101: ALUCtr = 5'b00101;//srl
                        3'b110: ALUCtr = 5'b00110;//or
                        3'b111: ALUCtr = 5'b00111;//and
                        endcase
                    end

                    7'b0100000: begin
                        case (func3)
                        3'b000: ALUCtr = 5'b01000;//sub
                        3'b101: ALUCtr = 5'b01001;//sra
                        endcase
                    end
                endcase
            end

            7'b0010011: begin //ı-type
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                ExtOp = 3'b001;
                imm_out = {{20{inst[31]}}, inst[30:20]};
                case(func3)
                    3'b000: ALUCtr = 5'b00000;//addi
                    3'b010: ALUCtr = 5'b00010;//slti
                    3'b011: ALUCtr = 5'b00011;//sltiu
                    3'b100: ALUCtr = 5'b00100;//xori
                    3'b110: ALUCtr = 5'b00110;//ori
                    3'b111: ALUCtr = 5'b00111;//andi
                    3'b001: ALUCtr = 5'b00001;//slli
                    3'b101:begin
                        case(func7)
                            7'b0000000: ALUCtr = 5'b00101;//srli
                            7'b0100000: ALUCtr = 5'b01001;//sraı
                        endcase
                    end
                endcase
            end

            7'b0100011: begin//s-type
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                MemWr = 1'b1;
                MemOp = func3;
                ExtOp = 3'b001;
                imm_out = {{21{inst[31]}}, inst[30:25], inst[11:7]};
                    case (func3)
                        3'b000: MemOp = 3'b000;//sb
                        3'b001: MemOp = 3'b010;//sh
                        3'b010: MemOp = 3'b100;//sw
                    endcase
                ALUCtr = 5'b00000; //rs1+imm
            end

            7'b0000011:begin //l-type
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                MemtoReg = 1'b1;
                ExtOp = 3'b001;
                imm_out = {{20{inst[31]}}, inst[30:20]};
                    case(func3)
                    3'b000: MemOp = 3'b000;//lb
                    3'b001: MemOp = 3'b010;//lh
                    3'b010: MemOp = 3'b100;//lw
                    3'b100: MemOp = 3'b001;//lbu
                    3'b101: MemOp = 3'b011;//lhu
                    endcase
                ALUCtr = 5'b00000; //rs1+imm
            end

            7'b1100011: begin //b-type
                ALUASrc = 1'b0;
                ALUBSrc = 2'b00;
                Branch = 1'b1;
                ExtOp = 3'b010;
                imm_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
                case(func3)
                    3'b000: ALUCtr = 5'b01010;//beq
                    3'b001: ALUCtr = 5'b01011;//bne
                    3'b100: ALUCtr = 5'b01100;//blt
                    3'b101: ALUCtr = 5'b01101;//bge
                    3'b110: ALUCtr = 5'b01110;//bltu
                    3'b111: ALUCtr = 5'b01111;//bgeu
                endcase
            end

            7'b1100111: begin //jalr
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                ExtOp = 3'b001;
                imm_out = {{20{inst[31]}}, inst[30:20]};
                ALUCtr = 5'b00000;
            end

            7'b1101111:begin //jal
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b10;
                ExtOp = 3'b011;
                imm_out = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
                ALUCtr = 5'b00000; // pc + imm
            end

            7'b0010111: begin //auıpc
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b10;
                ExtOp = 3'b100;
                imm_out = {inst[31:12], 12'b0};
                ALUCtr = 5'b00000;
            end

            7'b0110111: begin //luı
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                ExtOp = 3'b100;
                imm_out = {inst[31:12], 12'b0};
                ALUCtr = 5'b10000;
            end
        endcase
    end
endmodule