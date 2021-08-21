module TDL #(
	parameter delay_bits = 5
)
(
	input wire [delay_bits-1:0]gamma,
	input wire clk_in,
	output reg clk_out
);
localparam delay_nodes = 2 ** delay_bits;

wire [delay_nodes-1 : 0]clk_temp;
// assign clk_out = clk_temp[gamma];
assign clk_temp[0] = clk_in;

genvar i;
generate
	for(i=1;i<delay_nodes;i=i+1)begin: delay 
		delay_chain#(.counts(1)) chain(.A(clk_temp[i-1]),.Y(clk_temp[i]));
	end
endgenerate


integer j;
always@(*) begin
	clk_out <=  0;
	for(j = 0; j < delay_nodes; j=j+1) begin
		if (gamma == j)
			clk_out <= clk_temp[j];
   end
end


endmodule




