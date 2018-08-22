module key_generator(clk,p,q,n,d,e);
parameter KEY_WIDTH = 64;
	input clk;
	input [KEY_WIDTH/2:0] p,q;
	output reg [KEY_WIDTH-1:0] n,d;
	output reg [KEY_WIDTH-1:0] e;

	bit [KEY_WIDTH-1:0] phi;
	const bit [KEY_WIDTH-1:0] e_reg = 65537;

function void find_d(bit [KEY_WIDTH-1:0] a, bit [KEY_WIDTH-1:0] b, output bit [KEY_WIDTH-1:0] result);
	bit signed [KEY_WIDTH*2-1:0] oa, ob, xa, xb, ya, yb, xr, yr, q, r, k;
	oa = a; ob = b;
			//$display("a=%d, b=%d\n\n",a,b);
			xa = 1; ya = 0; xb = 0; yb = 1;
			while (b != 0)
				begin
					//$display("______");
					q = a / b;
					//$display("q=%d\n",q);
					r = a % b;
					//$display("r=%d\n",r);
					a = b; b = r;
					//$display("a=%d, b=%d\n",a,b);
					xr = xa - xb*q;
					//$display("xr=%d\n",xr);
					yr = ya - yb*q;
					//$display("yr=%d\n",yr);
					xa = xb; ya = yb;
					//$display("xa=%d, ya=%d\n",xa,ya);
					xb = xr; yb = yr;
					//$display("xb=%d, yb=%d\n",xb,yb);
				end
					if (xa < 0)
						begin
							k = (- ya / oa) - 1;
							ya = k * oa + ya;
							xa = xa - k * ob;
						end
				result = xa;
endfunction : find_d

initial begin
	@(q); e = e_reg;
	n = {{(KEY_WIDTH/2-1){1'b0}},p} * {{(KEY_WIDTH/2-1){1'b0}},q};
	//$display("n = %d",n);
	phi = ({{(KEY_WIDTH/2-1){1'b0}},p} - 1) * ({{(KEY_WIDTH/2-1){1'b0}},q} - 1);
	//$display("e = %d, phi = %d",e_reg, phi);
	find_d(e_reg,phi,d);
	$display($time,"[Key_generator]\tKey generated:\n n = %0b\nphi = %0d\ne = %0d\nd = %0d\n",n,phi,e,d);
end // initial



endmodule // key_generator