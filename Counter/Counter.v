module Counter(clk,rst,load,updn,en,datain,dataout);
	input clk,rst,load,updn,en;
	input [15:0] datain;
	output reg [15:0] dataout;

	always @(posedge clk or negedge rst)
		begin
			if (!rst)
				dataout <= 0;
			else
			begin
				if (!en)
					dataout <= dataout;
				else if (load)
					dataout <= datain;
				else case (updn)
					1'b0: begin
						if (dataout == 16'hFFFF)
							dataout <= 0;
						else dataout <= dataout + 1;
						end // 1'b0:
					1'b1: begin
						if (dataout == 16'h0000)
							dataout <= 16'hFFFF;
						else dataout <= dataout - 1;
						end // 1'b1:end
					endcase // updn
			end
		end

endmodule // Counter


				

