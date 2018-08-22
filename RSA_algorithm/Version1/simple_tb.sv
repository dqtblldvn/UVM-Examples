module simple_tb;
	parameter KEY_WIDTH = 4096;
	bit clk_tx;
	bit clk_rx;
	bit en, request,accept,finish;
	bit [KEY_WIDTH-1:0] e,n, message, c, r;
always begin #10 clk_rx = ~clk_rx; clk_tx = ~clk_tx; end


transmitter #KEY_WIDTH TX(clk_tx, request, e, n, message, accept, finish, c);
receiver #KEY_WIDTH RX(en, finish, c, clk_rx, accept, n, e, request, r);

initial begin
	#0 en = 0; clk_rx = 0;
	#6; clk_tx = 0; 
	#25 en = 1;
	#100 message = 128'h416ab124579e682079657520;
	@(r);
	$finish;
end // initial

endmodule // simple_tb

