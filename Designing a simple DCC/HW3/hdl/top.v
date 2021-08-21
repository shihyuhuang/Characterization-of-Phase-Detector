module top # (
	parameter delay_bits = 5
	parameter delay_nodes = 4
	parameter level = 20
) (
	input 	wire	clk_in,
	output 	reg		clk_dcc,
	input	wire	rst_n,	
	// Psuedo inputs, should be killed once all finished
	output	wire	locked_flag
);

wire [delay_bits-1:0]gamma;
wire clk_delayed;
wire clk_os;
wire pos_neg;
wire [level-1:0] theta;
wire request;
wire finish;
wire ready;
wire [4:0] th2bi;



TDL #(
	.delay_bits(delay_bits)
) TDL_0 (
	.gamma(gamma),
	.clk_in(clk_in),
	.clk_out(clk_delayed)
);


OS #(
	.delay_nodes(delay_nodes)
) OS_0 (
	.clk_in(clk_delayed),
	.clk_os(clk_os)
);


always @(posedge clk_in or negedge clk_os or negedge rst_n) begin
	if(~rst_n)
		clk_dcc <= 0;
	else if(~clk_os)
		clk_dcc <= 0;
	else
		clk_dcc <= 1;
end

DCM #(
	.level(level)
) DCM_0(
	.clk_in(clk_dcc),
	.rstn(rst_n), 
	.pos_neg(pos_neg),
	.theta(theta),
	.request(request),
	.finish(finish),
	.ready(ready)
);


controller ct_0(
	.clk_in(clk_in),
	.rstn(rst_n),
	.gamma(gamma),
	.locked_flag(locked_flag),
	.pos_neg(pos_neg),
	.theta(theta),
	.request(request),
	.finish(finish),
	.ready(ready)
);


endmodule
