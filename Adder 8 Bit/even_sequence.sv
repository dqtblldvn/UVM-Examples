`ifndef GUARD_EVEN_SEQUENCE
`define GUARD_EVEN_SEQUENCE 

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class even_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(even_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
			bit [7:0] un=0;
			cmd = sequence_item::type_id::create("command");
			

			`uvm_info("Even_sequence","F(0)=0",UVM_MEDIUM)
			for (int i=1;i<=10;i++) begin
				start_item(cmd);
				cmd.A = un;
				cmd.B = 8'b00000010;
				finish_item(cmd);
				un = cmd.result;
				`uvm_info("Even_sequence",$sformatf("F(%1d)=%1d",i,un),UVM_MEDIUM)
			end
	endtask : body
endclass : even_sequence

`endif

