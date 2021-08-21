// asd

`timescale 1ps/100fs

`define end_cycle 100000

module test_pd;

// ======== IO =======
reg clk_ref;
reg clk_targ;

wire out;

// ========= DUMP ===========
initial begin
	$fsdbDumpfile("sa.fsdb");
	$fsdbDumpvars("+mda");
	$fsdbDumpvars;
end

// ======== Top Connection ==========

sa u1(.out(out),.clk_ref(clk_ref),.clk_targ(clk_targ));

// ======== CLK generation ==========

initial begin
	clk_ref = 1'b0;
	#(500);
	while(1)begin
		clk_ref = ~clk_ref;
		#(500.5);
	end

end

initial begin
	clk_targ = 1'b0;
	#(510);
	while(1)begin
		clk_targ = ~clk_targ;
		#(500);
	end

end

// ========== Do some stuff here ===========




// ========== Dead End =========
initial begin
	#(`end_cycle);
	$display("===============================");
	$display("It all ended here, the dead end");
	$display("===============================");
	$finish;

end



endmodule
