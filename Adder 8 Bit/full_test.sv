`ifndef GUARD_FULL_TEST
`define GUARD_FULL_TEST

`include "uvm_macros.svh"
import AddSub_pkg::*;
import uvm_pkg::*;
//typedef uvm_sequencer #(sequence_item) sequencer;

class full_test extends base_test;
	`uvm_component_utils(full_test)

	runall_sequence runall;

	task run_phase(uvm_phase phase);
		runall = new("runall");

		phase.raise_objection(this);
		runall.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : full_test

`endif


