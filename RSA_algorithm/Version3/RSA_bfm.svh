interface RSA_bfm;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RSA_pkg::*;

	bit clk,en;
	bit [31:0] data_in;
	bit valid_in;
	bit [31:0] data_out;
	bit valid_out;
	bit [1:0] select;
	int i;
	bit flag_en_monitor, flag_de_monitor;

	bit [31:0] d_reg [KEY_WIDTH/32 - 1 : 0];
	bit [31:0] e_reg [KEY_WIDTH/32 - 1 : 0];
	bit [31:0] m_reg [KEY_WIDTH/32 -1 : 0];
	bit [31:0] m_tmp [KEY_WIDTH/32 -1 : 0];
	bit [31:0] n_reg [KEY_WIDTH/32 - 1 : 0];
	int id;

	function int check_length(bit [KEY_WIDTH-1:0] x);
	int count; automatic bit i = 0;
		for (count = KEY_WIDTH-1; count >= 0; count--)
		begin
			i = i|x[count];
			if (i)
			begin count = (count/32 + 1); break; end
		end
		return count;
	endfunction : check_length

	task send_op(bit [KEY_WIDTH-1:0] n, bit [KEY_WIDTH-1:0] e, bit [KEY_WIDTH-1:0] d, bit [KEY_WIDTH-1:0] m, int idd);
		automatic int length_32 = 0;
		en = 1;
		flag_de_monitor = 0; flag_en_monitor = 0;
		d_reg = {>>{d}};
		e_reg = {>>{e}};
		m_reg = {>>{m}};
		n_reg = {>>{n}};
		id = idd;
		//// Encrypt process
		//// Send modulus in
		`uvm_info("Interface","\nStart encrypt process\n",UVM_FULL)
		@(posedge clk);
		select = 01; valid_in = 1; 
		data_in = n_reg[0];
		length_32 = check_length(n);
		`uvm_info("Interface","\nSending in the modulus\n",UVM_FULL);
		for (i=1; i<=(length_32-1);i++)
		begin
			@(posedge clk);
			data_in = n_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in ='bz; length_32 = 0;
		//// Send public key in
		select = 10; @(posedge clk);
		valid_in = 1;
		data_in = e_reg[0];
		length_32 = check_length(e);
		`uvm_info("Interface","\nSending in the public key\n",UVM_FULL);
		for (i=1; i<=(length_32-1);i++)
		begin
			@(posedge clk);
			data_in = e_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in ='bz; length_32 = 0;
		//// Send plaintext in
		select = 11; @(posedge clk);
		valid_in = 1;
		data_in = m_reg[0];
		length_32 = check_length(m);
		`uvm_info("Interface","\nSending in the plaintext\n",UVM_FULL);
		for (i=1; i<=(length_32-1);i++)
		begin
			@(posedge clk);
			data_in = m_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in ='bz; length_32 = 0;
		//// Get ciphertext out
		@(posedge clk);
		i = 0;
		@(posedge clk);
		while (valid_out !== 0)
		begin
		m_tmp[i++] = data_out;
		@(posedge clk);
		end
		flag_en_monitor = 1;

		////Decrypt process
		////Send private key in
		`uvm_info("Interface","\nStart decrypt process\n",UVM_FULL)
		select = 10; @(posedge clk);
		valid_in = 1;
		data_in = d_reg[0];
		length_32 = check_length(d);
		`uvm_info("Interface","\nSending in the private key\n",UVM_FULL);
		for (i=1; i<=(length_32-1);i++)
		begin
			@(posedge clk);
			data_in = d_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in ='bz; length_32 = 0;
		//// Send ciphertext in
		@(posedge clk);
		select = 11; valid_in = 1;
		data_in = m_tmp[0];
		length_32 = check_length({>>{m_tmp}});
		`uvm_info("Interface","\nSending in the ciphertext\n",UVM_FULL);
		for (i=1; i<=(length_32-1);i++)
		begin
			@(posedge clk);
			data_in = m_tmp[i];
		end
		@(posedge clk);
		valid_in = 0; data_in ='bz; length_32 = 0;
		//// Get recovered plaintext out
		@(posedge clk);
		i = 0;
		@(posedge clk);
		{>>{m_tmp}} = {KEY_WIDTH{1'b0}};
		while (valid_out !== 0)
		begin
		m_tmp[i++] = data_out;
		@(posedge clk);
		end
		flag_de_monitor = 1;

		repeat(5) @(posedge clk);
	endtask: send_op


	initial begin
		clk = 0;
		fork
			forever begin
				#10 clk = ~clk;
			end 
		join_none
	end 

endinterface : RSA_bfm