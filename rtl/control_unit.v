    input [31:0] inst,        
    output reg [2:0] ExtOp,
    output reg RegWr,
    output reg ALUASrc,
    output reg [1:0] ALUBSrc,
    output reg [3:0] ALUCtr,
    output reg [2:0] Branch,
    output reg MemtoReg,
    output reg MemWr,
    output reg [2:0] MemOp,   
    output reg JumpS    
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
        JumpS = 1'b0;
        case(opcode)
            7'b0110011:
            begin//r-type
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b10;
                case(func7)
                    7'b0000000:
                    begin
                        case(func3)
                        3'b000: ALUCtr = 4'b0000;//add
                        3'b001: ALUCtr = 4'b0010;//sll
                        3'b010: ALUCtr = 4'b0011;//slt
                        3'b011: ALUCtr = 4'b0100;//sltu
                        3'b100: ALUCtr = 4'b0101;//xor
                        3'b101: ALUCtr = 4'b0110;//srl
                        3'b110: ALUCtr = 4'b1000;//or
                        3'b111: ALUCtr = 4'b1001;//and
                        endcase
                    end
                    7'b0100000:
                    begin
                        case (func3)
                        3'b000: ALUCtr = 4'b0001;//sub
                        3'b101: ALUCtr = 4'b0111;//sra
                        endcase
                    end
                endcase
            end

            7'b0010011: 
            begin //I-type
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                ExtOp = 3'b000;
                case(func3)
                    3'b000: ALUCtr = 4'b0000;//addi
                    3'b010: ALUCtr = 4'b0011;//slti
                    3'b011: ALUCtr = 4'b0100;//sltiu
                    3'b100: ALUCtr = 4'b0101;//xori
                    3'b110: ALUCtr = 4'b1000;//ori
                    3'b111: ALUCtr = 4'b1001;//andi
                    3'b001: ALUCtr = 4'b0010;//slli
                    3'b101:
                    begin
                        case(func7)
                            7'b0000000: ALUCtr = 4'b0110;//srli
                            7'b0100000: ALUCtr = 4'b0111;//sra?
                        endcase
                    end
                endcase
            end

            7'b0100011: 
            begin//s-type
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                MemWr = 1'b1;
                MemOp = func3;
                ExtOp = 3'b001;
                    case (func3)
                        3'b000: MemOp = 3'b000;//sb
                        3'b001: MemOp = 3'b010;//sh
                        3'b010: MemOp = 3'b100;//sw
                    endcase
                ALUCtr = 4'b0000; //rs1+imm
            end

            7'b0000011:
            begin //l-type
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                MemtoReg = 1'b1;
                ExtOp = 3'b000;
                    case(func3)
                    3'b000: MemOp = 3'b000;//lb
                    3'b001: MemOp = 3'b010;//lh
                    3'b010: MemOp = 3'b100;//lw
                    3'b100: MemOp = 3'b001;//lbu
                    3'b101: MemOp = 3'b011;//lhu
                    endcase
                ALUCtr = 4'b0000; //rs1+imm
            end

            7'b1100011: 
            begin //b-type
                ALUASrc = 1'b0;
                ALUBSrc = 2'b10;
                ALUCtr = 4'b0001;
                ExtOp = 3'b010;
                case(func3)
                    3'b000: Branch = 3'b001;//beq
                    3'b001: Branch = 3'b010;//bne
                    3'b100: Branch = 3'b011;//blt
                    3'b101: Branch = 3'b100;//bge
                    3'b110: Branch = 3'b101;//bltu
                    3'b111: Branch = 3'b110;//bgeu
                endcase
            end

            7'b1100111: 
            begin //jalr
                Branch=3'b111;
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                ExtOp = 3'b000;
                JumpS = 1'b0;
                ALUCtr = 4'b0000;
            end

            7'b1101111:
            begin //jal
                Branch = 3'b111;
                RegWr = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 2'b00;
                ExtOp = 3'b011;
                JumpS = 1'b1;
                ALUCtr = 4'b0000; // pc + imm
            end

            7'b0010111: 
            begin //auipc
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                ExtOp = 3'b100;
                ALUCtr = 4'b0000;
            end

            7'b0110111: 
            begin //lui
                RegWr = 1'b1;
                ALUASrc = 1'b0;
                ALUBSrc = 2'b01;
                ExtOp = 3'b100;
                ALUCtr = 4'b0000;
            end
        endcase
    end
