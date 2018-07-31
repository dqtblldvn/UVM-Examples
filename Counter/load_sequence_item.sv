`ifndef GUARD_LOAD_SEQUENCE_ITEM
`define GUARD_LOAD_SEQUENCE_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;

class load_sequence_item extends sequence_item;
	`uvm_object_utils(load_sequence_item)

	constraint loadonly {load == 1; en == 1;}
endclass : load_sequence_item
`endif


