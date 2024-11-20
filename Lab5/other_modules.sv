//this contains all the registers, MUXes, etc for datapath to use


module MUX_2 	#(parameter N = 16)
					(input logic           S,
					 input logic  [N-1:0]  A, B,
					 output logic [N-1:0]  Q);
		 always_comb
		 begin
				case(S)
				    1'b0 : Q = A;
					 1'b1 : Q = B;
		 
			   endcase
		 
		 end
					 
					 
					 
					 
					 
endmodule

module reg_file (input logic 					LD_REG, Clk, reset, 
					  input logic   [2:0]      SR2_addr, SR1_addr, DR_addr,
					  input logic   [15:0]     my_BUS, 
					  output logic  [15:0]     SR2_Out, SR1_Out);
			
			logic [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
			//logic [15:0] sr1, sr2;
			logic dr0, dr1, dr2, dr3, dr4, dr5, dr6, dr7;
			
			always_comb
			begin
			dr0 = 1'b0;
			dr1 = 1'b0;
			dr2 = 1'b0;
			dr3 = 1'b0;
			dr4 = 1'b0;
			dr5 = 1'b0;
			dr6 = 1'b0;
			dr7 = 1'b0;
			SR1_Out = 16'h0000;
			SR2_Out = 16'h0000;
				
				unique case(SR1_addr)
						3'b000 : SR1_Out = reg0;
						3'b001 : SR1_Out = reg1;
						3'b010 : SR1_Out = reg2;
						3'b011 : SR1_Out = reg3;
						3'b100 : SR1_Out = reg4;
						3'b101 : SR1_Out = reg5;
						3'b110 : SR1_Out = reg6;
						3'b111 : SR1_Out = reg7;
				endcase
				unique case(SR2_addr)
						3'b000 : SR2_Out = reg0;
						3'b001 : SR2_Out = reg1;
						3'b010 : SR2_Out = reg2;
						3'b011 : SR2_Out = reg3;
						3'b100 : SR2_Out = reg4;
						3'b101 : SR2_Out = reg5;
						3'b110 : SR2_Out = reg6;
						3'b111 : SR2_Out = reg7;
				endcase
				if (LD_REG)
				begin
					unique case(DR_addr)
							3'b000 : dr0 = 1'b1;
							3'b001 : dr1 = 1'b1;
							3'b010 : dr2 = 1'b1;
							3'b011 : dr3 = 1'b1;
							3'b100 : dr4 = 1'b1;
							3'b101 : dr5 = 1'b1;
							3'b110 : dr6 = 1'b1;
							3'b111 : dr7 = 1'b1;
					endcase	
				end
			end
reg1     REG0(.Clk(Clk), .reset(reset), .load(dr0), .Din(my_BUS), .Q(reg0));
reg1     REG1(.Clk(Clk), .reset(reset), .load(dr1), .Din(my_BUS), .Q(reg1));
reg1     REG2(.Clk(Clk), .reset(reset), .load(dr2), .Din(my_BUS), .Q(reg2));
reg1     REG3(.Clk(Clk), .reset(reset), .load(dr3), .Din(my_BUS), .Q(reg3));
reg1     REG4(.Clk(Clk), .reset(reset), .load(dr4), .Din(my_BUS), .Q(reg4));
reg1     REG5(.Clk(Clk), .reset(reset), .load(dr5), .Din(my_BUS), .Q(reg5));
reg1     REG6(.Clk(Clk), .reset(reset), .load(dr6), .Din(my_BUS), .Q(reg6));
reg1     REG7(.Clk(Clk), .reset(reset), .load(dr7), .Din(my_BUS), .Q(reg7));

					  
					  
					  
					  
					  
endmodule
module reg1   (input logic   reset, load, Clk,
					input logic   [15:0]     Din,
					output logic  [15:0]     Q);
			always_ff @ (posedge Clk)
			begin	
				if (reset)
						Q <= 16'h000;
					
				else if (load)		
						Q <= Din;
				else
						Q <= Q;
		   end		
					
endmodule


module ALU 	  (input logic   [1:0]      ALUK, 
					input logic   [15:0]     SR2, SR1,
					output logic  [15:0]     ALU_Out);
		always_comb
		begin
			case(ALUK)
				2'b00 : ALU_Out = SR1+SR2;
				2'b01 : ALU_Out= SR1 & SR2;
				2'b10 : ALU_Out = ~SR1;
				2'b11 : ALU_Out= SR1;
			endcase
		end
		
		
		
		
endmodule
module ADDR2  (input logic   [1:0]      ADDR2MUX, 
					input logic   [15:0]     a, b, c, d,
					output logic  [15:0]     Q);
		always_comb
		begin
			case(ADDR2MUX)
				2'b00 : Q = a;
				2'b01 : Q = b;
				2'b10 : Q = c;
				2'b11 : Q = d;
			endcase
		end			
					
endmodule

module regBEN (input logic      reset, Load, Clk,
					 input logic      D,
					 output logic     Q);
		always_ff @ (posedge Clk)
		begin
				if (reset)
					Q <= 1'b0;
				else if (Load)
					Q <= D;
				else 
					Q <= Q;
		end
endmodule

module setNZP (input logic           Clk, Load, reset,
					input logic  [15:0]   my_BUS,
					output logic [2:0]    NZP);
			always_ff @ (posedge Clk)
			begin
				if (reset)
					NZP = 3'b000;
				else if (Load)
					if (my_BUS == 16'h000)
						NZP = 3'b010;					
					else if (my_BUS[15] == 1'b1)
						NZP = 3'b100;
					else 
						NZP = 3'b001;
				else
						NZP = NZP;
			end
					
					
endmodule
					 
		