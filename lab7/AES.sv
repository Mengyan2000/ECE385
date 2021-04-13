/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);
	logic [1407:0] expansionKey;
	logic [127:0] mes, next_mes;   //keep rack of current state and next state
	
	logic [3:0] count, next_count;   //keep tracking of 9 for loops
	logic [31:0] Col_in, Col_out;
	logic [127:0] subBy, Mix, Mix_out, Addkey, Shift;   //all four result from 4 inv modules
	

	assign AES_MSG_DEC = mes;
	KeyExpansion k0(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(expansionKey));
	
	InvShiftRows sr0(.data_in(mes), .data_out(Shift));
	
	allsubBytes  sb0(.clk(CLK), .in(mes), .out(subBy));  //accomplish in one cycle
	
	InvMixColumns  mc0(.in(Col_in), .out(Col_out));
	
	InvAddRoundkey  rk0(.state(mes), .roundKey(expansionKey), .count(count), .next_state(Addkey));

	
	enum logic [3:0] {WAIT, 
						DONE, 
						RK, ISR1_9, ISB1_9, RK1_9, IMC1_1, IMC1_2, IMC1_3, IMC1_4, IMC1_5,
						ISR10, ISB10, RK10}   State, Next_state;   // Internal state logic

	always_ff @ (posedge CLK)
	begin
		if (RESET) 
			begin
					State <= WAIT;
					count <= 0;
					mes <= 0;
					Mix <= 0;
			end
		else 
			begin
					State <= Next_state;
					count <= next_count;
					mes <= next_mes;
					Mix <= Mix_out;
			end
	end
	
	
	always_comb
	begin
			Next_state = State;
			next_count = count;
			next_mes = mes;
			Mix_out = Mix;
			AES_DONE = 0;
			Col_in = 32'h00000000;
			
			case(State)
					WAIT : if (AES_START) 
									Next_state = RK;
					RK :  if (AES_START)
								Next_state = ISR1_9;  //add initial round key
							
					//loop start
					ISR1_9 :  if(AES_START) 
										Next_state = ISB1_9;    //inverse shiftRows
					ISB1_9 :  if(AES_START)
										Next_state = RK1_9;   //inverse subBytes
					RK1_9 :   if(AES_START)
										Next_state = IMC1_1;   //add round key (2-10)
					IMC1_1 :  if(AES_START)
										Next_state = IMC1_2;
					IMC1_2 :  if(AES_START)
										Next_state = IMC1_3;
					IMC1_3 :  if(AES_START)
										Next_state = IMC1_4;
					IMC1_4 :  if(AES_START)
										Next_state = IMC1_5;
					IMC1_5 :  if (AES_START)
								 begin
										if (count < 9)
												Next_state = ISR1_9;
										if (count == 9)
												Next_state = ISR10;   //end the loop
								 end
					ISR10 :  if(AES_START)
							Next_state = ISB10;
					ISB10 : 
							Next_state = RK10;
					
		
					RK10 : 
							Next_state = DONE;
					DONE : if (~AES_START)
							Next_state = WAIT;
					default : ;
					
			endcase
			
			case(State)
					WAIT : next_mes = AES_MSG_ENC;
					
					RK :  begin
							next_count = count+1;
							next_mes = Addkey;
							end
					ISR1_9 : begin
								next_mes = Shift;
								end
					ISB1_9 :
								begin
								next_mes = subBy;
								end
					RK1_9 :
								begin
								next_mes = Addkey;
								end
					IMC1_1 :
								begin
								
								Col_in = mes[127:96];
								Mix_out = {Col_out, Mix[95:0]};
								end
					IMC1_2 :
								begin
								
								Col_in = mes[95:64];
								Mix_out = {Mix[127:96], Col_out, Mix[63:0]};
								end
					IMC1_3 :
								begin
								Col_in = mes[63:32];
								Mix_out = {Mix[127:64], Col_out, Mix[31:0]};
								end
					IMC1_4 :
								begin
								Col_in = mes[31:0];
								Mix_out = {Mix[127:32], Col_out};
										
								end
					IMC1_5 : 
								begin
								next_mes = Mix;
								next_count = next_count+1;
								end
					
					ISR10 : 
								begin
								next_mes = Shift;
								end
					ISB10 :
								begin 
								next_mes = subBy;
								end
					RK10 :
								begin
								next_mes = Addkey;
								end
					
					DONE :
						begin
							AES_DONE = 1;
							next_count = 0;
						
						end
					default : ;
			endcase
	end
						
endmodule

