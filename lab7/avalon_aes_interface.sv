/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);
	
	
	reg_file  r0(.Clk(CLK), .reset(RESET), .CS(AVL_CS), .LD_REG(AVL_WRITE), .read(AVL_READ), .AVL_ADDR(AVL_ADDR), .AVL_WRITEDATA(AVL_WRITEDATA), .AVL_BYTE_EN(AVL_BYTE_EN), .AVL_READDATA(AVL_READDATA), .data(EXPORT_DATA));
	

endmodule

module reg_file (input logic 					LD_REG, Clk, reset, read,
					  input logic   [3:0]      AVL_ADDR,
					  input logic   [31:0]     AVL_WRITEDATA, 
					  input  logic  [3:0]      AVL_BYTE_EN,
					  input logic              CS,
					  output logic  [31:0]     AVL_READDATA, data);
			
			logic [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11;
			logic [31:0] writeData;
			logic dr0, dr1, dr2, dr3, dr4, dr5, dr6, dr7, dr8, dr9, dr10, dr11, load;
			logic [31:0] register[16];
			logic [127:0] AES_MSG_ENC, AES_MSG_DEC, AES_KEY;
			logic start, done;
			
	
			always_comb
			begin
				
				if (read && CS)
				begin
					AVL_READDATA = register[AVL_ADDR];
				end
				else
					AVL_READDATA = 0;
			
			end
		
			always_ff @ (posedge Clk)
			begin 
				if (LD_REG && CS)
				begin
					if (AVL_BYTE_EN[3] == 1)
							register[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24]; //write byte3
					if (AVL_BYTE_EN[2] == 1)
							register[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];   //write byte2
					if (AVL_BYTE_EN[1] == 1)
							register[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];     //write byte1
					if (AVL_BYTE_EN[0] == 1)
							register[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];   //write the byte0
				end
				register[15][0] <= done;
				{register[8][31:0], register[9][31:0], register[10][31:0], register[11][31:0]} <= AES_MSG_DEC;
			end
			//data = {WriteData[31:16], 16'h0000}
			assign data = {register[0][31:16], register[3][15:0]};  //00010203 [31:24] = 00; [23:16] = 01 [7:0] = 03
			
			
			
			assign AES_MSG_ENC = {register[4][31:0], register[5][31:0], register[6][31:0], register[7][31:0]};
			assign AES_KEY = {register[0][31:0], register[1][31:0], register[2][31:0], register[3][31:0]};
			assign start = register[14][0];
			//assign register[15][0] = done;
			//assign {register[8][31:0], register[9][31:0], register[10][31:0], register[11][31:0]} = AES_MSG_DEC;
			
			
			
			AES a0(.CLK(Clk), .RESET(reset), .AES_START(start), .AES_DONE(done), .AES_KEY(AES_KEY), .AES_MSG_ENC(AES_MSG_ENC), .AES_MSG_DEC(AES_MSG_DEC));
			
			
endmodule


