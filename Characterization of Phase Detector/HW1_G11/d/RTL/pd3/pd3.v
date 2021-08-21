module flip_flop(
	output reg out,
	input clk_ref,
	input clk_targ
);


reg up,down;
reg S,R;
reg out1,out2;
wire enable,enable2;
reg out_next;
assign enable = 1;
assign enable2 = ~(up&down);


always @ (posedge clk_ref or posedge clk_targ) begin
	out <= out_next;	
end
/*
always @ (posedge clk_targ or negedge clk_targ) begin
	up <= 0;
	if(enable&enable2)
		up <= 1;
	else
		up <= 0;
		
end

always @ (posedge clk_ref or negedge clk_targ) begin
	down <=0;
	if(enable&enable2)
		down <= 1;
	else
		down <= 0;
		
end
*/

always @ (posedge clk_targ or negedge(enable&enable2)) begin
	up <= 0;
	if(~(enable&enable2))
		up <= 0;
	else
		up <= 1;
end

always @ (posedge clk_ref or negedge(enable&enable2)) begin
	down <= 0;
	if(~(enable&enable2))
		down <= 0;
	else
		down <= 1;
end

always@*begin
	S=1;
	R=1;
	if(~(up|down))begin
		S = 1;
		R = 1;
	end
	else begin
		#6;
		S = ~(R&up);
		R = ~(S&down); 
	end
end

always@*begin
	out1=1'bx;
	out2=1'bx;
	if(S&R)begin
		out1 = 1'bx;
		out2 = 1'bx;
	end
	else if(S==1)begin
		out1 = out2&(~S);
		out2 = ~(out1&R); 
	end
	else begin
		out1 = ~(out2&S);
		out2 = ~(out1&R); 
	end
end

always@*begin
	out_next = out;
	if(out1 == 0)
		out_next = (~out1);
	else if(out1 == 1)
		out_next = (~out1);
	
end
endmodule
