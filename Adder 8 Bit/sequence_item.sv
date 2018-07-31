`ifndef GUARD_SEQUENCE_ITEM 
`define GUARD_SEQUENCE_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;


class sequence_item extends uvm_sequence_item;
	`uvm_object_utils(sequence_item)

	function new(string name = "");
		super.new(name);
	endfunction : new

	rand bit [7:0] A,B;
	bit [8:0] result;

	constraint data{A dist {8'b00000000:=1,[8'b00000001:8'b11111110]:=1,8'b11111111:=1};
					B dist {8'b00000000:=1,[8'b00000001:8'b11111110]:=1,8'b11111111:=1};}

	function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		sequence_item RHS;
		bit same;

		assert (rhs!=null) else
		$fatal(1,"Null compare");
		same = super.do_compare(rhs,comparer);
		$cast(RHS,rhs);
		same = same && (RHS.A = A) && (RHS.B = B) && (RHS.result = result);
		return same;

	endfunction : do_compare

	function void do_copy(uvm_object rhs);
		sequence_item RHS;

		assert (rhs!=null) else
		$fatal(1,"Null transaction");
		super.do_copy(rhs);
		assert ($cast(RHS,rhs)) else
		$fatal(1,"Failed casting type");
		A=RHS.A;
		B=RHS.B;
		result=RHS.result;
	endfunction : do_copy

	function string convert2string();
		string s;
		s = $sformatf("A: %4d + B: %4d =",A,B);
		return s;
	endfunction : convert2string

endclass : sequence_item

`endif