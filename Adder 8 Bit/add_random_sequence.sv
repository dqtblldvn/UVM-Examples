`ifndef GUARD_ADD_RANDOM_SEQUENCE
`define GUARD_ADD_RANDOM_SEQUENCE

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class add_random_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(add_random_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
		repeat (15) begin
			cmd = sequence_item::type_id::create("cmd");
			start_item(cmd);
			assert(cmd.randomize());
			finish_item(cmd);
		end // repeat (10)
	endtask : body

endclass : add_random_sequence
`endif
