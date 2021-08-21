module flip_flop(
	output reg out,
	input clk_ref,
	input clk_targ
);

reg out_next;


always @ (posedge clk_ref) begin
	out <= out_next;
end

always@(posedge clk_targ)begin
	out_next <= 1;
	//if(clk_ref)
	//	out_next <= 1;
	#46;
	if(clk_ref)
		out_next <= 1;
	else 
		out_next <= 0; 
	#1;
	if(clk_ref)
		out_next <= 1;
end


endmodule
