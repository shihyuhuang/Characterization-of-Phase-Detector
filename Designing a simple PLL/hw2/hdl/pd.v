module pd
(
	input wire enable,
	input wire clk_in,
	input wire FB,
	output wire LEAD
);

wire up, down, S, R, dummy, reset, reset_en, reset_dummy;

//input stage
DFFRX2 FB_diff(
	.Q(up),
	.QN(),
	.D(1'b1),
	.CK(FB),
	.RN(reset)
);

DFFRX2 clk_in_dff(
	.Q(down),
	.QN(),
	.D(1'b1),
	.CK(clk_in),
	.RN(reset)
	
);
/*
DFFSRX2 FB_dff ( .D(1'b1), .E(reset), .CK(FB), .Q(up) );
DFFSRX2 clk_in_dff ( .D(1'b1), .E(reset), .CK(clk_in), .Q(down) );
*/
//reset circuit
NAND2X4 NAND0(.A(up), .B(down), .Y(reset_en));
NAND2X4 NAND1(.A(up), .B(down), .Y(reset_dummy));
AND2X4 U22(.A(reset_en), .B(enable), .Y(reset) );

//racing circuit
NAND2X4 NANDA0(.A(up), .B(R), .Y(S));
NAND2X4 NANDB0(.A(down), .B(S), .Y(R));

//sr latch
NAND2X4 NANDA1(.A(S), .B(dummy), .Y(LEAD));
NAND2X4 NANDB1(.A(R), .B(LEAD), .Y(dummy));

endmodule
