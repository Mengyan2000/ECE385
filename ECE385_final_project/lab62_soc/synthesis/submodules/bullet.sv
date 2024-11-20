module  bullet ( input Reset, frame_clk, VGA_VS,
					input [1:0] statues,
					input [7:0] keycode,
					input [9:0]   planeX, planeY,
               output [9:0]  bulletX, bulletY);
    
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
        //else if (keycode == 8'h2C)
		  //begin
			//	Plane_X_Pos <= Plane_X_Pos;
				//Plane_Y_Pos <= Plane_Y_Pos;
		  //end
        else if (statues == 2'b01)
        begin 

								Plane_X_Motion <= 1;//A
								Plane_Y_Motion<= 0;
				 
				
				 Plane_Y_Pos <= (Plane_Y_Pos + Plane_Y_Motion);  // Update ball position
				 Plane_X_Pos <= (Plane_X_Pos + Plane_X_Motion);
				
				
			
			end  
			else
			begin
					Plane_X_Pos <= planeX+30;
					Plane_Y_Pos <= planeY;
			end
    end
	
       
    assign bulletX = Plane_X_Pos;
   
    assign bulletY = Plane_Y_Pos;
   
    

endmodule

module  bullet2 ( input Reset, frame_clk, VGA_VS,
					input [1:0] statues,
					input [7:0] keycode,
					input [9:0]   planeX, planeY,
               output [9:0]  bulletX, bulletY);
    
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
    begin: Move_Bullet
        if (Reset)  // Asynchronous Reset
        begin 
            Plane_Y_Motion <= 10'd0; //Ball_Y_Step;
				Plane_X_Motion <= 10'd0; //Ball_X_Step;
				Plane_Y_Pos <= 10'd0;
				Plane_X_Pos <= 10'd0;

        end
		  else if (keycode == 8'h28)
		  begin
				Plane_X_Pos <= planeX - 30;
				Plane_Y_Pos <= planeY;
		  end
        else 
        begin 
				 
				 case (statues)
					2'b10 : begin
								Plane_X_Motion <= -1;
								Plane_Y_Motion <= 0;
								end
			   endcase
				 
				
				 Plane_Y_Pos <= (Plane_Y_Pos + Plane_Y_Motion);  // Update ball position
				 Plane_X_Pos <= (Plane_X_Pos + Plane_X_Motion);
				
				
			
		end  
    end
	
       
    assign bulletX = Plane_X_Pos;
   
    assign bulletY = Plane_Y_Pos;
   
    

endmodule
