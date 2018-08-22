module encrypter_decrypter(clk,en,data_in,valid_in,select,data_out,valid_out);
	parameter KEY_WIDTH = 256;
	input clk,en;
	input [31:0] data_in; //data can be plaintext, ciphertext, modulus or key
	input valid_in;
	input [1:0] select; //11: data|  01: modulus| 10: key	

	output reg [31:0] data_out; //data can be plaintext or ciphertext
	output reg valid_out;

	//Internal registers for storing key and data
	reg [31:0] key [KEY_WIDTH/32 - 1 : 0];
	reg [31:0] modulus [KEY_WIDTH/32 -1 : 0];
	reg [31:0] idata [KEY_WIDTH/32 - 1 : 0];
	reg [31:0] odata [KEY_WIDTH/32 - 1 : 0];
	reg [KEY_WIDTH -1:0] data_tmp;

	// Count register and some flags
	int unsigned count,count_out; bit i; 
	bit key_flag, modulus_flag, data_flag, odata_flag;

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

	initial begin count = 0; odata_flag = 0;  key_flag = 0; modulus_flag = 0; data_flag = 0;
				{>>{key}} = {KEY_WIDTH{1'b0}};
				{>>{modulus}} = {KEY_WIDTH{1'b0}};
				{>>{idata}} = {KEY_WIDTH{1'b0}};
				{>>{odata}} = {KEY_WIDTH{1'b0}};
				end // initial

	always @(posedge clk)
	if (en)
	begin
	///////////////////	
	if (valid_in)
	begin
		if (count>KEY_WIDTH/32)
			$warning("Registers are full! Input is too long!");
		else
			begin  
				case (select)
					2'b11: begin if (count == 0) {>>{idata}} = {KEY_WIDTH{1'b0}};
						idata[count] = data_in; data_flag = 1; end
					2'b10: begin if (count == 0) {>>{key}} = {KEY_WIDTH{1'b0}}; 
								key[count] = data_in; key_flag = 1; end
					2'b01: begin if (count == 0) {>>{modulus}} = {KEY_WIDTH{1'b0}};
						modulus[count] = data_in; modulus_flag = 1; end
				endcase
				count = count + 1;
			end
	end
	else
	if (odata_flag)
	begin
			if (count == 0)
			begin valid_out = 0;
					odata_flag = 0; 
					data_flag = 0;
					data_out = 'bz;
					{>>{odata}} = {KEY_WIDTH{1'b0}}; end
		else begin
			valid_out = 1;
			data_out = odata[count_out - count];
			count = count - 1;
		end
	end
	/////////////
	end

	always @(negedge valid_in)
	if(en)
	/////////////
		begin
		if ((key_flag)&&(modulus_flag)&&(data_flag))
		begin
		count = 0; i = 0;
		data_tmp = modq({>>{idata}},{>>{key}},{>>{modulus}});
		for (count = KEY_WIDTH-1; count >= 0; count--)
		begin
			i = i|data_tmp[count];
			if (i)
			begin count = (count/32 + 1); break; end
		end
		count_out = count;
		{>>{odata}} = data_tmp;
		odata_flag = 1;
	    end
	    else
	    count = 0;
		end
	////////////

endmodule // encrypter_decrypter
