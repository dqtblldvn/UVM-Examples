module transmitter(clk, request, e, n, message, accept, finish, c);
parameter KEY_WIDTH = 128;
	input clk, request;
	input [KEY_WIDTH-1:0] e, n, message;

	output reg accept, finish;
	output reg [KEY_WIDTH-1:0] c;

	function bit checkMessage(bit [KEY_WIDTH-1:0] m);
		if (|m != 1'b1)
			return 0;
		else 
			return 1;
	endfunction : checkMessage

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
		@(posedge request);
		$display($time,"[Transmitter]\tReceived request signal = %0d\n",request);
		@(message);
		$display($time,"[Transmitter]\tMessage appeared:\nm = %0d\n",message);
		@(posedge clk);
		if (request)
			accept = 1;
		$display($time,"[Transmitter]\tWaiting for key: accept = %0d\n",accept);
		@(n);
		$display($time,"[Transmitter]\tReceived key:\ne = %0d\nn = %0d\nStart to encrypt\n",e,n);
		finish = 0;
		@(posedge clk);
		c = modq(message,e,n);
		finish = 1;
		$display($time,"[Transmitter]\tCiphertext:\nc = %0d\n",c);
		$display($time,"[Transmitter]\tFinish encryption: finish = %0d\n",finish);
	end // initial

endmodule // transmitter


