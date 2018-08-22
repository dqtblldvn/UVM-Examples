`ifndef GUARD_MONITOR
`define GUARD_MONITOR

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	virtual RSA_bfm bfm;
	uvm_analysis_port #(data_transaction) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual RSA_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Monitor","Failed to get interface")
	ap = new("ap",this);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		data_transaction data;
		data = new("data");
		fork
		forever begin @(posedge bfm.flag_en_monitor);
			@(negedge bfm.clk);
		data.mode = ~bfm.flag_en_monitor;
		data.n = {>>{bfm.n_reg}};
		data.e = {>>{bfm.e_reg}};
		data.m = {2'b0,{>>{bfm.m_reg}}};
		data.c = {>>{bfm.m_tmp}};
		`uvm_info("Monitor",$sformatf("\nEncrypt process finished. Data sent to scoreboard:\nn = %0d\ne = %0d\nm = %0d\nc = %0d\n",
			data.n,data.e,data.m,data.c),UVM_MEDIUM)
			ap.write(data);
		end

		forever begin @(posedge bfm.flag_de_monitor);
				@(negedge bfm.clk);
		data.mode = bfm.flag_de_monitor;
		data.d = {>>{bfm.d_reg}};
		data.r = {>>{bfm.m_tmp}};
		`uvm_info("Monitor",$sformatf("\nDecrypt process finished. Data sent to scoreboard:\nn = %0d\nd = %0d\nr = %0d\n",
			data.n,data.d,data.r),UVM_MEDIUM)
		ap.write(data);
		end
	join
	endtask : run_phase

endclass : monitor

`endif