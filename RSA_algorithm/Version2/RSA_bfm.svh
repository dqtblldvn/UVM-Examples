interface RSA_bfm;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RSA_pkg::*;

	bit clk,en;
	bit [31:0] data_in, modulus_in, key_in;
	bit valid_in;
	bit [31:0] data_out;
	bit valid_out;
	int i;
	bit flag_en_monitor, flag_de_monitor;

	bit [31:0] d_reg [KEY_WIDTH/32 - 1 : 0];
	bit [31:0] e_reg [KEY_WIDTH/32 - 1 : 0];
	bit [31:0] m_reg [KEY_WIDTH/32 -1 : 0];
	bit [31:0] m_tmp [KEY_WIDTH/32 -1 : 0];
	bit [31:0] n_reg [KEY_WIDTH/32 - 1 : 0];

	task send_op(bit [KEY_WIDTH-1:0] n, bit [KEY_WIDTH-1:0] e, bit [KEY_WIDTH-1:0] d, bit [KEY_WIDTH-1:0] m);
		en = 1;
		flag_de_monitor = 0; flag_en_monitor = 0;
		d_reg = {>>{d}};
		e_reg = {>>{e}};
		m_reg = {>>{m}};
		n_reg = {>>{n}};

		@(posedge clk);
		valid_in = 1;
		data_in = m_reg[0];
		key_in = e_reg[0];
		modulus_in = n_reg[0];
		`uvm_info("Interface","\nStart the encrypt process\n",UVM_MEDIUM);
		for (i=1; i<=(KEY_WIDTH/32-1);i++)
		begin
			@(posedge clk);
			data_in = m_reg[i];
			key_in = e_reg[i];
			modulus_in = n_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in = 'bz; key_in = 'bz; modulus_in = 'bz;

		@(posedge clk);
		for (i=0; i<=(KEY_WIDTH/32-1);i++)
		begin
			@(posedge clk);
			m_tmp[i] = data_out;
		end
		@(posedge clk);
		flag_en_monitor = 1;
		////////////////////////
		@(posedge clk);
		flag_en_monitor = 0;
		valid_in = 1;
		data_in = m_tmp[0];
		key_in = d_reg[0];
		modulus_in = n_reg[0];
		`uvm_info("Interface","\nStart the decrypt process\n",UVM_MEDIUM);
		for (i=1; i<=(KEY_WIDTH/32-1);i++)
		begin
			@(posedge clk);
			data_in = m_tmp[i];
			key_in = d_reg[i];
			modulus_in = n_reg[i];
		end
		@(posedge clk);
		valid_in = 0; data_in = 'bz; key_in = 'bz; modulus_in = 'bz;

		@(posedge clk);
		for (i=0; i<=(KEY_WIDTH/32-1);i++)
		begin
			@(posedge clk);
			m_tmp[i] = data_out;
		end
		@(posedge clk);
		flag_de_monitor = 1;
		@(posedge clk);
		flag_de_monitor = 0;
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