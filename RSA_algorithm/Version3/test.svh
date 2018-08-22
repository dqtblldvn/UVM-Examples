`ifndef GUARD_TEST
`define GUARD_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class test extends base_test;
	`uvm_component_utils(test)

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	task run_phase(uvm_phase phase);
		run_sequence seq;

		seq = new("seq");

		phase.raise_objection(this);
		seq.start(sequencer_h);
		phase.drop_objection(this);

	endtask : run_phase

endclass : test

`endif