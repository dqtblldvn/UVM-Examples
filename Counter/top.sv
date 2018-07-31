module top;
	
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import Counter_pkg::*;
	`include "assertion.sv"

	Counter_bfm bfm();
	Counter DUT(.clk(bfm.clk),.datain(bfm.datain),.rst(bfm.rst),.en(bfm.en),
		.load(bfm.load),.updn(bfm.updn),.dataout(bfm.dataout));
	bind DUT Counter_assertion CounterDUT_assertion(.clk(DUT.clk),.datain(DUT.datain),.rst(DUT.rst),.en(DUT.en),
		.load(DUT.load),.updn(DUT.updn),.dataout(DUT.dataout));

	initial begin
		uvm_config_db #(virtual Counter_bfm)::set(null,"*","bfm",bfm);
		run_test();
		//$monitor ("Test %h", bfm.dataout);
	end

endmodule // top
