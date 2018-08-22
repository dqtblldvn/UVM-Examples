module encrypter_decrypter(clk,en,data_in,key_in, modulus_in,valid_in,data_out,valid_out);
	parameter KEY_WIDTH = 256;
	input clk,en;
	input [31:0] data_in; //data can be plaintext or ciphertext
	input [31:0] modulus_in;
	input [31:0] key_in;
	input valid_in;	

	output reg [31:0] data_out; //data can be plaintext or ciphertext
	output reg valid_out;

	//Internal registers for storing key and data
	reg [31:0] key [KEY_WIDTH/32 - 1 : 0];
	reg [31:0] modulus [KEY_WIDTH/32 -1 : 0];
	reg [31:0] idata [KEY_WIDTH/32 - 1 : 0];
	reg [31:0] odata [KEY_WIDTH/32 - 1 : 0];
	reg [KEY_WIDTH -1:0] data_tmp;

	// Count register and some flags
	bit [10:0] count; 
	bit key_flag, data_flag, odata_flag;

	// Function to calculate a^q mod n
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

	initial begin count = 0; key_flag = 0; data_flag = 0; odata_flag = 0; end // initial

	always @(posedge clk)
	if (en)
	begin
	///////////////////	
	if (valid_in)
	begin
		if (count>KEY_WIDTH/32)
			$warning("Registers are full!");
		else
			begin  
					idata[count] = data_in; data_flag = 1;
					key[count] = key_in; 
					modulus[count] = modulus_in; key_flag = 1;
					count = count + 1;
			end
	end
	else
	if (odata_flag)
		if(count == KEY_WIDTH/32)
			begin valid_out = 1; count  = count -1;
					data_out = odata[0]; end
		else if (count == 0)
			begin valid_out = 0;
					odata_flag = 0; 
					data_out = 'bz; end
		else begin
			data_out = odata[KEY_WIDTH/32 - count];
			count = count - 1;
		end
	/////////////
	end

	always @(negedge valid_in)
	if(en)
	/////////////
	begin
	if (count !== (KEY_WIDTH/32)) 
		$warning("Writing in registers may not complete: count = %0d\tExpect: %0d",count,KEY_WIDTH/32);
	else
	if (!key_flag) begin $warning("Key maybe missing");
						 $displayb("key = %p",key);
						 $display("modulus = %p",modulus);
				   end
	else
	if (!data_flag) begin $warning("Data maybe missing");
						  $displayb("data = %p",idata);
					end
	else 
		begin
		data_tmp = modq({>>{idata}},{>>{key}},{>>{modulus}});
		{>>{odata}} = data_tmp;
		odata_flag = 1;
	 	data_flag = 0; key_flag = 0;
	    end
	////////////
	end

endmodule // encrypter_decrypter
