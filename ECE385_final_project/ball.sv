//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, VGA_VS,
					input [7:0] keycode,
               output [9:0]  BallX, BallY);
    
    logic [9:0] Plane_X_Pos, Plane_X_Motion, Plane_Y_Pos, Plane_Y_Motion, Plane_X_Size, Plane_Y_Size;
	 
    parameter [9:0] Plane_X_Center=150;  // Center position on the X axis
    parameter [9:0] Plane_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Plane_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Plane_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Plane_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Plane_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Plane_X_Step=1;      // Step size on the X axis
    parameter [9:0] Plane_Y_Step=1;      // Step size on the Y axis

    assign Plane_X_Size = 30;  
	 assign Plane_Y_Size = 18;// assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge VGA_VS )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Plane_Y_Motion <= 10'd0; //Ball_Y_Step;
				Plane_X_Motion <= 10'd0; //Ball_X_Step;
				Plane_Y_Pos <= Plane_Y_Center;
				Plane_X_Pos <= Plane_X_Center;

        end
           
        else 
        begin 
				 
				 case (keycode)
					8'h04 : begin

								Plane_X_Motion <= -1;//A
								Plane_Y_Motion<= 0;
							  end
					        
					8'h07 : begin
								
					        Plane_X_Motion <= 1;//D
							  Plane_Y_Motion <= 0;
							  end

							  
					8'h16 : begin

					        Plane_Y_Motion <= 1;//S
							  Plane_X_Motion <= 0;
							 end
							  
					8'h1A : begin
					        Plane_Y_Motion <= -1;//W
							  Plane_X_Motion <= 0;
							 end	  
					default: begin
							  Plane_Y_Motion <= 0;
							  Plane_X_Motion <= 0;
							  end
			   endcase
				if ( (Plane_Y_Pos + Plane_Y_Size) >= Plane_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Plane_Y_Motion <= (~ (Plane_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Plane_Y_Pos - Plane_Y_Size) <= Plane_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Plane_Y_Motion <= Plane_Y_Step;
					  
				  else if ( (Plane_X_Pos + Plane_X_Size) >= Plane_X_Max )  // Ball is at the Right edge, BOUNCE!
					  Plane_X_Motion <= (~ (Plane_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Plane_X_Pos - Plane_X_Size) <= Plane_X_Min )  // Ball is at the Left edge, BOUNCE!
					  Plane_X_Motion <= Plane_X_Step;
					  
				 //else 
					  //Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 
				
				 Plane_Y_Pos <= (Plane_Y_Pos + Plane_Y_Motion);  // Update ball position
				 Plane_X_Pos <= (Plane_X_Pos + Plane_X_Motion);
				
				
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
	
       
    assign BallX = Plane_X_Pos;
   
    assign BallY = Plane_Y_Pos;
   
    

endmodule
