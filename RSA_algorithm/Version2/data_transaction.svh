`ifndef GUARD_DATA_TRANSACTION
`define GUARD_DATA_TRANSACTION

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class data_transaction extends key_generator;
	`uvm_object_utils(data_transaction)

rand bit [KEY_WIDTH-3:0] m; //Variable that hold the randomized plaintext
bit [KEY_WIDTH-1:0] c; //Ciphertext
bit [KEY_WIDTH-1:0] r; //Recovered plaintext
bit mode; //0:encrypt  1:decrypt


function new(string name="");
	super.new(name);
endfunction : new

function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		data_transaction RHS;
		bit same;

		assert (rhs!=null) else
		$fatal(1,"Null compare");
		same = super.do_compare(rhs,comparer);
		$cast(RHS,rhs);
		same = same && (RHS.m = m);
		return same;

endfunction : do_compare

function void do_copy(uvm_object rhs);
		data_transaction RHS;

		assert (rhs!=null) else
		$fatal(1,"Null transaction");
		super.do_copy(rhs);
		assert ($cast(RHS,rhs)) else
		$fatal(1,"Failed casting type");
		m = RHS.m;
endfunction : do_copy

endclass : data_transaction
`endif