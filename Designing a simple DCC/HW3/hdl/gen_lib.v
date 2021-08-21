
module SR_latch(
	input wire S,
	input wire R,
	output wire Q,
	output wire QN
);
	NOR2X2 a1(.A(S),.B(Q),.Y(QN));
	NOR2X2 a2(.A(R),.B(QN),.Y(Q));
endmodule

module dff_os ( rstn, ck, Y );
  input rstn, ck;
  output Y;
  wire   n2;

  DFFRX1 dff_1 ( .D(1'b1), .CK(ck), .RN(n2), .Q(Y), .QN() );
  NOR2BX1 U2 ( .AN(rstn), .B(Y), .Y(n2) );
endmodule

module dff_os_wt #(
	parameter width = 0
) ( 
  input wire rstn,
  input wire ck,
  output wire Y 
);
  wire   n1,n2;

  DFFRX1 dff_1 ( .D(1'b1), .CK(ck), .RN(n2), .Q(Y), .QN() );
  delay_chain #(.counts(width)) chain(.A(Y),.Y(n1));
  NOR2BX1 U2 ( .AN(rstn), .B(n1), .Y(n2) );
endmodule


module delay_chain#(
	parameter counts = 3
)(
	input  wire A,
	output wire Y
);
wire [counts:0] nodes;
wire [counts:0] nodes_b;

assign nodes[0] = A;
assign Y = nodes[counts];

genvar i;
generate
	for(i=0;i<counts;i=i+1)begin:d_block
		CLKINVX1 a1(.A(nodes[i]) ,.Y(nodes_b[i]));
		CLKINVX1 a2(.A(nodes_b[i]) ,.Y(nodes[i+1]));
	end
endgenerate


endmodule