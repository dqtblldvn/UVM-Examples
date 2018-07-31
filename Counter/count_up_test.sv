`ifndef GUARD_COUNT_UP_TEST
`define GUARD_COUNT_UP_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_up_test extends base_test;
	`uvm_component_utils(count_up_test)

	task run_phase(uvm_phase phase);
		count_up_sequence cu_seq;
		cu_seq = new("cu_seq");

		phase.raise_objection(this);
		cu_seq.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : count_up_test

`endif



