
`ifndef GUARD_RESULT_TRANSACTION
`define GUARD_RESULT_TRANSACTION

`include "uvm_macros.svh"
import uvm_pkg::*;
import AddSub_pkg::*;


class result_transaction extends uvm_transaction;
	`uvm_object_utils(result_transaction)

	bit [8:0] result;

	function new(string name="");
		super.new(name);
	endfunction : new

	function void do_copy(uvm_object rhs);
		result_transaction copied_tramsaction_h;

		assert (rhs!=null) else
		$fatal(1,"Null transaction");
		super.do_copy(rhs);
		assert ($cast(copied_tramsaction_h,rhs)) else
		$fatal(1,"Failed casting type");
		this.result = copied_tramsaction_h.result;
	endfunction : do_copy

	function bit do_compare(uvm_object rhs, uvm_comparer comparer=null);
		result_transaction RHS;
		bit same;

		assert (rhs!=null) else
		$fatal(1,"Null compare");
		same = super.do_compare(rhs,comparer);
		$cast(RHS,rhs);
		same = same && (RHS.result = this.result);
		return same;

	endfunction : do_compare

	function string convert2string();
		string s;
		s = $sformatf("%4d",result);
		return s;
	endfunction : convert2string

endclass: result_transaction


`endif