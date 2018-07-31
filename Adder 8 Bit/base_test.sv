`ifndef GUARD_BASE_TEST
`define GUARD_BASE_TEST

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;

virtual class base_test extends uvm_test;

env env_h;
sequencer sequencer_h;

function void build_phase(uvm_phase phase);
	env_h = env::type_id::create("env",this);
endfunction : build_phase

function void end_of_elaboration_phase(uvm_phase phase);
	sequencer_h = env_h.sequencer_h;
endfunction : end_of_elaboration_phase

function new(string name,uvm_component parent);
	super.new(name,parent);
endfunction : new

endclass : base_test
`endif
