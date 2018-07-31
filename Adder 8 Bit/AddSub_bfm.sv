interface AddSub_bfm;

	
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import AddSub_pkg::*;

	bit [7:0] A,B;
	wire [8:0] result;
	bit clk;

	command_monitor command_monitor_h;
	result_monitor result_monitor_h;

	task send_op(input bit [7:0] Aa, input bit [7:0] Bb, output bit [8:0] resultt);
		@(posedge clk);
		A=Aa;
		B=Bb;
		@(negedge clk);
		resultt=result;
	endtask : send_op


	initial begin
		clk = 0;
		fork 
			forever begin
				#10;
				clk = ~clk;
			end // forever
		join_none
	end

endinterface : AddSub_bfm
