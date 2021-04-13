module testbench();

timeunit 10ns;

timeprecision 1ns;
 
 logic CLK;
 logic RESET;
 logic AES_START;
 logic AES_DONE;
 logic [127:0] AES_KEY;
 logic [127:0] AES_MSG_ENC;   
 logic [127:0] AES_MSG_DEC;
 
 
	
	always begin: Clock_gen
	
	#1 CLK=~CLK; 
	
	end
	
	initial begin: Clock_ini
	
	CLK=1'b0;
	
	end
	
	AES bt(.*);
	
	initial begin: Test_vector
	AES_KEY=128'h000102030405060708090a0b0c0d0e0f;
	AES_MSG_ENC=128'hdaec3055df058e1c39e814ea76f6747e;
	RESET = 1;
	#4 RESET = 0;
	#20 AES_START = 1;
	
	//test case1

	#500;
	#1 AES_START = 0;
	
	end
	
	
	endmodule
	