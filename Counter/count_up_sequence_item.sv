`ifndef GUARD_COUNT_UP_SEQUENCE_ITEM
`define GUARD_COUNT_UP_SEQUENCE_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class count_up_sequence_item extends sequence_item;
	`uvm_object_utils(count_up_sequence_item)

	constraint countuponly {updn == 0; en == 1;}
endclass : count_up_sequence_item
`endif
