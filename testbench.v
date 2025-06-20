`timescale 1ns / 1ps

module testbench();
reg [4:0]dinA,dinQ;
reg clk,start;
reg[3:0]cycle;
wire done;
data_path DP(dinA, dinQ, enableD,loadA, clearA, shiftA, loadQ, shiftQ, clearQ, clearF, loadM, addsub, decc, loadcntr, clearcntr, clk, cycle, eqz, qm1, qn1);
control_path CP(clk,qn1,qm1,start,eqz,enableD,loadA,clearA,shiftA,loadQ,shiftQ,clearQ,clearF,loadM,addsub,decc,loadcntr,clearcntr,done);

initial clk=0;
always #5 clk=~clk;
initial begin
start=1;
cycle=4'b0101;
dinA=5'b10110;
dinQ=5'b01101;
#10 start=0;
#150;
end
initial begin
$monitor("done=%b product=%b %b %b M=%b",done,DP.a[4:0],DP.q[4:0],DP.qm1,DP.m[4:0]);
end
endmodule


