module top;
	
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import AddSub_pkg::*;

	

	AddSub_bfm bfm();
	Add8Bit DUT(.A(bfm.A),.B(bfm.B),.result(bfm.result));

	initial begin
		uvm_config_db #(virtual AddSub_bfm)::set(null,"*","bfm",bfm);
		run_test("even_test");
	end

endmodule // top
