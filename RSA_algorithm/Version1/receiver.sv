module receiver(en, finish, c, clk, accept,
					n,e,request,r);
parameter KEY_WIDTH = 128;
input en, finish, clk, accept;
input [KEY_WIDTH-1:0] c;
output [KEY_WIDTH-1:0] n,e,r;
output request;

wire [KEY_WIDTH/2:0] p,q;
wire [KEY_WIDTH-1:0] d;
wire [KEY_WIDTH-1:0] n_wire,d_wire,e_wire;

prime_generator #KEY_WIDTH PG(clk,en,p,q);
key_generator #KEY_WIDTH KG(clk,p,q,n_wire,d_wire,e_wire);
decrypter #KEY_WIDTH DC(clk,c,d_wire,n_wire,finish,r,de_en);
check_to_send #KEY_WIDTH CTS(clk,n_wire,e_wire,accept,n,e,request,de_en);

endmodule // receiver


