`ifndef GUARD_SEQUENCE_ITEM 
`define GUARD_SEQUENCE_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;
import Counter_pkg::*;


class sequence_item extends uvm_sequence_item;
	`uvm_object_utils(sequence_item)

	function new(string name = "");
		super.new(name);
	endfunction : new

	rand bit [15:0] datain;
	rand bit load;
	rand bit updn;
	rand bit en;
	rand bit [15:0] dataout;

	constraint data {datain dist {16'h0000:=1,[16'h0001:16'hFFFE]:=1,16'hFFFF:=1};}
					

	function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		sequence_item RHS;
		bit same;

		assert (rhs!=null) else
		$fatal(1,"Null compare");
		same = super.do_compare(rhs,comparer);
		$cast(RHS,rhs);
		same = same && (RHS.datain = datain) && (RHS.load = load) && (RHS.updn = updn) && (RHS.en = en) && (RHS.dataout = dataout);
		return same;

	endfunction : do_compare

	function void do_copy(uvm_object rhs);
		sequence_item RHS;

		assert (rhs!=null) else
		$fatal(1,"Null transaction");
		super.do_copy(rhs);
		assert ($cast(RHS,rhs)) else
		$fatal(1,"Failed casting type");
		datain = RHS.datain;
		load = RHS.load;
		updn = RHS.updn;
		en = RHS.en;
		dataout = RHS.dataout;
	endfunction : do_copy

	function string convert2string();
		string s;
		s = $sformatf("en = %0b; load = %0b; up_down = %0b; data in = %d",en, load, updn, datain);
		return s;
	endfunction : convert2string

endclass : sequence_item

`endif