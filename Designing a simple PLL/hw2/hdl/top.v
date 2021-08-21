module DLL #(
	parameter vertebra_num = 10
)(
	input 	wire	ref_clk,
	output 	wire	out_clk,
	input	wire	rst_n,	
	// Psuedo inputs, should be killed once all finished
	// input 	wire 	[vertebra_num-1:0] gamma,
	// input	wire	enable,
	// output	wire	lead,
	output	wire	locked_flag
);


wire	clk_fb;
wire	clk_ref_cms;
wire	clk_ref_cms_b;
wire	clk_ref_cms_bd;
wire	n0,n1;
wire	enable_cms;
wire	enable;
wire	[vertebra_num-1:0] gamma;
wire 	lead;



DFFSRX2  clk_cms_0 ( .D(1'b1), .CK(ref_clk),.SN(rst_n) ,.RN(clk_ref_cms_bd), .Q(clk_ref_cms), .QN(clk_ref_cms_b) );

delay_chain #(
	.r_width(10)
) dc_0(
	.delay_in(clk_ref_cms_b),
	.delay_out(clk_ref_cms_bd)
);


DFFRX2  clk_cms_4 ( .D(enable), .CK(ref_clk),.RN(rst_n),.Q(enable_cms), .QN() );

DCO # (
	.vertebra_num(vertebra_num)
) DCO_0 (
	.gamma(gamma),
	.enable(enable),
	.clk_out(out_clk)
);

wire out_clk_delay;
delay_chain #(
	.r_width(10)
) div_delay(
	.delay_in(out_clk),
	.delay_out(out_clk_delay)
);

freq_div div_0(
	.clk(out_clk_delay),
	.clk_out(clk_fb),
	.enable(enable)
);
wire clk_ref_cms_delay;
delay_chain #(
	.r_width(5)
) pd_delay(
	.delay_in(clk_ref_cms),
	.delay_out(clk_ref_cms_delay)
);

pd pd_0(
	.enable(rst_n),
	.clk_in(clk_ref_cms_delay),
	.FB(clk_fb),
	.LEAD(lead)
);

controller ct_0(
	.ref_clk(ref_clk),
	.rstn(rst_n),
	.enable(enable),
	.lead(lead),
	.gamma(gamma),
	.locked_flag(locked_flag)

);


endmodule
