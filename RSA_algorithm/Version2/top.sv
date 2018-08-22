module top;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RSA_pkg::*;


	RSA_bfm bfm();
	encrypter_decrypter #KEY_WIDTH ED(.clk(bfm.clk),.en(bfm.en),.data_in(bfm.data_in),
										.key_in(bfm.key_in),.modulus_in(bfm.modulus_in),
										.valid_in(bfm.valid_in),.data_out(bfm.data_out),
										.valid_out(bfm.valid_out));

	initial begin
		uvm_config_db #(virtual RSA_bfm)::set(null,"*","bfm",bfm);
		run_test("test");
	end // initial

endmodule // top
