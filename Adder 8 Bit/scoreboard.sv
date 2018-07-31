`ifndef GUARD_SCOREBOARD
`define GUARD_SCOREBOARD


`include "uvm_macros.svh"
import "DPI-C" function void AddFunction(bit [7:0] A, bit [7:0] B, output bit[8:0] result);
import uvm_pkg::*;
import AddSub_pkg::*;

class scoreboard extends uvm_subscriber #(result_transaction);
	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(sequence_item) cmd_f;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		cmd_f = new("cmd_f",this);
	endfunction : build_phase

	function result_transaction predicted_result(sequence_item cmd);
		result_transaction predicted;

		predicted=new("predicted");
		AddFunction(cmd.A,cmd.B,predicted.result);
	return predicted;
	endfunction: predicted_result

	function void write(result_transaction t);
		result_transaction predicted;
		sequence_item cmd;
		string data_str;

		if(!cmd_f.try_get(cmd))
          `uvm_error("Scoreboard", "Missing command in scoreboard")

		predicted = predicted_result(cmd);

		data_str = {cmd.convert2string(), " Actual: ",t.convert2string()," Predicted: ", predicted.convert2string()};

		if (!predicted.do_compare(t))
			`uvm_error("Scoreboard","Results no match")
		else
			`uvm_info("Scoreboard",data_str,UVM_HIGH)

	endfunction: write

endclass : scoreboard

`endif