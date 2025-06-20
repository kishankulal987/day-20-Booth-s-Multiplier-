`timescale 1ns / 1ps


module data_path(input [4:0]dinA,dinQ,input enableD,loadA,clearA,shiftA,loadQ,shiftQ,clearQ,clearF,loadM,addsub,decc,loadcntr,clearcntr,clk,input [3:0]cycle,output eqz,qm1,qn1);
wire [4:0]a,m,z,q;
wire [3:0]counter;
shift_regA A(z,clk,shiftA,loadA,clearA,a[4],a);
shift_regA Q(dinQ,clk,shiftQ,loadQ,clearQ,a[0],q);
pipoM M(dinA,clk,loadM,m);
addsub adder(a,m,addsub,z);
d_flipflop F(clk,clearF,q[0],enableD,qm1);
counter C(cycle,clk,decc,loadcntr,clearcntr,counter);

assign eqz=~|counter;
assign qn1=q[0];
endmodule

module shift_regA(input [4:0]din, input clk, shift, load, clear, s_in, output reg [4:0]dout);
initial dout = 0;
always @(posedge clk)
begin
    if(clear) dout <= 0;
    else if(load) dout <= din;
    else if(shift) dout <= {s_in, dout[4:1]}; // Fixed shift index
end
endmodule

module pipoM(input [4:0]din,input clk,load,output reg [4:0]dout);
initial dout = 0;
always @(posedge clk)
begin
if(load) dout<=din;
end
endmodule

//module comparator(input a,b,output g,l,e);
//assign e=~(a^b);
//assign l=~a&b;
//assign g=a&~b;
//endmodule

module counter(input [3:0]din,input clk,decc, load,clr,output reg [3:0]dout);
always @(posedge clk)
begin
if(clr) dout<=0;
else if(load) dout<=din;
else if(decc) dout<=dout-1;
end
endmodule

module addsub(input [4:0]a,b,input addsub,output [4:0]dout);
assign dout=(addsub)?a+b:a-b;
endmodule

module d_flipflop(input clk,clear,din,enable,output reg dout);
always @(posedge clk)
begin
if(clear) dout<=0;
else if(enable) dout<=din;
end
endmodule


