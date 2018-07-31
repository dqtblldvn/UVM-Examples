`ifndef GUARD_LOAD_SEQUENCE
`define GUARD_LOAD_SEQUENCE

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class load_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(load_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
		begin
			cmd = sequence_item::type_id::create("cmd");
			start_item(cmd);
			assert(cmd.randomize());
			finish_item(cmd);
		end // repeat (10)
	endtask : body

endclass : load_sequence
`endif


