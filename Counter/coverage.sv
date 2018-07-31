`ifndef GUARD_COVERAGE
`define GUARD_COVERAGE

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class coverage extends uvm_subscriber #(sequence_item);
	`uvm_component_utils(coverage)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void write(sequence_item t);
	endfunction : write

endclass : coverage

`endif

