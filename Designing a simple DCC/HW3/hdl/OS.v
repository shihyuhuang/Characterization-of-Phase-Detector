module OS #(
	parameter delay_nodes = 4
)
(
	input wire clk_in,
	output wire clk_os
);


wire clk_in_delay;
//wire clk_os_b;
wire clk_os_i;

wire [delay_nodes : 0]clk_temp;
assign clk_temp[0] = clk_in;
assign clk_in_delay = clk_temp[delay_nodes];

XOR2X2 u1(.A(clk_in), .B(clk_in_delay), .Y(clk_os_i));
NAND2X2 u3(.A(clk_in), .B(clk_os_i), .Y(clk_os));
//INVX2 u2(.A(clk_os_b), .Y(clk_os));

genvar j;
generate
	for(j=0;j<delay_nodes;j=j+1)begin: delay
		equal_buf chain(.A(clk_temp[j]),.Y(clk_temp[j+1]));
	end
endgenerate



endmodule