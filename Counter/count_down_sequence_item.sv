`ifndef GUARD_COUNT_DOWN_SEQUENCE_ITEM
`define GUARD_COUNT_DOWN_SEQUENCE_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_down_sequence_item extends sequence_item;
	`uvm_object_utils(count_down_sequence_item)

	constraint countdownonly {updn == 1; en == 1;}
endclass : count_down_sequence_item
`endif

