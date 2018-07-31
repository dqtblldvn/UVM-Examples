`ifndef GUARD_ODD_SEQUENCE
`define GUARD_ODD_SEQUENCE 

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class odd_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(odd_sequence)

	sequence_item cmd;

	function new(string name="");
		super.new(name);
	endfunction : new

	task body();
			bit [7:0] un=8'b00000001;
			cmd = sequence_item::type_id::create("command");

			`uvm_info("Odd_sequence","F(0)=1",UVM_MEDIUM)
			for (int i=1;i<=10;i++) begin
				start_item(cmd);
				cmd.A = un;
				cmd.B = 8'b00000010;
				finish_item(cmd);
				un = cmd.result;
				`uvm_info("Odd_sequence",$sformatf("F(%0d)=%0d",i,un),UVM_MEDIUM)
			end
	endtask : body
endclass : odd_sequence

`endif


