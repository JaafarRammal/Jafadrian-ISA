

module jarianISA_top(CLOCK_50, HEX3, HEX2, HEX1, HEX0, SW, LEDR, KEY);

	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	output [6:0] HEX3, HEX2, HEX1, HEX0;
	output [9:0] LEDR;
	
	wire [15:0] pc;
	wire [15:0] instruction;
	wire [15:0] display;
	wire slow_clock, super_slow_clock;
	
	div_by_N(CLOCK_50, 1'b1, 10, slow_clock);
	//div_by_N(slow_clock, 1'b1, 500, super_slow_clock);
	
	ROM instructionROM(
		.address (pc),
		.clock (slow_clock),
		.q (instruction));
	
	ALU(
		.instruction (instruction),
		.pc (pc),
		.display (display),
		.clock (slow_clock),
		.in (SW),
		.trigger (~KEY[0]),
		.reset (~KEY[3]),
		.led (LEDR));
		
	hex_to_7seg(HEX0, display[3:0]);
	hex_to_7seg(HEX1, display[7:4]);
	hex_to_7seg(HEX2, display[11:8]);
	hex_to_7seg(HEX3, display[15:12]);
	
	//assign LEDR = instruction[15:6];

endmodule
