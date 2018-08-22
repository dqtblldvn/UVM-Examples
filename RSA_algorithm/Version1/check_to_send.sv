module check_to_send(clk,n_wire,e_wire,accept,n,e,request,de_en);
parameter KEY_WIDTH = 128;
	input clk,accept;
	input [KEY_WIDTH-1:0] n_wire,e_wire;

	output reg [KEY_WIDTH-1:0] n,e;
	output reg request,de_en;

	initial begin
		@(n_wire);
		$display($time,"[Check_to_send]\tGenerated key:\nn = %0d\ne= %0d\n",n_wire,e_wire);
		request = 1; 
		$display($time,"[Check_to_send]\tSending request signal = %0d\n",request);
		@ (posedge accept);
		$display($time,"[Check_to_send]\tReceived accept signal from transmitter: accept = %0d\n",accept);
		@(posedge clk);
		n = n_wire;
		e = e_wire;
		$display($time,"[Check_to_send]\tKey sent:\nn = %d\ne= %0d\n",n,e);
		de_en = 1;
		$display($time,"[Check_to_send]\tEnable decrypter: %0d\n",de_en);
	end // initial

endmodule // check_to_send