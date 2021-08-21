module controller(
	input	wire	ref_clk,
	input	wire	rstn,
	output	reg	enable,
	input	wire	lead,
	output	reg	[9:0]	gamma,
	output	reg	locked_flag
);
wire clk;
assign clk = ref_clk;
reg pre_lead;
//(* dont_touch = “yes” *) wire pre_lead_0;
//reg pre_lead;
//assign pre_lead_0 = pre_lead;
reg [1:0]	state;
reg [1:0]	cnt;

always@(posedge clk or negedge rstn)begin
	if(rstn == 0)begin
		state <= 0;
		gamma <= 1;
		enable <= 0;
		pre_lead <= 0;
	end
	else begin
		if(state == 0)begin
			gamma <= gamma;
			enable <= 0;
			state <= 1;
			
		end
		else if(state == 1)begin
			gamma <= gamma;
			enable <= 1;
			state <= 2;
		end
		else if(state == 2)begin
			state <= 1; 
			enable <= 0;
			pre_lead <= lead;
			if(lead == 1 && !gamma[9])begin
				gamma <= (gamma << 1);
			end
			else if(lead == 0 && !gamma[0]) begin
				gamma <= (gamma >> 1);
			end
		end
		
	end
end

always@(posedge pre_lead or negedge rstn)begin
	if(rstn==0)begin
		cnt <= 0;
		locked_flag <= 0;
	end
	else begin
		if(~locked_flag)begin
		    cnt <= cnt + 1;
		    if(cnt==2'd3) begin
		    	locked_flag <= 1;
		    end
		end		  
	end
end






endmodule
