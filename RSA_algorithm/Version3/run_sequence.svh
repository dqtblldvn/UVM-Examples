`ifndef GUARD_RUN_SEQUENCE
`define GUARD_RUN_SEQUENCE

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class run_sequence extends uvm_sequence #(data_transaction);
	`uvm_object_utils(run_sequence)

	data_transaction data;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
		int i;
		bit [KEY_WIDTH-1:0] mask = 0;
		data = data_transaction::type_id::create("data");
		data.keygen();
		for (i=1; i<=KEY_WIDTH/32; i++)
		begin
		start_item(data);
		mask = (mask*33'd4294967296) + {32{1'b1}};
		assert(data.randomize());
		data.m = (data.m) & mask;
		data.id = i;
		`uvm_info("Plaintext randomization",$sformatf("\nRange of plaintext length: [%0d,%0d] bits\nPlaintext is:\nIn decimal:\nm = %0d\nIn binary:\nm = %0b\n",(i-1)*32,i*32,data.m,data.m),UVM_HIGH)
		finish_item(data);
		end
	endtask : body

endclass : run_sequence

`endif