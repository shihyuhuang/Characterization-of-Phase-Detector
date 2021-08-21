module top # (
	parameter delay_bits = 5
	parameter delay_nodes = 4
	parameter level = 20
) (
	input 	wire	clk_in,
	output 	wire	clk_dcc,
	input	wire	rst_n,	
	// Psuedo inputs, should be killed once all finished
	output	wire	locked_flag
);

wire [delay_bits-1:0]gamma;

wire pos_neg;
wire [level-1:0] theta;
wire request;
wire finish;
wire ready;
wire [4:0] th2bi;

wire clk_supply,rstn_delayed;
dff_os_wt#(
	.width(7)
) clock_supply(
	.rstn(rst_n),
	.ck(clk_in),
	.Y(clk_supply)
);
delay_chain#(.counts(3)) rstn_delay(.A(rst_n),.Y(rstn_delayed));

wire clk_in_os;
wire clk_in_os_delayed;
wire clk_os;

dff_os dummy_os(.rstn(rst_n),.ck(clk_in),.Y(clk_os));

dff_os TDL_os(.rstn(rst_n),.ck(clk_in),.Y(clk_in_os));

TDL #(
	.delay_bits(delay_bits)
) TDL_0 (
	.gamma(gamma),
	.clk_in(clk_in_os),
	.clk_out(clk_in_os_delayed)
);




SR_latch sr(
	.S(clk_os),
	.R(clk_in_os_delayed),
	.Q(clk_dcc),
	.QN()
);


DCM #(
	.level(level)
) DCM_0(
	.clk_in(clk_supply),
	.clk_det(clk_dcc),
	.rstn(rstn_delayed), 
	.pos_neg(pos_neg),
	.theta(theta),
	.request(request),
	.finish(finish),
	.ready(ready)
);


controller ct_0(
	.clk_in(clk_supply),
	.rstn(rstn_delayed),
	.gamma(gamma),
	.locked_flag(locked_flag),
	.pos_neg(pos_neg),
	.theta(theta),
	.request(request),
	.finish(finish),
	.ready(ready)
);


endmodule
