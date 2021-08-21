module DCM #(
	parameter level = 20
) (
	input	wire clk_in,
	input	wire clk_det,
	input	wire rstn, 
	input wire pos_neg,
	output wire [level-1:0] theta,
	input wire request,
	input wire finish,
	output reg ready
);
	wire n_clk,d_rstn,d_clk,clk_test;
	assign clk_test = pos_neg == 0 ? clk_det : ~clk_det;
	
	dff_os dff_os1(.rstn(rstn),.ck(clk_in) ,.Y(n_clk));
	delay_chain#(.counts(3)) rstn_delay(.A(rstn),.Y(d_rstn));
	delay_chain#(.counts(3)) clk_delay(.A(clk_in),.Y(d_clk));
	
	reg [1:0] state;
	always@(posedge n_clk or negedge d_rstn)begin
		if(d_rstn == 0)begin
			state <= 0;
		end
		else begin 
			if(state == 0)begin
				if(request == 1)begin
					state <= 1;
				end
				else begin
					state <= 0;
				end
			end
			else if(state == 1)begin
				if(ready == 1)begin
					state <= 2;
				end
				else begin
					state <= 1;
				end
			end
			else if(state == 2)begin
				if(finish == 1)begin
					state <= 0;
				end
				else begin
					state <= 2;
				end
			end
		end
	end
	
	
	// counter
	reg [2:0] counter;
	always@(posedge n_clk or negedge d_rstn)begin
		if(d_rstn == 0)begin
			counter <= 0;
		end
		else begin
			if(state == 0)begin
				counter <= 0;
			end
			else if(state == 1)begin
				counter <= counter + 1;
			end	
		end
	end
	
	always@(posedge n_clk or negedge d_rstn)begin
		if(d_rstn == 0)begin
			ready <= 0;
		end
		else begin 
			if(state == 1)begin
				if(counter >= 7)begin
					ready <= 1;
				end
			end
			else if(state == 0)begin
				ready <= 0;
			end
		end
	end
	
	reg shrinker_rst;
	always@(posedge n_clk or negedge d_rstn)begin
		if(d_rstn == 0)begin
			shrinker_rst <= 1;
		end
		else begin
			if( (state == 1) || (state == 2) )begin
				shrinker_rst <= 0;
			end
			else begin
				shrinker_rst <= 1;
			end
			
		end
	end
	
	wire [level - 1:0]thermo_out;
	hybrid_shrinker#(
		.level(level)
	)shrinker(
		.rst(shrinker_rst),
		.clk_in(clk_test),
		.thermo_out(thermo_out)
	);
	assign theta = thermo_out;
	
	
	
	
endmodule


module hybrid_shrinker#(
	parameter level = 20
)(
	input wire rst,
	input wire clk_in,
	output wire [level-1:0] thermo_out
);

	wire [level : 0] shrinker_node;
	wire [level-1 : 0] shrinker_node_masked;
	wire [level-1 : 0] shrinker_node_b;
	wire [level-1 : 0] subnode;
	wire [level-1 : 0] subnode_2;
	
	assign shrinker_node[0] = clk_in; 
	
	
	
	genvar i;
	generate
		for(i=0;i<level;i=i+1)begin:shrink_cell
			if(i % 4 == 0)begin : rst_post
				NOR2BX2 mux0(.AN(shrinker_node[i]) ,.B(rst),.Y(shrinker_node_masked[i]));
				CLKINVX1 buf1(.A(shrinker_node_masked[i]),.Y(shrinker_node_b[i]));
				CLKINVX1 buf2(.A(shrinker_node_b[i]),.Y(shrinker_node[i+1]));
			end
			else begin : normal
				CLKINVX1 buf1(.A(shrinker_node[i]),.Y(shrinker_node_b[i]));
				CLKINVX1 buf2(.A(shrinker_node_b[i]),.Y(subnode[i]));
				NAND2X2 nand1(.A(shrinker_node[i]),.B(subnode[i]),.Y(subnode_2[i]));
				CLKINVX2 inv1(.A(subnode_2[i]),.Y(shrinker_node[i+1]));
			
			end
			
			
			SR_latch sr1(.S(shrinker_node[i+1]),.R(rst),.Q(thermo_out[i]),.QN());
		end
	endgenerate

endmodule

