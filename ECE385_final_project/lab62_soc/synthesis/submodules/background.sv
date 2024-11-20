module  background ( input Reset, frame_clk, VGA_VS,
					input [1:0] statues,
					input [7:0] keycode,
					input [31:0] score,
					input [9:0]   planeX, planeY,
               output [9:0]  backgroundX, backgroundY);
    
    logic [9:0] Plane_X_Pos, Plane_X_Motion, Plane_Y_Pos, Plane_Y_Motion, Plane_X_Size, Plane_Y_Size;
	 
    parameter [9:0] Plane_X_Center=150;  // Center position on the X axis
    parameter [9:0] Plane_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Plane_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Plane_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Plane_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Plane_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bullet_X_Step=1;      // Step size on the X axis
    parameter [9:0] bullet_Y_Step=1;      // Step size on the Y axis

    assign Plane_X_Size = 30;  
	 assign Plane_Y_Size = 18;// assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge VGA_VS )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Plane_Y_Motion <= 10'd0; //Ball_Y_Step;
				Plane_X_Motion <= 10'd0; //Ball_X_Step;
				Plane_Y_Pos <= 10'd0;
				Plane_X_Pos <= 10'd0;

        end
        else if (score != 0)
        begin 

								Plane_X_Motion <= 1;  //background move forward
								Plane_Y_Motion<= 0;
				 
				
				 Plane_Y_Pos <= (Plane_Y_Pos + Plane_Y_Motion);  // Update ball position
				 Plane_X_Pos <= (Plane_X_Pos + Plane_X_Motion) % (550);  //make the moving background loop back
				
				
			
			end  
			else
			begin
					Plane_X_Pos <= 0;
					Plane_Y_Pos <= 0;
			end
    end
       
    assign backgroundX = Plane_X_Pos;
   
    assign backgroundY = Plane_Y_Pos;
   
    

endmodule
