`timescale 1ns / 1ps

module control_path(input clk,qn1,qm1,start,eqz,output reg  enableD,loadA,clearA,shiftA,loadQ,shiftQ,clearQ,clearF,loadM,addsub,decc,loadcntr,clearcntr,done);
localparam s0=4'b0000;
localparam s1=4'b0001;
localparam s2=4'b0010;
localparam s3=4'b0011;
localparam s4=4'b0100;
localparam s5=4'b0101;
localparam s6=4'b0110;
reg [3:0]current_state,next_state;

always @(posedge clk)
begin
if(start) current_state<=s0;
else current_state<=next_state;
end

always @(current_state,eqz,qn1, qm1)
begin
//loadA=0;clearA=0;shiftA=0;loadQ=0;shiftQ=0;clearQ=0;clearF=0;loadM=0;addsub=0;decc=0;loadcntr=0;clearcntr=0;
case(current_state)
s0 :  next_state<=s6;
s6 : next_state<=s1;
s1 : begin if({qn1,qm1}==2'b01) next_state<=s2;
           else if({qn1,qm1}==2'b10) next_state<=s4;
           else if({qn1,qm1}==2'b11 | {qn1,qm1}==2'b00) next_state<=s3;
     end
s2 : next_state<=s3;
s4 : next_state<=s3;
s3 : begin
     if(eqz) next_state<=s5;
     else next_state<=s1;
     end
s5 : next_state<=s5;
default :next_state <=s0;
endcase
end

always @(current_state)
begin
    enableD = 0; loadA = 0; clearA = 0; shiftA = 0; loadQ = 0; shiftQ = 0; clearQ = 0; clearF = 0; 
    loadM = 0; addsub = 0; decc = 0; loadcntr = 0; clearcntr = 0; done = 0;

    case(current_state)
        s0: begin
            clearcntr = 1; clearF = 1;
        end
        s6: begin
            clearA = 1; loadQ = 1; loadM = 1; loadcntr = 1; enableD = 0;
        end
        s1: begin
            enableD = 0;
        end
        s2: begin
            loadA = 1; addsub = 1; enableD = 0;
        end
        s4: begin
            loadA = 1; addsub = 0; enableD = 0;
        end
        s3: begin
            shiftA = 1; shiftQ = 1; decc = 1; enableD = 1;
        end
        s5: begin
            done = 1; enableD = 0;
        end
        default: begin end
    endcase
end
endmodule