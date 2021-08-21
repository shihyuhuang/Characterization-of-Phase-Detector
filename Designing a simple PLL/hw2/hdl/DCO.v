module DCO #(
	parameter vertebra_num = 20
) 
(
	input wire [vertebra_num-1:0]gamma,
	input wire enable,
	output wire clk_out
);

wire [vertebra_num:0]v_n1;
wire [vertebra_num:0]v_n3;
wire [vertebra_num-1:0]v_g2;

assign v_n3[1] = clk_out;

NAND2X4 NAND0(.A(enable), .B(clk_out), .Y(v_n1[0]));
TBUFX1 BUF0(.A(v_n1[0]), .OE(1'b1), .Y(v_n1[1]));
TBUFXL TB0(.A(v_n1[1]), .OE(gamma[0]), .Y(v_n3[1]));


genvar i;
generate
	for(i=1;i<vertebra_num-1;i=i+1)begin:spine
		vertebra(
			.n1(v_n1[i]),
			.n2(v_n1[i+1]),
			.n4(v_n3[i+1]),
			.n3(v_n3[i]),
			.g1(gamma[i]),
			.g2(v_g2[i-1])
		);
	end
	for(i=0;i<vertebra_num-1;i=i+1)begin:inv_chain
		INVXL INV0(.A(gamma[i]), .Y(v_g2[i]));
	end
endgenerate

vertebra_last last(
	.n1(v_n1[vertebra_num-1]),
	.n3(v_n3[vertebra_num-1]),
	.g1(gamma[vertebra_num-1]),
	.g2(v_g2[vertebra_num-2])
);

endmodule


module vertebra(
	input  n1,
	output n2, 
	input  n4,
	output n3,
	input  g1,
	input  g2
);

TBUFX1 BUF0(.A(n1), .OE(1'b1), .Y(n2));
TBUFXL TB0(.A(n2), .OE(g1), .Y(n4));
TBUFXL TB1(.A(n4), .OE(g2), .Y(n3));


endmodule

module vertebra_last(
	input  n1,
	output n3,
	input  g1,
	input  g2
);

wire n2,n4;

TBUFX1 BUF0(.A(n1), .OE(1'b1), .Y(n2));
TBUFXL TB0(.A(n2), .OE(g1), .Y(n4));
TBUFXL TB1(.A(n4), .OE(g2), .Y(n3));


endmodule



