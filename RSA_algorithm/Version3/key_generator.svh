`ifndef GUARD_KEY_GENERATOR 
`define GUARD_KEY_GENERATOR

`include "uvm_macros.svh"
import uvm_pkg::*;
import RSA_pkg::*;

class key_generator extends uvm_sequence_item;
	`uvm_object_utils(key_generator)

	reg [KEY_WIDTH-1:0] n,d;
	reg [KEY_WIDTH-1:0] e;

	bit [KEY_WIDTH-1:0] phi;
	bit [KEY_WIDTH/2:0] p,q;
	const bit [KEY_WIDTH-1:0] e_reg = 65537;

function new(string name="");
	super.new(name);
endfunction : new

function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		key_generator RHS;
		bit same;

		assert (rhs!=null) else
		$fatal(1,"Null compare");
		same = super.do_compare(rhs,comparer);
		$cast(RHS,rhs);
		same = same && (RHS.n = n) && (RHS.d = d) && (RHS.e = e);
		return same;

	endfunction : do_compare

function void do_copy(uvm_object rhs);
		key_generator RHS;

		assert (rhs!=null) else
		$fatal(1,"Null transaction");
		super.do_copy(rhs);
		assert ($cast(RHS,rhs)) else
		$fatal(1,"Failed casting type");
		n=RHS.n;
		d=RHS.d;
		e=RHS.e;
	endfunction : do_copy

// Function to find the private key d: d*e mod phi = 1
function void find_d(bit [KEY_WIDTH-1:0] a, bit [KEY_WIDTH-1:0] b, output bit [KEY_WIDTH-1:0] result);
	bit signed [KEY_WIDTH*2-1:0] oa, ob, xa, xb, ya, yb, xr, yr, q, r, k;
	oa = a; ob = b;
			xa = 1; ya = 0; xb = 0; yb = 1;
			while (b != 0)
				begin
					q = a / b;
					r = a % b;
					a = b; b = r;
					xr = xa - xb*q;
					yr = ya - yb*q;
					xa = xb; ya = yb;
					xb = xr; yb = yr;
				end
					if (xa < 0)
						begin
							k = (- ya / oa) - 1;
							ya = k * oa + ya;
							xa = xa - k * ob;
						end
				result = xa;
endfunction : find_d

// Function to calculate a^q mod n
function bit [(KEY_WIDTH/2):0] modq(bit [(KEY_WIDTH/2):0] a,bit [(KEY_WIDTH/2):0] q, bit [(KEY_WIDTH/2):0] n);
		automatic bit [(KEY_WIDTH/2):0] result = 1;
		bit [(KEY_WIDTH+1):0] ra, aa;
		//$display("a = %0d, q = %0d, n = %0d",a,q,n);
		while (q!=0)
		begin
			if (q%2 !=0) begin ra=result*a; result=(ra%n); end
			q = q/2;
			aa = a*a;
			a = aa%n;
			//$display("a = %0d, q = %0d, result = %0d",a,q,result);
		end
		return result;
	endfunction : modq

//Function to create a prime number using Miller-Rabin test
function void random_prime(bit[(KEY_WIDTH/2):0] upper, bit [(KEY_WIDTH/2):0] lower, output bit [(KEY_WIDTH/2):0] p);
	const int rm_time = 50;
	automatic bit is_composite = 1;
	automatic bit [(KEY_WIDTH/2):0] q; automatic int k;
	int i; int j;
	bit [(KEY_WIDTH/2):0] a;
	bit [(KEY_WIDTH/2):0] mod;
	bit [(KEY_WIDTH+1):0] jq2;
    while (is_composite == 1)
    begin
        do
        begin
        	p[0] = upper[KEY_WIDTH/2];
        	p = (p<<32) + ($urandom_range(upper[KEY_WIDTH/2-1:KEY_WIDTH/2-32],lower[KEY_WIDTH/2-1:KEY_WIDTH/2-32]));
        	for (i = 1; i <= KEY_WIDTH/64-1;i++)
        		p = (p<<32) + ($urandom_range(32'b1,{16{2'b01}}));
        end
        while (p % 2 == 0);
            //printf("p=%ld\n",*p);
            	q = p - 1; k = 0;
                while (q % 2 == 0)
                    begin
                        k++; q = q/2;
                    end
                    //printf("k=%ld\tq=%ld\n",k,q);
                for (i=0;i<rm_time;i++)
                    begin
                        //printf("Lan i = %ld\n",i);
                        a = ($urandom()%((p-1)/rm_time)) + 1 + (p-1)/rm_time*i;
                        //printf("a=%ld\n",a);
                        mod = modq(a,q,p);
                        //printf("mod = %ld\n",mod);
                        if (mod == 1) continue;
                        for (j = 0; j < k; j++)
                            begin
                            	jq2 = (2**j)*q;
                                //printf("Lan j = %ld\n",j);
                                mod = modq(a,jq2,p);
                                //printf("mod2 = %ld\n",mod);
                                if (mod == p-1) break;
                            end
                            //printf("j=%ld\n",j);
                    if (j == k)  begin is_composite = 1; break; end                   end
                    //printf("i=%ld, composite = %d, p = %ld\n",i,is_composite,*p);
        if (i==rm_time) is_composite = 0;
    end

endfunction : random_prime

task keygen;
	random_prime({(KEY_WIDTH/2)+1{1'b1}},{1'b1,{(KEY_WIDTH/2)-1{1'b0}},1'b1},p);
	random_prime({(KEY_WIDTH/2)-1{1'b1}},{1'b1,{(KEY_WIDTH/2)-3{1'b0}},1'b1},q);
	`uvm_info("Prime_generator",$sformatf("\nTwo generated prime numbers:\nIn decimal:\np = %0d\nq = %0d\nIn binary:\np = %0b\nq = %0b\n",p,q,p,q),UVM_HIGH)
	e = e_reg;
	n = {{(KEY_WIDTH/2-1){1'b0}},p} * {{(KEY_WIDTH/2-1){1'b0}},q};
	phi = ({{(KEY_WIDTH/2-1){1'b0}},p} - 1) * ({{(KEY_WIDTH/2-1){1'b0}},q} - 1);
	find_d(e_reg,phi,d);
	`uvm_info("Key_generator",$sformatf("\nKey generated:\nIn decimal:\nn = %0d\nphi = %0d\ne = %0d\nd = %0d\nIn binary:\nn = %0b\nphi = %0b\ne = %0b\nd = %0b\n",n,phi,e,d,n,phi,e,d),UVM_HIGH)
endtask: keygen

endclass : key_generator

`endif