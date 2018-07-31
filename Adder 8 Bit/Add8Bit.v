module Add8Bit(A,B,result);
input [7:0] A,B;
output [8:0] result;

FullAdder F0(A[0],B[0],1'b0,result[0],C0);
FullAdder F1(A[1],B[1],C0,result[1],C1);
FullAdder F2(A[2],B[2],C1,result[2],C2);
FullAdder F3(A[3],B[3],C2,result[3],C3);
FullAdder F4(A[4],B[4],C3,result[4],C4);
FullAdder F5(A[5],B[5],C4,result[5],C5);
FullAdder F6(A[6],B[6],C5,result[6],C6);
FullAdder F7(A[7],B[7],C6,result[7],result[8]);

endmodule
