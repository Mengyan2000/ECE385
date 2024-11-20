module aes_avalon_interface
(// Avalon Clock Input
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
	output logic [31:0] EXPORT_DATA1,
	output logic [31:0] EXPORT_DATA2    // Exported color to top-evel
);
	
	
	reg_file  r0(.Clk(CLK), .reset(RESET), .CS(AVL_CS), .LD_REG(AVL_WRITE), 
					 .read(AVL_READ), .AVL_ADDR(AVL_ADDR), .AVL_WRITEDATA(AVL_WRITEDATA), .AVL_BYTE_EN(AVL_BYTE_EN), 
					 .AVL_READDATA(AVL_READDATA), .color(EXPORT_DATA1), .VGA_VH(EXPORT_DATA2));
	

endmodule

module reg_file (input logic 					LD_REG, Clk, reset, read,
					  input logic   [3:0]      AVL_ADDR,
					  input  logic  [3:0]      AVL_BYTE_EN,
					  input logic   [31:0]      AVL_WRITEDATA,
					  input logic              CS,
					  output logic  [31:0]     AVL_READDATA, 
					  output logic  [31:0]    color, VGA_VH);

			logic [31:0] register[16];
			logic VGA_HS, VGA_VS, sync, VGA_Clk;
			logic [9:0] drawxsig, drawysig, planexsig, planeysig, ballsizesig, barrierxsig, barrierysig, bulletxsig, bulletysig;
			logic [7:0] keycode;
			logic [3:0] statues [2:0];
			logic [9:0] bulletx1, bullety1, bulletx2, bullety2, barrierx2, barriery2, barriery_1;
			logic [9:0] backgroundX, backgroundY;
			logic [31:0] score;
			logic blank;   //making the color be black during blanking interval
	
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
							register[AVL_ADDR][15:8] <= AVL_WRITEDATA[31:24];
					if (AVL_BYTE_EN[2] == 1)
							register[AVL_ADDR][15:8] <= AVL_WRITEDATA[23:16];
					if (AVL_BYTE_EN[1] == 1)
							register[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];     //write byte1
					if (AVL_BYTE_EN[0] == 1)
							register[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];   //write the byte0
				end
				register[8][9:0] <= planexsig;
				register[9][9:0] <= planeysig;
				register[4][9:0] <= bulletx1;
				register[5][9:0] <= bullety1;
				register[6][9:0] <= bulletx2;
				register[7][9:0] <= bullety2;
				
			end
			//data = {WriteData[31:16], 16'h0000}
			
			
			assign VGA_VH = {28'h0000000, 2'b00, VGA_VS, VGA_HS}; 
			assign statues[2][2:0] = register[11][2:0];       //the plane is not on the screen only when it gets hit by the barrier
			assign statues[1][3:0] = register[12][3:0];    //the barrier is generated based on algorithm in eclipse
			assign statues[0][2:0] = register[13][2:0];   //the plane shoot bullet once, twice, three times...
			
			assign keycode = register[10][7:0];
			assign barrierxsig = register[0][9:0];
			assign barrierysig = register[1][9:0];
			assign barrierx2 = register[2][9:0];
			assign barriery2 = register[3][9:0];
			assign barriery_1 = register[14][9:0];
			//assign bulletx1 = register[4][9:0];
			//assign bullety1 = register[5][9:0];
			//assign bulletx2 = register[6][9:0];
			//assign bullety2 = register[7][9:0];
			assign score = register[15];
			
			
			
	
	engine          e0 (.Reset(reset), .frame_clk(Clk), .VGA_VS(VGA_VS),
							  .statue(statues),
							  .drawX(drawxsig), .drawY(drawysig), .planeX(planexsig), .planeY(planeysig),
							  .barrierX(barrierxsig), .barrierY(barrierysig), .barrierY1(barriery_1),
							  .bulletX_1(bulletx1), .bulletY_1(bullety1),
							  .bulletX_2(bulletx2), .bulletY_2(bullety2),
							  .backgroundX(backgroundX), .backgroundY(backgroundY),
							  .enemyX1(barrierx2), .enemyY1(barriery2),
							  .score(score), .blank(blank),
							  .data(color[23:0]));
							  
	vga_controller  v0 (.Clk(Clk),       // 50 MHz clock
                        .Reset(reset),     // reset signal
                        .hs(VGA_HS),        // Horizontal sync pulse.  Active low
								.vs(VGA_VS),        // Vertical sync pulse.  Active low
								.pixel_clk(VGA_Clk), // 25 MHz pixel clock output
								.blank(blank),     // Blanking interval indicator.  Active low.
								.sync(sync),      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
								.DrawX(drawxsig),     // output horizontal coordinate
								.DrawY(drawysig) );
			
	ball  			p0 ( .Reset(reset), 
							  .frame_clk(Clk),
							  .keycode(keycode),
							  .VGA_VS(VGA_VS),
							  .BallX(planexsig), 
							  .BallY(planeysig));
	bullet         b0 (.Reset(reset), .frame_clk(Clk), .VGA_VS(VGA_VS),
							 .statues(statues[0][1:0]),
							 .keycode(keycode),
							 .planeX(planexsig), .planeY(planeysig),
							 .bulletX(bulletx1), .bulletY(bullety1));
	bullet2         b1 (.Reset(reset), .frame_clk(Clk), .VGA_VS(VGA_VS),
							 .statues(statues[0][1:0]),
							 .keycode(keycode),
							 .planeX(planexsig), .planeY(planeysig),
							 .bulletX(bulletx2), .bulletY(bullety2));
	background		bd0 (.Reset(reset), .frame_clk(Clk), .VGA_VS(VGA_VS),
							 .statues(statues[0][1:0]),
							 .keycode(keycode),
							 .planeX(planexsig), .planeY(planeysig),
							 .score(score),
							 .backgroundX(backgroundX), .backgroundY(backgroundY));
			
			
endmodule