`ifndef GUARD_FIBONACCI_SEQUENCE
`define GUARD_FIBONACCI_SEQUENCE 

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class fibonacci_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(fibonacci_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
			bit [7:0] un1 = 8'b00000001;
			bit [7:0] un2 = 8'b00000000;

			cmd = sequence_item::type_id::create("cmd");
			`uvm_info("Fibonacci_sequence","F(0)=0",UVM_MEDIUM)
			`uvm_info("Fibonacci_sequence","F(1)=1",UVM_MEDIUM)
			
			for (int i=1;i<=10;i++) begin
				start_item(cmd);
				cmd.A = un2;
				cmd.B = un1;
				finish_item(cmd);
				un2 = un1;
				un1 = cmd.result;
				`uvm_info("Fibonacci_sequence",$sformatf("F(%0d)=%0d",i+1,un1),UVM_MEDIUM)
			end
	endtask : body
endclass : fibonacci_sequence

`endif
