`ifndef GUARD_RUNALL_SEQUENCE
`define GUARD_RUNALL_SEQUENCE 

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;


class runall_sequence extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(runall_sequence)

	protected sequencer sequencer_h;
	protected fibonacci_sequence fibonacci;
	protected even_sequence even;
	protected odd_sequence odd;
	protected uvm_component uvm_component_h;

	function new(string name="runall_sequence");
		super.new(name);
		uvm_component_h = uvm_top.find("*.sequencer_h");
		if (uvm_component_h == null)
			`uvm_fatal("Run all","Null sequencer")
		if (!$cast(sequencer_h,uvm_component_h))
			`uvm_fatal("Run all","Wrong type of sequencer")

		fibonacci = fibonacci_sequence::type_id::create("fibonacci");
		even = even_sequence::type_id::create("even");
		odd = odd_sequence::type_id::create("odd");

	endfunction : new

	task body();
		fibonacci.start(sequencer_h);
		even.start(sequencer_h);
		odd.start(sequencer_h);
	endtask : body

endclass : runall_sequence

`endif


