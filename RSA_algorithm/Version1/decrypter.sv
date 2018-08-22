module decrypter(clk,c,d_wire,n_wire,finish,r,de_en);
parameter KEY_WIDTH = 128;
	input clk,finish,de_en;
	input [KEY_WIDTH-1:0] d_wire, n_wire, c;

	output reg [KEY_WIDTH-1:0] r;

	function bit [KEY_WIDTH-1:0] modq(bit [KEY_WIDTH-1:0] a,bit [KEY_WIDTH-1:0] q, bit [KEY_WIDTH-1:0] n);
		automatic bit [KEY_WIDTH-1:0] result = 1;
		bit [2*KEY_WIDTH-1:0] ra, aa;
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

	initial begin
		@(posedge de_en);
		$display($time,"[Decrypter]\tEnable decrypter, waiting for ciphertext\n");
		@(posedge finish);
		@(posedge clk);
		$display($time,"[Decrypter]\tReceived ciphertext:\nc = %0d\n",c);
		r = modq(c,d_wire,n_wire);
		$display($time,"[Decrypter]\tRecovered message:\nr =%0d\n",r);
	end

endmodule // cipher_decoder