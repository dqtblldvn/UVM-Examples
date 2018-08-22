`ifndef GUARD_SCOREBOARD
`define GUARD_SCOREBOARD

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class scoreboard extends uvm_subscriber #(data_transaction);
	`uvm_component_utils(scoreboard)

	bit [KEY_WIDTH-1:0] plaintext;
	bit [KEY_WIDTH-1:0] public_key;
	bit [KEY_WIDTH-1:0] private_key;
	bit [KEY_WIDTH-1:0] ciphertext;
	bit [KEY_WIDTH-1:0] r_plaintext;
	bit [KEY_WIDTH-1:0] modulus;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void write(data_transaction t);
		case (t.mode)
			0: begin
				plaintext = t.m;
				public_key = t.e;
				modulus = t.n;
				ciphertext = t.c;
			end
			1: begin
				private_key = t.d;
				r_plaintext = t.r;
				$display("[**************************]");
				$display("Plaintext #%0d\nRange of plaintext length: [%0d,%0d] bits",t.id,(t.id-1)*32,t.id*32);
				$display("____________________");
				$display("Encrypt process");
				$display("--------------------");
				$display("Public key is:\n%0d",public_key);
				$display("Modulus is:\n%0d",modulus);
				$display("Plaintext is:\n%0d",plaintext);
				$display("Ciphertext is:\n%0d",ciphertext);
				$display("____________________");
				$display("Decrypt process");
				$display("--------------------");
				$display("Private key is:\n%0d",private_key);
				$display("Modulus is:\n%0d",modulus);
				$display("Ciphertext is:\n%0d",ciphertext);
				$display("Recovered plaintext is:\n%0d",r_plaintext);
				$display("____________________");
				$display("Compare");
				$display("--------------------");
				$display("Plaintext is:\n%0d",plaintext);
				$display("Recovered plaintext is:\n%0d",r_plaintext);
				if (plaintext === r_plaintext)
					$display("Encrypt and decrypt successful. Plaintext and recovered one matched\n");
				else
					$display("There should be an error as the recovered plaintext is not the same as the original one\n");
				end
			endcase // t.mode
	endfunction : write			

endclass : scoreboard

`endif