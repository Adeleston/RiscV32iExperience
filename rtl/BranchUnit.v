module Branch_Module(
input Branch,
input Less,
input Zero,
input Jump,	
output reg PCASRC,
output reg PCBSRC
);
always @(*) begin
	PCASRC = 0;
	PCBSRC = 1;
	if(Branch) begin
		if(Less) begin
			PCASRC = 1;
			PCBSRC = 0;
		end	
		else if(Zero) begin
			PCASRC = 1;
			PCBSRC = 0;
		end
	end
	else if(Jump) begin
		PCASRC = 1;
		PCBSRC = 0;
	end
end
endmodule
		
