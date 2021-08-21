module controller(
	input	wire	clk_in,
	input	wire	rstn,
	output	reg	[4:0]	gamma,
	output	reg	locked_flag,
	output wire pos_neg,
	input wire [20-1:0] theta,
	output reg request,
	output reg finish,
	input wire ready
);

reg [3:0] state2;
//reg [4:0] th2bi;
assign pos_neg = 0;
wire ready2;

wire [4:0]clk_temp;
assign clk_temp[0] = ready;
assign ready2 = clk_temp[4];
/* not work
integer i;
always@(*) begin
	th2bi =  0;
	for(i = 0; i <= 19; i=i+1) begin
		th2bi = th2bi + theta[i];
    end
end
*/
equal_buf chain(.A(ready),.Y(ready2));
genvar i;
generate
	for(i=1;i<5;i=i+1)begin: delay 
		equal_buf chain(.A(clk_temp[i-1]),.Y(clk_temp[i]));
	end
endgenerate

always @(posedge clk_in or negedge rstn) begin
	if(~rstn)begin
		gamma <= 5'b00011;
	end
	else if(state2 == 4)begin
		if((theta[19:9] == 0)&&(gamma < 31))begin
			gamma <= gamma + 1;
		end
		else if((theta[19:9] != 0)&&(gamma != 1)) begin
			gamma <= gamma - 1;
		end
		else begin
			gamma <= gamma;
		end
	end
	else begin
		gamma <= gamma;
	end
end

always@(posedge clk_in or negedge rstn)begin
	if(rstn == 0)begin
		state2 <= 0;
		request <= 0;
		finish <= 0;
	end
	else begin
		if((state2 == 0)||(state2 == 1)||(state2 == 2))begin
			state2 <= state2 + 1;
			request <= 1;
			finish <= 0;
		end
		else if(state2 == 3)begin
			request <= 0;
			finish <= 0;
			if(ready2)
				state2 <= 4;
			else
				state2 <= 3;
		end
		else  if(state2 == 4)begin
			state2 <= 5;
			request <= 0;
			finish <= 0;
		end
		else if((state2 == 5)||(state2 == 6))begin
			state2 <= state2 + 1;
			request <= 0;
			finish <= 1;
		end
		else if(state2 == 7)begin
			state2 <= 0;
			request <= 0;
			finish <= 0;
		end
		
	end
end


endmodule