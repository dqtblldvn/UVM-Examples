module Counter_assertion(clk,rst,en,load,updn,datain,dataout);
	input clk,rst,en,load,updn;
	input [15:0] datain;
	output reg [15:0] dataout;

// property counter_reset;
// 	@(clk) disable iff (rst) !rst |=> (dataout == 16'b0);
// endproperty

// counter_reset_check: assert property(counter_reset)
// else $display($time,"\tproperty reset fail");

// property counter_hold;
// 	@(posedge clk) disable iff (!rst) (!en) |=> dataout === $past(dataout);
// endproperty

// counter_hold_check: assert property(counter_hold)
// else $display($time,"\tproperty hold fail");

property counter_count;
	@(posedge clk) disable iff (!rst) (en & !load) |->
	if (updn)  (dataout+16'h0001) == $past(dataout,1)
		else  (dataout-16'h0001) == $past(dataout,1);
endproperty

counter_count_check: assert property(counter_count)
else $display($time,"\tproperty count fail","\t",dataout,"\t",$past(dataout));

endmodule // Counter_assertion