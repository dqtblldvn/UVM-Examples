`ifndef GUARD_RESULT_MONITOR 
`define GUARD_RESULT_MONITOR

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

class result_monitor extends uvm_component;
	`uvm_component_utils(result_monitor)

	virtual AddSub_bfm bfm;
	uvm_analysis_port #(result_transaction) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db #(virtual AddSub_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Result_monitor","Failed to get bus");

		ap = new("ap",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		result_transaction result_tmp;
		result_tmp = new("result_tmp");
		//`uvm_info("Result Monitor",$sformatf("Result form bfm: %b",result),UVM_LOW)
		forever begin @(negedge bfm.clk);
		fork
		result_tmp.result = bfm.result;
		ap.write(result_tmp);
		join_none
		end
	endtask : run_phase

endclass : result_monitor

`endif
