module freq_div(
	input 	wire 	clk,
	output 	wire	clk_out,
	input 	wire 	enable
);

reg	[4:0]	counter_in;
reg	[4:0]	counter;
wire enable_delay;
reg	clk_out_in;

DFFRX2  counter_0 ( .D(counter_in[0]), .CK(clk),.RN(enable), .Q(counter[0]), .QN() );
DFFRX2  counter_1 ( .D(counter_in[1]), .CK(clk),.RN(enable), .Q(counter[1]), .QN() );
DFFRX2  counter_2 ( .D(counter_in[2]), .CK(clk),.RN(enable), .Q(counter[2]), .QN() );
DFFRX2  counter_3 ( .D(counter_in[3]), .CK(clk),.RN(enable), .Q(counter[3]), .QN() );
DFFRX2  counter_4 ( .D(counter_in[4]), .CK(clk),.RN(enable), .Q(counter[4]), .QN() );

DFFRX2  clk_out_0 ( .D(!clk_out), .CK( (counter == 0) && enable_delay ),.RN(enable), .Q(clk_out), .QN() );


delay_chain #(
	.r_width(20)
) enable_delay_0(
	.delay_in(enable),
	.delay_out(enable_delay)
);

always@(*)begin
	if(counter == 25)begin
		counter_in = 0;
	end
	else begin
		counter_in = counter +1;
	end

end

endmodule
