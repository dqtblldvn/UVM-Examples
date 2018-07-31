`ifndef GUARD_COMMAND_MONITOR 
`define GUARD_COMMAND_MONITOR


`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;


class command_monitor extends uvm_component;
	`uvm_component_utils(command_monitor)

	virtual Counter_bfm bfm;
	uvm_analysis_port #(sequence_item) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db #(virtual Counter_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Command_monitor","Failed to get bus");
		ap = new("ap",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		sequence_item cmd;
		cmd = new("cmd");
		forever begin @(posedge bfm.clk);
			#1;
			`uvm_info("CmdMntr",$sformatf("Get from bus: %h %b %b %b",bfm.datain,bfm.en,bfm.load,bfm.updn),UVM_MEDIUM)
		fork
			begin
		cmd.datain = bfm.datain;
		cmd.en = bfm.en;
		cmd.load = bfm.load;
		cmd.updn = bfm.updn;
		cmd.dataout = bfm.dataoutpre;
		ap.write(cmd);
		`uvm_info("CmdMntr",$sformatf("Send to scoreboard: %h %b %b %b %h",cmd.datain,cmd.en,cmd.load,cmd.updn,cmd.dataout),UVM_MEDIUM)
			end
		join_none
		end
	endtask : run_phase

endclass : command_monitor

`endif