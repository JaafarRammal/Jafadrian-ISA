

module ALU(instruction, pc, clock, display, in, trigger, reset, led);

	input clock, trigger, reset;
	input [15:0] instruction;
	input [9:0] in;
	output [15:0] pc, display;
	output [9:0] led;
		
	reg [15:0] reg_file [0:15];
	reg [15:0] display;
	reg [9:0] led;
	
	// reg 15 is the pc
	assign pc = reg_file[15];
	// Reg 8 temp out
	//assign r = reg_file[8];
	
	parameter LI = 4'h0, IO = 4'h1, ADD = 4'h2, SUB =  4'h3, AND = 4'h4, OR = 4'h5, XOR = 4'h6, SL = 4'h7, SR = 4'h8;
	parameter SA = 4'h9, BG = 4'ha, BL = 4'hb, BE = 4'hc;
	
	wire [3:0] rd = instruction[11:8];
	wire [3:0] rs1 = instruction[7:4];
	wire [3:0] rs2 = instruction[3:0];
	wire [7:0] immediate = instruction[7:0]; // Same as IO
	
	initial reg_file[15] = 16'b0;
	
	parameter RUN = 2'b00, HOLD = 2'b01, INPUT = 2'b10;
	reg [1:0] state;
	initial state = RUN;
	
	always @ (negedge clock)
	begin
		if (reset == 1'b0) begin
			case (state)
			RUN: begin
				case(instruction[15:12])
					LI: begin
						reg_file[rd] <= { 8'b0, immediate };
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					IO: begin
						if (immediate == 8'b0) begin
							display <= reg_file[rd];
							reg_file[15] <= reg_file[15] + 4'h1;
						end
						else begin
							led <= 10'b1111111111;
							state <= HOLD;
						end
					end
					ADD: begin
						reg_file[rd] <= reg_file[rs1] + reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					SUB: begin
						reg_file[rd] <= reg_file[rs1] - reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					AND: begin
						reg_file[rd] <= reg_file[rs1] & reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					OR: begin
						reg_file[rd] <= reg_file[rs1] | reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					XOR: begin
						reg_file[rd] <= reg_file[rs1] ^ reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					SL: begin
						reg_file[rd] <= reg_file[rs1] << reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					SR: begin
						reg_file[rd] <= reg_file[rs1] >> reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					SA: begin
						reg_file[rd] <= reg_file[rs1] <<< reg_file[rs2];
						reg_file[15] <= reg_file[15] + 4'h1;
					end
					BG: begin
						if (reg_file[rs1] > reg_file[rs2])
							reg_file[15] <= reg_file[rd];
						else
							reg_file[15] <= reg_file[15] + 4'h1;
					end
					BL: begin
						if (reg_file[rs1] < reg_file[rs2])
							reg_file[15] <= reg_file[rd];
						else
							reg_file[15] <= reg_file[15] + 4'h1;
					end
					BE: begin
						if (reg_file[rs1] == reg_file[rs2])
							reg_file[15] <= reg_file[rd];
						else
							reg_file[15] <= reg_file[15] + 4'h1;
					end
					default:
						reg_file[15] <= reg_file[15] + 4'h1;
				endcase
			end
			HOLD: begin
				if (trigger == 1'b1) begin
					state <= INPUT;
					reg_file[rd] = { 6'b0, in };
					reg_file[15] <= reg_file[15] + 4'h1;
				end
			end
			INPUT: begin
				if (trigger == 1'b0)
					state <= RUN;
					led <= 10'b0;
			end
			endcase
		end
		else begin
			reg_file[0] <= 16'b0;
			reg_file[1] <= 16'b0;
			reg_file[2] <= 16'b0;
			reg_file[3] <= 16'b0;
			reg_file[4] <= 16'b0;
			reg_file[5] <= 16'b0;
			reg_file[6] <= 16'b0;
			reg_file[7] <= 16'b0;
			reg_file[8] <= 16'b0;
			reg_file[9] <= 16'b0;
			reg_file[10] <= 16'b0;
			reg_file[11] <= 16'b0;
			reg_file[12] <= 16'b0;
			reg_file[13] <= 16'b0;
			reg_file[14] <= 16'b0;
			reg_file[15] <= 16'b0;
			state <= RUN;
			led <= 10'b0;
			display <= 16'b0;
		end
	end
endmodule
