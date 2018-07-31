`ifndef GUARD_COUNT_DOWN_SEQUENCE
`define GUARD_COUNT_DOWN_SEQUENCE

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_down_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(count_down_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
			begin
			cmd = count_down_sequence_item::type_id::create("cmd");
			start_item(cmd);
			assert(cmd.randomize());
			finish_item(cmd);
		end // repeat (10)
	endtask : body

endclass : count_down_sequence
`endif



