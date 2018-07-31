`ifndef GUARD_DRIVER 
`define GUARD_DRIVER

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class driver extends uvm_driver #(sequence_item);
	`uvm_component_utils(driver)

	virtual AddSub_bfm bfm;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual AddSub_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Driver","Failed to get bus")
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		sequence_item cmd;

		forever begin
			bit [8:0] result;
			seq_item_port.get_next_item(cmd);
			bfm.send_op(cmd.A,cmd.B,result);
			cmd.result = result;
			seq_item_port.item_done();
		end // forever
	endtask : run_phase

endclass : driver

`endif
