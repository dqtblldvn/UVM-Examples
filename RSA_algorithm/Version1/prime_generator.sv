module prime_generator(clk,en,p,q);
parameter KEY_WIDTH = 128;
input clk,en;
output reg [(KEY_WIDTH/2):0] p,q;

//import "DPI-C" context function void random_prime(input longint p, input longint q, output bit [31:0] prime);
//export "DPI-C" function modq;

// function longint modq(longint a,longint q, longint n);
// 	automatic longint result = 1;
// 	//$display("a = %0d, q = %0d, n = %0d",a,q,n);
// 	while (q!=0)
// 	begin
// 		if (q%2 !=0) result=((result*a)%n);
// 		q = q/2;
// 		a = (a*a)%n;
// 		//$display("a = %0d, q = %0d, result = %0d",a,q,result);
// 	end
// 	return result;
// endfunction : modq

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
        //printf("Test lai\n");
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

initial begin
	@(posedge clk && en);
	//random_prime({5'b01111,{((KEY_WIDTH/2)-5){1'b0}}},{5'b00001,{((KEY_WIDTH/2)-5){1'b0}}},p);
	//random_prime({5'b11111,{((KEY_WIDTH/2)-5){1'b0}}},{5'b10000,{((KEY_WIDTH/2)-5){1'b0}}},q);
	random_prime({(KEY_WIDTH/2)+1{1'b1}},{1'b1,{(KEY_WIDTH/2)-1{1'b0}},1'b1},p);
	random_prime({(KEY_WIDTH/2)-1{1'b1}},{1'b1,{(KEY_WIDTH/2)-3{1'b0}},1'b1},q);
	$display($time,"[Prime_generator]\tTwo generated prime numbers:\np = %0b\nq = %0b\n",p,q);
	// longint a;
	// a = modq(2,15,7);
end // initial

endmodule