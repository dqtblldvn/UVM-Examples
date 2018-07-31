module AddSub4Bit(A,B,result,op);
input [3:0] A,B;
output [4:0] result;
input op;

FullAdder F0(A[0],B[0]^op,op,result[0],C0);
FullAdder F1(A[1],B[1]^op,C0,result[1],C1);
FullAdder F2(A[2],B[2]^op,C1,result[2],C2);
FullAdder F3(A[3],B[3]^op,C2,result[3],result[4]);

endmodule

