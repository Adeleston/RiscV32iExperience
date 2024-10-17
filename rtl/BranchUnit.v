input JumpS,
input [2:0]Branch,
input Less,
input Zero,
output reg PCASRC,
output reg PCBSRC
);
always @(*) begin
	PCASRC = 1;
	PCBSRC = 0;
	case (Branch)
	   3'b001:if (Zero) PCASRC=0;
	   3'b010:if (~Zero) PCASRC=0;
	   3'b011:if (Less) PCASRC=0;
	   3'b100:if (~Less) PCASRC=0;
	   3'b101:if (Less) PCASRC=0;
	   3'b110:if (~Less) PCASRC=0;
	   3'b111:if (JumpS) PCASRC=0;
	           else 
	           begin
	               PCASRC=0;
	               PCBSRC=1;
	           end
	endcase
end
