module delay_chain #(
	parameter r_width = 10

)(
	input delay_in,
	output delay_out

);

wire	[r_width - 1 : 0]delay_r;
wire	[r_width - 1 : 0]delay_r_b;

genvar i;
assign delay_r[0] = delay_in ;
generate
	for(i=0;i<r_width-1;i=i+1)begin:delay
		INVX2 delay_element_b	( .A(delay_r[i]),.Y(delay_r_b[i]) );
		INVX2 delay_element 	( .A(delay_r_b[i]), .Y(delay_r[i+1]) );		
	end
endgenerate

assign delay_out = delay_r[r_width-1];

endmodule
