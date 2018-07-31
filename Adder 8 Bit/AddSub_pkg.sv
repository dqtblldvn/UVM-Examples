`ifndef ADDSUB_PKG
`define ADDSUB_PKG

package AddSub_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	typedef class sequence_item;
	typedef class fibonacci_sequence;
	typedef class odd_sequence;
	typedef class even_sequence;
	typedef class add_random_sequence;
	typedef class runall_sequence;
	typedef class result_transaction;
	typedef class scoreboard;
	typedef class driver;
	typedef class command_monitor;
	typedef class result_monitor;
	typedef class base_test;



	`include "sequence_item.sv"
	typedef uvm_sequencer #(sequence_item) sequencer;

	`include "fibonacci_sequence.sv"
	`include "odd_sequence.sv"
	`include "even_sequence.sv"
	`include "add_random_sequence.sv"
	`include "runall_sequence.sv"

	`include "result_transaction.sv"
	`include "scoreboard.sv"
	`include "driver.sv"
	`include "command_monitor.sv"
	`include "result_monitor.sv"
	`include "env.sv"

	`include "odd_test.sv"
	`include "base_test.sv"
	`include "random_test.sv"
	`include "even_test.sv"
	`include "fibonacci_test.sv"
	`include "full_test.sv"

endpackage : AddSub_pkg
`endif
