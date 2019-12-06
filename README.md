
# Jafadrian-ISA

Jafadrian-ISA is an afternoon project initially triggered by our curiosity to build a CPU on a FPGA board. Our project can be broken into 3 different parts. First, we designed our custom 16-bit ISA, then we built an assembler for our ISA with C++, and finally we built the CPU on a Cyclone V FPGA with Quartus and Verilog

## ISA

The ISA choice of 16-bit was made in order to simplify the CPU build later in the project, yet provide enough functionality to support arithmetic operations, branching, and subroutines.

We use 16 16-bit registers including the Program Counter PC. All of the registers are accessible for read and write. The opcode is defined by the first 4 bits of the binary

The instructions defined are as follow (ascending 4-bit opcode order):

```
00 Load Immediate:		LI	RD 	IM
01 Input / Output:		IO 	RD 	OP
02 Addition: 			ADD	RD 	RS1	RS2
03 Subtraction: 		SUB	RD 	RS1	RS2
04 Bitwise AND: 		AND	RD 	RS1	RS2
05 Bitwise OR:  		OR	RD 	RS1	RS2
06 Bitwise XOR: 		XOR	RD 	RS1	RS2
07 Left shift: 			SL	RD 	RS1	RV
08 Right shift: 		SR	RD 	RS1	RV
09 Arithmetic shift:	SA	RD 	RS1 RV
10 Branch on greater: 	BG	RD 	RS1 RS2
11 Branch on lower:	 	RD 	RS1 RS2
12 Branch on equal: 	BE	RD 	RS1 RS2
```

### Load Immediate

Loads an 8-bit immediate in the lowest half of a register

```
Sytnax: LI RD IM
Opcode:	0000
RD: Destination register (4 bits)
IM: Immediate (8 bits)
Operation: RD[7:0] <- IM[7:0]
```

### Input / Output
### Addition

Add two 16-bit registers

```
Sytnax: ADD RD RS1 RS2
Opcode:	0000
RD: Destination register (4 bits)
RS1: First addition operand (4 bits)
RS2: Second addition operand (4 bits)
Operation: RD[15:0] <- RS1[15:0] + RS2[15:0]
```
### Subtraction
### Bitwise AND
### Bitwise OR
### Bitwise XOR
### Left shift
### Right shift
### Arithmetic shift
### Branch on greater
### Branch on lower
### Branch on equal
