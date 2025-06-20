# Booth’s Multiplier in Verilog

## Overview

In this project, I implemented a Booth’s multiplier in Verilog using a combination of data path and control path modules. My goal was to create a circuit that multiplies two 5-bit numbers using Booth’s algorithm, which reduces the number of partial products by examining pairs of multiplier bits. For example, with inputs dinA=10110 (22) and dinQ=01101 (13), the multiplier computes the product (286 in binary). I designed the data path with shift registers, an adder/subtractor, a counter, and a flip-flop, controlled by a finite state machine in the control path. I wrote a testbench to verify the functionality with specific inputs and confirmed the design works as expected through simulation.


## datapath

![Screenshot 2025-06-18 202714](https://github.com/user-attachments/assets/571ce85d-717a-4764-b51f-cd74577593c4)

## control path

<img width="959" alt="image" src="https://github.com/user-attachments/assets/633e80a6-30b7-4106-9d97-fd200a95deaf" />



Module: shift_regA





What I Did: I designed a 5-bit shift register for the accumulator (A) and multiplier (Q).



Inputs:





din[4:0]: 5-bit data input.



clk: Clock signal.



shift: Shift enable.



load: Load enable.



clear: Clear enable.



s_in: Serial input for shifting.



Outputs:





dout[4:0]: 5-bit output.



How It Works:





On positive clock edge, if clear=1, dout is reset to 0.



If load=1, dout is loaded with din.



If shift=1, dout is right-shifted with s_in as the MSB: dout = {s_in, dout[4:1]}.



Initialized to 0 at start.



Style: Behavioral modeling with sequential logic.

Module: pipoM





What I Did: I designed a 5-bit parallel-in, parallel-out register for the multiplicand (M).



Inputs:





din[4:0]: 5-bit data input.



clk: Clock signal.



load: Load enable.



Outputs:





dout[4:0]: 5-bit output.



How It Works:





On positive clock edge, if load=1, dout is loaded with din.



Initialized to 0 at start.



Style: Behavioral modeling with sequential logic.

Module: counter





What I Did: I designed a 4-bit down-counter to track the number of iterations.



Inputs:





din[3:0]: 4-bit data input.



clk: Clock signal.



decc: Decrement enable.



load: Load enable.



clr: Clear enable.



Outputs:





dout[3:0]: 4-bit counter output.



How It Works:





On positive clock edge, if clr=1, dout is reset to 0.



If load=1, dout is loaded with din.



If decc=1, dout is decremented by 1.



Style: Behavioral modeling with sequential logic.

Module: addsub





What I Did: I designed a 5-bit adder/subtractor for arithmetic operations.



Inputs:





a[4:0]: First 5-bit input (accumulator).



b[4:0]: Second 5-bit input (multiplicand).



addsub: Control signal (1 for add, 0 for subtract).



Outputs:





dout[4:0]: 5-bit result.



How It Works:





Performs dout = a + b if addsub=1, or dout = a - b if addsub=0.



Style: Behavioral modeling with combinational logic.

Module: d_flipflop





What I Did: I designed a D flip-flop to store the previous multiplier bit (Q[-1]).



Inputs:





clk: Clock signal.



clear: Clear enable.



din: Data input.



enable: Enable signal.



Outputs:





dout: Output bit.



How It Works:





On positive clock edge, if clear=1, dout is reset to 0.



If enable=1, dout is set to din.



Style: Behavioral modeling with sequential logic.

Module: data_path





What I Did: I designed the data path for Booth’s multiplier, integrating all components.



Inputs:





dinA[4:0]: 5-bit multiplicand input.



dinQ[4:0]: 5-bit multiplier input.



enableD, loadA, clearA, shiftA, loadQ, shiftQ, clearQ, clearF, loadM, addsub, decc, loadcntr, clearcntr: Control signals.



clk: Clock signal.



cycle[3:0]: Counter initial value.



Outputs:





eqz: Counter equals zero.



qm1: Previous multiplier bit (Q[-1]).



qn1: Current LSB of multiplier (Q[0]).



How It Works:





Instantiates shift_regA for accumulator (A) and multiplier (Q), pipoM for multiplicand (M), addsub for arithmetic, d_flipflop for Q[-1], and counter for iterations.



Connects components to perform Booth’s algorithm steps (add/subtract, shift, etc.).



eqz = ~|counter indicates when the counter reaches zero.



qm1 and qn1 provide multiplier bits for control decisions.



Style: Structural modeling with module instantiations.

Module: control_path





What I Did: I designed a finite state machine to control the Booth’s multiplier.



Inputs:





clk: Clock signal.



qn1: Current LSB of multiplier.



qm1: Previous multiplier bit.



start: Start signal.



eqz: Counter equals zero.



Outputs:





enableD, loadA, clearA, shiftA, loadQ, shiftQ, clearQ, clearF, loadM, addsub, decc, loadcntr, clearcntr, done: Control signals.



How It Works:





Uses states s0 to s6 to manage the multiplication process.



State transitions:





s0: Initialize (clear counter and flip-flop).



s6: Load inputs (A, Q, M, counter).



s1: Check {qn1, qm1} to decide action.



s2: Add M to A ({qn1, qm1}=01).



s4: Subtract M from A ({qn1, qm1}=10).



s3: Shift A and Q, decrement counter.



s5: Done (if eqz=1).



Control signals are set in each state to manage the data path.



Style: Behavioral modeling with a finite state machine.

Testbench: testbench





What I Did: I created a testbench to verify the Booth’s multiplier.



How It Works:





I defined inputs dinA=10110 (22), dinQ=01101 (13), cycle=0100 (4 iterations), and a clock with a 10ns period.



I set start=1 initially, then start=0 after 10ns, and ran the simulation for 150ns.



I used $monitor to display done, accumulator (DP.a), multiplier (DP.q), Q[-1] (DP.qm1), and multiplicand (DP.m).



Time Scale: I set 1ns / 1ps for precise simulation timing.



Purpose: My testbench ensures the multiplier correctly computes the product for the given inputs.

Files





data_path.v: Verilog module for the data path.



control_path.v: Verilog module for the control path.



shift_regA.v: Verilog module for the shift register.



pipoM.v: Verilog module for the PIPO register.



counter.v: Verilog module for the counter.



addsub.v: Verilog module for the adder/subtractor.



d_flipflop.v: Verilog module for the D flip-flop.



testbench.v: Testbench for simulation.

## Circuit Diagram

Below is the circuit diagram for the Booth’s multiplier.

![Screenshot 2025-06-20 132303](https://github.com/user-attachments/assets/617bbd7c-c6ad-4d4c-ac8f-b92ef448d8f7)


### data path 

![Screenshot 2025-06-20 132636](https://github.com/user-attachments/assets/dd2b5793-85bd-4d07-aa73-3d212e05c53f)

### control path

![Screenshot 2025-06-20 132658](https://github.com/user-attachments/assets/7a986737-fb29-43e3-8623-2bd80dd97422)



## Simulation Waveform

Below is the simulation waveform, showing inputs dinA[4:0], dinQ[4:0], clk, start, cycle[3:0], and outputs eqz, qm1, qn1, done, along with internal signals.

![Screenshot 2025-06-20 132211](https://github.com/user-attachments/assets/e569c4e5-27e8-420a-878f-d6f526a58a30)


## Console Output

Below is the console output from my testbench simulation.

![Screenshot 2025-06-20 132034](https://github.com/user-attachments/assets/080e8f9b-461d-4650-b57a-b308d1164289)
