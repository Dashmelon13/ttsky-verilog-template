<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a simple 8-bit CPU in Verilog. The processor executes a rather small instruction set that consists of 6 operations which include NOP, MOVI, ADD, SUB, AND, and OR. The core of this design includes an instruction decoder, control unit, program counter, register file, and arithmetic logic unit. These componenets which make up the CPU were integrated into the top module of the Tiny Tapeout template and verified using simulation. In this design on very clock cycle the CPU decodes 8-bit insturction, selecting operands from the register file and performing the correct ALU operation. It then writes the result to the desgination register and increments the Program Counter for the next instruction in line.

## How to test

The top module of my project can be tested using an automatic simulation flow through Verilog and Cocotb in python.Running make -B inside the test directory compiles the comlete Verilog hierarchy and executes the python test. This action will initialize the clock and drive the instruction sequences.