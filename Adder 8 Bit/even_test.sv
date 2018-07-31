`ifndef GUARD_EVEN_TEST
`define GUARD_EVEN_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;
//typedef uvm_sequencer #(sequence_item) sequencer;

class even_test extends base_test;
	`uvm_component_utils(even_test)

	task run_phase(uvm_phase phase);
		even_sequence even;
		even = new("even");

		phase.raise_objection(this);
		even.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : even_test

`endif

