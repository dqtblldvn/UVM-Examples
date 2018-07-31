`ifndef GUARD_COUNT_DOWN_TEST
`define GUARD_COUNT_DOWN_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_down_test extends base_test;
	`uvm_component_utils(count_down_test)

	task run_phase(uvm_phase phase);
		count_down_sequence cd_seq;
		cd_seq = new("cd_seq");

		phase.raise_objection(this);
		cd_seq.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : count_down_test

`endif




