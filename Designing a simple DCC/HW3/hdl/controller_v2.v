module controller(
	// general 
	input	wire	clk_in,
	input	wire	rstn,
	output	reg	locked_flag,
	// TDL interface
	output	reg	[4:0]	gamma,
	// DCM interface
	output	reg		pos_neg,
	input	wire	[20-1:0] theta,
	output	reg		request,
	output	reg		finish,
	input	wire	ready
);

reg [2:0] state;
reg [3:0] counter;
reg [19:0] pos_theta;
reg [1:0] gamma_decision ;

always@(posedge clk_in or negedge rstn)begin
	if(rstn == 0)begin
		state <= 0;
		counter <= 0;
		gamma <= 0;
		request <= 0;
		finish <= 0;
		pos_neg <= 0;
		locked_flag <= 0;
	end
	else begin
		if(state == 0)begin
			if(counter == 10)begin
				state <= 1;
				counter <= 0;
				request <= 1;
				pos_neg <= 0;
			end
			else begin
				counter <= counter + 1;
			end
		end
		else if(state == 1)begin
			if(counter == 3)begin
				state <= 2;
				counter <= 0;
				request <= 0;
			end
			else begin
				counter <= counter + 1;
			end
		end
		else if(state == 2)begin
			if(ready == 1)begin
				state <= 3;
			end
		end
		else if(state == 3)begin
			if(counter == 1)begin
				pos_theta <= theta;
				counter <= counter + 1;
			end
			else if(counter == 3)begin
				counter <= counter + 1;
				finish <= 1;
			end
			else if(counter == 7)begin
				state <= 4;
				counter <= 0;
				finish <= 0;
			end
			else begin
				counter <= counter + 1;
			end
		end
		else if(state == 4)begin
			if(counter == 5)begin
				state <= 5;
				counter <= 0;
				request <= 0;
			end
			else begin
				counter <= counter + 1;
				request <= 1;
				pos_neg <= 1;
			end
			
		end
		else if(state == 5)begin
			if(ready == 1)begin
				state <= 6;
			end
		end
		else if(state == 6)begin
			if(theta == pos_theta)begin
				gamma_decision <= 2;
			end
			else begin
				gamma_decision <= |(theta && (~pos_theta));
			end
			state <= 7;
		end
		else begin
			if(counter == 3)begin
				counter <= counter + 1;
				finish <= 1;
			end
			else if(counter == 7)begin
				state <= 0;
				counter <= 0;
				finish <= 0;
				if(gamma_decision == 1'b1)begin
					if(gamma < 31)begin
						gamma <= gamma + 1;
						locked_flag <= 0;
					end
				end
				else if(gamma_decision == 1'b0)begin
					if(gamma > 0)begin
						gamma <= gamma - 1;
						locked_flag <= 0;
					end
				end
				else begin
					locked_flag <= 1;
				end
			end
			else begin
				counter <= counter + 1;
			end
		
		end
	end
end



endmodule