`ifndef GUARD_COMMAND_MONITOR 
`define GUARD_COMMAND_MONITOR


`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;


class command_monitor extends uvm_component;
	`uvm_component_utils(command_monitor)

	virtual AddSub_bfm bfm;
	uvm_analysis_port #(sequence_item) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db #(virtual AddSub_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Command_monitor","Failed to get bus");
		ap = new("ap",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		sequence_item cmd;
		cmd = new("cmd");
		//`uvm_info("Command Monitor",$sformatf("Get from bfm A=%b B=%b op=%b",A,B,op),UVM_LOW)
		forever begin @(posedge bfm.clk);
		fork
			begin
		cmd.A = bfm.A;
		cmd.B = bfm.B;
		ap.write(cmd);
			end
		join_none
		end
	endtask : run_phase

endclass : command_monitor

`endif