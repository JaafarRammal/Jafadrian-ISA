
# Jafadrian-ISA

Jafadrian-ISA is an afternoon project initially triggered by our curiosity to build a CPU on a FPGA board. Our project can be broken into 3 different parts. First, we designed our custom 16-bit ISA, then we built an assembler for our ISA with C++, and finally we built the CPU on a Cyclone V FPGA with Quartus and Verilog

## ISA

The ISA choice of 16-bit was made in order to simplify the CPU build later in the project, yet provide enough functionality to support arithmetic operations, branching, and subroutines.

We use 16 16-bit registers including the Program Counter PC. All of the registers are accessible for read and write. The opcode is defined by the first 4 bits of the binary

The instructions defined are as follow (ascending 4-bit opcode order):

```
00 Load Immediate:		LI	RD 	IM
01 Input / Output:		IO 	RD
02 Addition: 			ADD	RD 	RS1	RS2
03 Subtraction: 		SUB	RD 	RS1	RS2
04 Bitwise AND: 		AND	RD 	RS1	RS2
05 Bitwise OR:  		OR	RD 	RS1	RS2
06 Bitwise XOR: 		XOR	RD 	RS1	RS2
07 Left shift: 			SL	RD 	RS	RV
08 Right shift: 		SR	RD 	RS	RV
09 Arithmetic shift:		SA	RD 	RS	RV
10 Branch on greater: 		BG	RA 	RS1	RS2
11 Branch on lower: 		BL	RA 	RS1	RS2
12 Branch on equal: 		BE	RA 	RS1	RS2
```

### Load Immediate

Loads an 8-bit immediate in the lowest half of a register

```
Assembly: LI RD IM
Opcode:	0000
RD: Destination register (4 bits)
IM: Immediate (8 bits)
Operation: RD[7:0] <- IM[7:0]
```

### Input / Output

I/O operations with the FPGA interface

```
Assembly: (I/O type) RD
Binary: Opcode (4 bits), RD (4 bits), I/O Type (8 bits)
Opcode:	0001
RD: Destination register (4 bits)
```

Currently, we support IN and OUT. We can support up to 256 different I/O type operations (keyboard input, mouse input, VGA output, etc...)

#### IN

Load a 10-bit value into lowest 10 bits of register from FPGA switches

```
Assembly: IN RD
Opcode:	0001
I/O Type: XXXXXXXX (8 bits)
RD: Destination register (4 bits)
Operation: RD[7:0] <- SW[9:0]
```

To ensure input is made at the correct time, the IN operation holds the ROM instruction fetching until the user approves the SW[9:0] input using the KEY[0] button on the FPGA (telling the CPU "this is your input")

#### OUT

Display a 16-bit value on the FPGA hex display

```
Assembly: OUT RD
Opcode:	0001
I/O Type: 00000000 (8 bits)
RD: Destination register displayed (4 bits)
Operation: Display[15:0] <- RD[15:0]
```

### Addition

Add two 16-bit values

```
Assembly: ADD RD RS1 RS2
Opcode:	0010
RD: Sum destination register (4 bits)
RS1: First addition operand (4 bits)
RS2: Second addition operand (4 bits)
Operation: RD[15:0] <- RS1[15:0] + RS2[15:0]
```

### Subtraction

Subtract two 16-bit values

```
Assembly: SUB RD RS1 RS2
Opcode:	0011
RD: Difference destination register (4 bits)
RS1: Subtraction minuend (4 bits)
RS2: Subtraction subtrahend (4 bits)
Operation: RD[15:0] <- RS1[15:0] - RS2[15:0]
```

### Bitwise AND

Bit-wise AND two 16-bit values

```
Assembly: AND RD RS1 RS2
Opcode:	0100
RD: Result destination register (4 bits)
RS1: First AND operand (4 bits)
RS2: Second AND operand (4 bits)
Operation: RD[15:0] <- RS1[15:0] & RS2[15:0]
```

### Bitwise OR

Bit-wise OR two 16-bit values

```
Assembly: OR RD RS1 RS2
Opcode:	0101
RD: Result destination register (4 bits)
RS1: First OR operand (4 bits)
RS2: Second OR operand (4 bits)
Operation: RD[15:0] <- RS1[15:0] | RS2[15:0]
```

### Bitwise OR

Bit-wise XOR two 16-bit values

```
Assembly: XOR RD RS1 RS2
Opcode:	0110
RD: Result destination register (4 bits)
RS1: First XOR operand (4 bits)
RS2: Second XOR operand (4 bits)
Operation: RD[15:0] <- RS1[15:0] ^ RS2[15:0]
```

### Left shift


Left shift a 16-bit value

```
Assembly: SL RD RS RV
Opcode:	0111
RD: Result destination register (4 bits)
RS: Value to be shifted (4 bits)
RV: Shift value (4 bits)
Operation: RD[15:0] <- RS[15:0] << RV[15:0]
```

### Right shift


Right shift a 16-bit value

```
Assembly: SR RD RS RV
Opcode:	1000
RD: Result destination register (4 bits)
RS: Value to be shifted (4 bits)
RV: Shift value (4 bits)
Operation: RD[15:0] <- RS[15:0] >> RV[15:0]
```

### Arithmetic shift


Arithmetic (right) shift a 16-bit value

```
Assembly: SA RD RS RV
Opcode:	1001
RD: Result destination register (4 bits)
RS: Value to be shifted (4 bits)
RV: Shift value (4 bits)
Operation: RD[15:0] <- RS[15:0] >>> RV[15:0]
```

### Branch on greater

Branch on greater

```
Assembly: BG RA RS1 RS2
Opcode:	1010
RA: Address register (4 bits)
RS1: Comparaison left operand (4 bits)
RS2: Comparaison right operand (4 bits)
Operation: PC <- RS1 > RS2 ? RA : PC + 4
```


### Branch on lower

Branch on lower

```
Assembly: BL RA RS1 RS2
Opcode:	1011
RA: Address register (4 bits)
RS1: Comparaison left operand (4 bits)
RS2: Comparaison right operand (4 bits)
Operation: PC <- RS1 < RS2 ? RA : PC + 4
```

### Branch on equal

Branch on lower

```
Assembly: BE RA RS1 RS2
Opcode:	1100
RA: Address register (4 bits)
RS1: Comparaison left operand (4 bits)
RS2: Comparaison right operand (4 bits)
Operation: PC <- RS1 == RS2 ? RA : PC + 4
```

