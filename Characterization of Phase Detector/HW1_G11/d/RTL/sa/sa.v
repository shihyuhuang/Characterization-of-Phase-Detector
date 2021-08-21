module sa(
	output out,
	input clk_ref,
	input clk_targ
);


reg up,down;
reg up_next,down_next;

assign out = down;

always @ (posedge clk_ref or negedge clk_ref) begin
	if(~clk_ref)begin
		up <= 1;
		down <= 1;
	end
	else begin
		up <= up_next;
		down <= down_next;
	end
end

always @ (posedge clk_targ) begin
	up_next <= 1;
	down_next <= 1;

	if(clk_ref)begin
		up_next <= 0;
		down_next <= 1;
	end
	else begin
		up_next <= 1;
		down_next <= 0;
	end
end

endmodule
