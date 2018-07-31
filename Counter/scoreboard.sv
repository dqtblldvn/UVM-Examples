`ifndef GUARD_SCOREBOARD
`define GUARD_SCOREBOARD


`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

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

		predicted = new("predicted");
			if (cmd.en)
				if (cmd.load)
					predicted.dataout = cmd.datain;
					else
					if(cmd.updn)
						predicted.dataout = cmd.dataout - 1;
					else
						predicted.dataout = cmd.dataout + 1;
			else predicted.dataout = 'bx;
	return predicted;
	endfunction: predicted_result

	function void write(result_transaction t);
		result_transaction predicted;
		sequence_item cmd;
		string data_str;

		if(!cmd_f.try_get(cmd))
          `uvm_error("Scoreboard", "Missing result in scoreboard")

		predicted = predicted_result(cmd);

		data_str = {cmd.convert2string(), " Actual: ",t.convert2string()," Predicted: ", predicted.convert2string()};

		if (!predicted.do_compare(t))
			`uvm_error("Scoreboard",{"Results no match ",data_str})
		else
			`uvm_info("Scoreboard",data_str,UVM_MEDIUM)

	endfunction: write

endclass : scoreboard

`endif
