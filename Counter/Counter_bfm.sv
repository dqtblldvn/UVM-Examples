interface Counter_bfm;

	
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import Counter_pkg::*;

	bit [15:0] datain;
	bit en,rst,updn,load;
	wire [15:0] dataout;
	bit clk;
	reg [15:0] dataoutpre = 16'b0;

	command_monitor command_monitor_h;
	result_monitor result_monitor_h;

	task reset;
		rst = 1;
		@(posedge clk);
		@(posedge clk);
		rst = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		rst = 1;
		@(posedge clk);
		@(posedge clk);
	endtask : reset


	task send_op(input bit [15:0] datainn, input bit enn, input bit updnn);
		@(posedge clk);
		load = 1 ;
		datain = datainn;
		en = enn;
		updn = updnn;
		@(posedge clk);
		load = 0;
		repeat (30) begin @(posedge clk); end
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

endinterface : Counter_bfm

