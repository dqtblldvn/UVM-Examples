`ifndef COUNTER_PKG
`define COUNTER_PKG

package Counter_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	typedef class sequence_item;
	typedef class count_up_sequence_item;
	typedef class count_down_sequence_item;
	typedef class random_sequence;
	typedef class result_transaction;
	typedef class scoreboard;
	typedef class coverage;
	typedef class driver;
	typedef class command_monitor;
	typedef class result_monitor;
	typedef class base_test;
	typedef class env;


	`include "sequence_item.sv"
	`include "count_up_sequence_item.sv"
	`include "count_down_sequence_item.sv"
	typedef uvm_sequencer #(sequence_item) sequencer;

	`include "random_sequence.sv"
	`include "count_up_sequence.sv"
	`include "count_down_sequence.sv"

	`include "result_transaction.sv"
	`include "scoreboard.sv"
	`include "driver.sv"
	`include "coverage.sv"
	`include "command_monitor.sv"
	`include "result_monitor.sv"
	`include "env.sv"

	`include "base_test.sv"
	`include "random_test.sv"
	`include "count_up_test.sv"
	`include "count_down_test.sv"

endpackage : Counter_pkg
`endif

