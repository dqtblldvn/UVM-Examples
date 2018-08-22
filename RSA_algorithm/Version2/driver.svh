`ifndef GUARD_DRIVER
`define GUARD_DRIVER 

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class driver extends uvm_driver #(data_transaction);
	`uvm_component_utils(driver)

	virtual RSA_bfm bfm;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db #(virtual RSA_bfm)::get(null,"*","bfm",bfm))
			`uvm_fatal("Driver","Failed to get interface")
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		data_transaction data;

		forever begin
			seq_item_port.get_next_item(data);
			`uvm_info("Driver",$sformatf("Drive information into interface:\nn = %0d\ne = %0d\nd = %0d\nm = %0d\n",data.n,data.e,data.d,data.m),UVM_MEDIUM)
			bfm.send_op(data.n,data.e,data.d,data.m);
			seq_item_port.item_done();
		end // forever

	endtask : run_phase

endclass : driver
`endif