`ifndef GUARD_FIBONACCI_TEST
`define GUARD_FIBONACCI_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;
//typedef uvm_sequencer #(sequence_item) sequencer;

class fibonacci_test extends base_test;
	`uvm_component_utils(fibonacci_test)

	task run_phase(uvm_phase phase);
		fibonacci_sequence fibonacci;
		fibonacci = new("fibonacci");

		phase.raise_objection(this);
		fibonacci.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : fibonacci_test

`endif
