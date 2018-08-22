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
		data = data_transaction::type_id::create("data");
		start_item(data);
		assert(data.randomize());
		data.keygen();
		`uvm_info("Plaintext randomization",$sformatf("\nPlaintext is:\nIn decimal:\nm = %0d\nIn binary:\nm = %0b\n",data.m,data.m),UVM_MEDIUM)
		finish_item(data);
	endtask : body

endclass : run_sequence

`endif