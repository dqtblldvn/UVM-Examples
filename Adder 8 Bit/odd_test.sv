`ifndef GUARD_ODD_TEST
`define GUARD_ODD_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;
//typedef uvm_sequencer #(sequence_item) sequencer;

class odd_test extends base_test;
	`uvm_component_utils(odd_test)

	task run_phase(uvm_phase phase);
		odd_sequence odd;
		odd = new("odd");

		phase.raise_objection(this);
		odd.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : odd_test

`endif


