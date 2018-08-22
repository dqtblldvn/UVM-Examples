`ifndef RSA_PKG
`define RSA_PKG

package RSA_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	parameter KEY_WIDTH = 128;

	typedef class key_generator;
	typedef class data_transaction;
	typedef class run_sequence;
	typedef class scoreboard;
	typedef class driver;
	typedef class monitor;
	typedef class base_test;

	`include "key_generator.svh"
	`include "data_transaction.svh"
	typedef uvm_sequencer #(data_transaction) sequencer;

	`include "run_sequence.svh"
	`include "scoreboard.svh"
	`include "driver.svh"
	`include "monitor.svh"
	`include "env.svh"
	`include "base_test.svh"
	`include "test.svh"

endpackage : RSA_pkg
`endif