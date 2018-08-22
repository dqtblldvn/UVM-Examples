`ifndef GUARD_ENV
`define GUARD_ENV

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class env extends uvm_env;
	`uvm_component_utils(env)

	sequencer sequencer_h;
	scoreboard scoreboard_h;
	driver driver_h;
	monitor monitor_h;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		sequencer_h = new("sequencer_h",this);

		driver_h = driver::type_id::create("driver_h",this);
		monitor_h = monitor::type_id::create("monitor_h",this);
		scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
		monitor_h.ap.connect(scoreboard_h.analysis_export);
	endfunction : connect_phase

endclass : env
`endif