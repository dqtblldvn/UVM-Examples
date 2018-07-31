`ifndef GUARD_COUNT_UP_SEQUENCE
`define GUARD_COUNT_UP_SEQUENCE

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_up_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(count_up_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
			begin
			cmd = count_up_sequence_item::type_id::create("cmd");
			start_item(cmd);
			assert(cmd.randomize());
			finish_item(cmd);
		end // repeat (10)
	endtask : body

endclass : count_up_sequence
`endif


