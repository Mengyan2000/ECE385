module engine
(input Reset, frame_clk, VGA_VS, blank,
 input [3:0] statue[2:0],
 input [9:0] drawX, drawY, planeX, planeY, 
 input [9:0] barrierX, barrierY, bulletX_1, bulletY_1, bulletX_2, bulletY_2, barrierY1, enemyX1, enemyY1,
 input [9:0] backgroundX, backgroundY,
 input [31:0] score,
 output [23:0] data
);

	//create address pointers
	logic [18:0] paddr, saddr, baddr1, baddr2, saddr1;
	logic [18:0] goaddr, eaddr, eaddr2, backdrr;
	logic [18:0] enemy2_addr;
	
	//create 24-bits draw data output
	logic [23:0] plane_draw, bullet_draw1, bullet_draw2, barrier_draw, gameover_draw, barrier_draw1;
	logic [23:0] background;
	logic [23:0] explosion_draw, explosion_draw2;
	logic [23:0] enemy2_draw;
	
	//create x-coor, y-coor address pointer
	logic [17:0] xplane, yplane;
	logic [17:0] xbullet1, ybullet1, xbullet2, ybullet2;
	logic [17:0] xbarrier, ybarrier, barrierX1, epx1, epy1, epx2, epy2;
	logic [17:0] xback, yback;
	logic [17:0] xenemy2, yenemy2;
	
	//Game-over logic
	logic [9:0] go_X, go_Y;
	logic [17:0] xgo, ygo;
	assign go_X = 320;
	assign go_Y = 340;
	
	//create score logic
	parameter [9:0] font_x = 500;
	parameter [9:0] font_y = 10;
	parameter [9:0] font_size_x = 8;
	parameter [9:0] font_size_y = 16;
	parameter [9:0] font_2x = 480;
	parameter [9:0] font_2y = 10;
	parameter [9:0] font_3x = 460;
	parameter [9:0] font_3y = 10;
	parameter [9:0] s = 375;
	parameter [9:0] c = 390;
	parameter [9:0] o = 405;
	parameter [9:0] r = 420;
	parameter [9:0] e = 435;
	parameter [9:0] Your_Y = 150;
	parameter [9:0] Highest_Y = 200;
	logic [10:0] font_addr;
	logic [7:0] font_data;
	logic [31:0] score_store;
	//highest score
	logic [31:0] highest;
	logic load;
	assign barrierX1 = barrierX;
	//assign data = draw;
	//always_ff @ (posedge frame_clk)
	//plane: 60*36 pixels
	always_comb
	begin
	xplane = 0;
	yplane = 0;
	data = 0;
	xbullet1 = 0;
	ybullet1 = 0;
	xbullet2 = 0;
	ybullet2 = 0;
	xbarrier = 0;
	ybarrier = 0;
	epx1 = 0;
	epy1 = 0;
	epx2 = 0;
	epy2 = 0;
	xgo = 0;
	ygo = 0;
	xback = 0;
	yback = 0;
	font_addr = 0;
	xenemy2 = 0;
	yenemy2 = 0;
	if(!blank)
	begin
		xplane = 0;
		yplane = 0;
		data = 0;
		xbullet1 = 0;
		ybullet1 = 0;
		xbullet2 = 0;
		ybullet2 = 0;
		xbarrier = 0;
		ybarrier = 0;
		epx1 = 0;
		epy1 = 0;
		epx2 = 0;
		epy2 = 0;
		xgo = 0;
		ygo = 0;
		xback = 0;
		yback = 0;
		xenemy2 = 0;
		yenemy2 = 0;
	end
	else
	begin	
		if(score != 0)
		begin 
		//background: 550*480
		xback = ((backgroundX + drawX)/5)%110;
		yback = ((backgroundY + drawY)/5 * 110);
		data = background;
		
		if(statue[2][0])   //plane
		begin
			if((drawX+30 >= planeX && drawX-30 < planeX) && (drawY+18 >= planeY && drawY-18 < planeY))
			begin
				if(drawX < planeX && drawY < planeY)
				begin
					xplane = 30 - (planeX - drawX);
					yplane = (18 - (planeY - drawY)) * 60;
				end
				else if(drawX >= planeX && drawY < planeY)
				begin
					xplane = 30 + (drawX - planeX);
					yplane = (18 - (planeY - drawY)) * 60;
				end
				else if(drawX < planeX && drawY >= planeY)
				begin
					yplane = (18 + (drawY-planeY))*60;
					xplane = 30 - (planeX - drawX);
				end
				else
				begin
					yplane = (18 + (drawY-planeY))*60;
					xplane = 30 + (drawX - planeX);
				end
				if((paddr>=9&&paddr<13) || (paddr>=67&&paddr<=75)||(paddr>=125&&paddr<=138)
				||(paddr>185&&paddr<200)||(paddr>242&&paddr<259)||(paddr>301&&paddr<323)||(paddr>600&&paddr<631)
				||(paddr>360&&paddr<385)||(paddr>420&&paddr<446)||(paddr>479&&paddr<508)||(paddr>539&&paddr<570)
				||(paddr>662&&paddr<692)||(paddr>725&&paddr<754)||(paddr>788&&paddr<815)||(paddr>851&&paddr<877)
				||(paddr>914&&paddr<939)||(paddr>977&&paddr<1000)||(paddr>1032&&paddr<1067)||(paddr>1093&&paddr<1098)
				||(paddr>1104&&paddr<1137)||(paddr>1151&&paddr<1198)||(paddr>1211&&paddr<1259)||(paddr>1271&&paddr<1439)
				||(paddr>1450&&paddr<1614)||(paddr>1630&&paddr<1674)||(paddr>1691&&paddr<1724)||(paddr>1755&&paddr<1787)
				||(paddr>1842&&paddr<1848)||(paddr>1962&&paddr<1970)||(paddr>2022&&paddr<2030)||(paddr>2082&&paddr<2087))
					data = plane_draw;			
			end
		end
		if(statue[2][1])   //plane reversed
		begin
			if((drawX+30 >= planeX && drawX-30 < planeX) && (drawY+18 >= planeY && drawY-18 < planeY))
			begin
				if(drawX < planeX && drawY < planeY)
				begin
					xplane = 60-(30 - (planeX - drawX));
					yplane = (18 - (planeY - drawY)) * 60;
				end
				else if(drawX >= planeX && drawY < planeY)
				begin
					xplane = 60-(30 + (drawX - planeX));
					yplane = (18 - (planeY - drawY)) * 60;
				end
				else if(drawX < planeX && drawY >= planeY)
				begin
					yplane = (18 + (drawY-planeY))*60;
					xplane = 60-(30 - (planeX - drawX));
				end
				else
				begin
					yplane = (18 + (drawY-planeY))*60;
					xplane = 60-(30 + (drawX - planeX));
				end
				if((paddr>=9&&paddr<13) || (paddr>=67&&paddr<=75)||(paddr>=125&&paddr<=138)
				||(paddr>185&&paddr<200)||(paddr>242&&paddr<259)||(paddr>301&&paddr<323)||(paddr>600&&paddr<631)
				||(paddr>360&&paddr<385)||(paddr>420&&paddr<446)||(paddr>479&&paddr<508)||(paddr>539&&paddr<570)
				||(paddr>662&&paddr<692)||(paddr>725&&paddr<754)||(paddr>788&&paddr<815)||(paddr>851&&paddr<877)
				||(paddr>914&&paddr<939)||(paddr>977&&paddr<1000)||(paddr>1032&&paddr<1067)||(paddr>1093&&paddr<1098)
				||(paddr>1104&&paddr<1137)||(paddr>1151&&paddr<1198)||(paddr>1211&&paddr<1259)||(paddr>1271&&paddr<1439)
				||(paddr>1450&&paddr<1614)||(paddr>1630&&paddr<1674)||(paddr>1691&&paddr<1724)||(paddr>1755&&paddr<1787)
				||(paddr>1842&&paddr<1848)||(paddr>1962&&paddr<1970)||(paddr>2022&&paddr<2030)||(paddr>2082&&paddr<2087))
					data = plane_draw;			
			end
		end
		if(statue[0][0])			//bullet1: width:50, height:29
		begin
			if((drawX+25 >= bulletX_1 && drawX-25 < bulletX_1) && (drawY+14 >= bulletY_1 && drawY-14 <= bulletY_1))
			begin
				if(drawX < bulletX_1 && drawY < bulletY_1)
				begin
					xbullet1 = 25 - (bulletX_1 - drawX);
					ybullet1 = (14 - (bulletY_1 - drawY)) * 50;
				end
				else if(drawX >= bulletX_1 && drawY < bulletY_1)
				begin
					xbullet1 = 25 + (drawX - bulletX_1);
					ybullet1 = (14 - (bulletY_1 - drawY)) * 50;
				end
				else if(drawX < bulletX_1 && drawY >= bulletY_1)
				begin
					ybullet1 = (14 + (drawY-bulletY_1))*50;
					xbullet1 = 25 - (bulletX_1 - drawX);
				end
				else
				begin
					ybullet1 = (14 + (drawY-bulletY_1))*50;
					xbullet1 = 25 + (drawX - bulletX_1);
				end
				if((baddr1>651&&baddr1<798)||(baddr1>825&&baddr1<998)||(baddr1>1022&&baddr1<1045))
					data = bullet_draw1;
			end
		end
		if(statue[0][1])			//bullet2: width:40, height:13
		begin
			if((drawX+20 >= bulletX_2 && drawX-20 < bulletX_2) && (drawY+6 >= bulletY_2 && drawY-6 <= bulletY_2))
			begin
				if(drawX < bulletX_2 && drawY < bulletY_2)
				begin
					xbullet2 = 20 - (bulletX_2 - drawX);
					ybullet2 = (6 - (bulletY_2 - drawY)) * 40;
				end
				else if(drawX >= bulletX_2 && drawY < bulletY_2)
				begin
					xbullet2 = 20 + (drawX - bulletX_2);
					ybullet2 = (6 - (bulletY_2 - drawY)) * 40;
				end
				else if(drawX < bulletX_2 && drawY >= bulletY_2)
				begin
					ybullet2 = (6 + (drawY-bulletY_2))*40;
					xbullet2 = 20 - (bulletX_2 - drawX);
				end
				else
				begin
					ybullet2 = (6 + (drawY-bulletY_2))*40;
					xbullet2 = 20 + (drawX - bulletX_2);
				end
				if(bullet_draw2 != 0)
					data = bullet_draw2;
			end
		end
		if(statue[1][0])			//barrier: width:47, height:42
		begin
			if((drawX+23 >= barrierX && drawX-23 <= barrierX) && (drawY+21 >= barrierY && drawY-21 < barrierY))
			begin
				if(drawX < barrierX && drawY < barrierY)
				begin
					xbarrier = 23 - (barrierX - drawX);
					ybarrier = (21 - (barrierY - drawY)) * 47;
				end
				else if(drawX >= barrierX && drawY < barrierY)
				begin
					xbarrier = 23 + (drawX - barrierX);
					ybarrier = (21 - (barrierY - drawY)) * 47;
				end
				else if(drawX < barrierX && drawY >= barrierY)
				begin
					ybarrier = (21 + (drawY-barrierY))*47;
					xbarrier = 23 - (barrierX - drawX);
				end
				else
				begin
					ybarrier = (21 + (drawY-barrierY))*47;
					xbarrier = 23 + (drawX - barrierX);
				end
				if((saddr>52&&saddr<61)||(saddr>98&&saddr<109)||(saddr>142&&saddr<156)||(saddr>188&&saddr<203)
				||(saddr>235&&saddr<250)||(saddr>282&&saddr<297)||(saddr>330&&saddr<344)||(saddr>380&&saddr<391)
				||(saddr>428&&saddr<437)||(saddr>692&&saddr<696)||(saddr>738&&saddr<743)||(saddr>783&&saddr<789)
				||(saddr>829&&saddr<836)||(saddr>874&&saddr<884)||(saddr>905&&saddr<931)||(saddr>951&&saddr<977)
				||(saddr>998&&saddr<1024)||(saddr>1045&&saddr<1070)||(saddr>1097&&saddr<1117)||(saddr>1148&&saddr<1163)
				||(saddr>1448&&saddr<1456)||(saddr>1493&&saddr<1504)||(saddr>1539&&saddr<1551)||(saddr>1585&&saddr<1598)
				||(saddr>1631&&saddr<1645)||(saddr>1677&&saddr<1692)||(saddr>1724&&saddr<1739)||(saddr>1773&&saddr<1786)
				||(saddr>1820&&saddr<1833)||(saddr>1868&&saddr<1880)||(saddr>1916&&saddr<1927)||(saddr>1965&&saddr<1973))
					data = barrier_draw;
			end
		end
		if (statue[1][1])
		begin
			if((drawX+23 >= barrierX1 && drawX-23 <= barrierX1) && (drawY+21 >= barrierY1 && drawY-21 < barrierY1))
			begin
				if(drawX < barrierX1 && drawY < barrierY1)
				begin
					xbarrier = 23 - (barrierX1 - drawX);
					ybarrier = (21 - (barrierY1 - drawY)) * 47;
				end
				else if(drawX >= barrierX1 && drawY < barrierY1)
				begin
					xbarrier = 23 + (drawX - barrierX1);
					ybarrier = (21 - (barrierY1 - drawY)) * 47;
				end
				else if(drawX < barrierX && drawY >= barrierY)
				begin
					ybarrier = (21 + (drawY-barrierY1))*47;
					xbarrier = 23 - (barrierX1 - drawX);
				end
				else
				begin
					ybarrier = (21 + (drawY-barrierY1))*47;
					xbarrier = 23 + (drawX - barrierX1);
				end
				if((saddr1>52&&saddr1<61)||(saddr1>98&&saddr1<109)||(saddr1>142&&saddr1<156)||(saddr1>188&&saddr1<203)
				||(saddr1>235&&saddr1<250)||(saddr1>282&&saddr1<297)||(saddr1>330&&saddr1<344)||(saddr1>380&&saddr1<391)
				||(saddr1>428&&saddr1<437)||(saddr1>692&&saddr1<696)||(saddr1>738&&saddr1<743)||(saddr1>783&&saddr1<789)
				||(saddr1>829&&saddr1<836)||(saddr1>874&&saddr1<884)||(saddr1>905&&saddr1<931)||(saddr1>951&&saddr1<977)
				||(saddr1>998&&saddr1<1024)||(saddr1>1045&&saddr1<1070)||(saddr1>1097&&saddr1<1117)||(saddr1>1148&&saddr1<1163)
				||(saddr1>1448&&saddr1<1456)||(saddr1>1493&&saddr1<1504)||(saddr1>1539&&saddr1<1551)||(saddr1>1585&&saddr1<1598)
				||(saddr1>1631&&saddr1<1645)||(saddr1>1677&&saddr1<1692)||(saddr1>1724&&saddr1<1739)||(saddr1>1773&&saddr1<1786)
				||(saddr1>1820&&saddr1<1833)||(saddr1>1868&&saddr1<1880)||(saddr1>1916&&saddr1<1927)||(saddr1>1965&&saddr1<1973))
					data = barrier_draw1;
			end
		end	
		if(statue[2][2])			//great enemy2: 37*4 * 31*4
		begin
			if((drawX+74 >= enemyX1 && drawX-74 < enemyX1) && (drawY+62 >= enemyY1 && drawY-62 <= enemyY1))
			begin
				if(drawX < enemyX1 && drawY < enemyY1)
				begin
					xenemy2 = (74 - (enemyX1 - drawX))/4;
					yenemy2 = (62 - (enemyY1 - drawY))/4 * 37;
				end
				else if(drawX >= enemyX1 && drawY < enemyY1)
				begin
					xenemy2 = (74 + (drawX - enemyX1))/4;
					yenemy2 = (62 - (enemyY1 - drawY))/4 * 37;
				end
				else if(drawX < enemyX1 && drawY >= enemyY1)
				begin
					yenemy2 = (62 + (drawY-enemyY1))/4 *37;
					xenemy2 = (74 - (enemyX1 - drawX))/4;
				end
				else
				begin
					yenemy2 = (62 + (drawY-enemyY1))/4*37;
					xenemy2 = (74 + (drawX - enemyX1))/4;
				end
				if(enemy2_draw != 0)
					data = enemy2_draw;
			end
		end
		
		if(statue[1][2])			//explosion for enemy1 46*46
		begin
			if((drawX+23 >= barrierX && drawX-23 < barrierX) && (drawY+23 >= barrierY && drawY-23 < barrierY))
			begin
				if(drawX < barrierX && drawY < barrierY)
				begin
					epx1 = 23 - (barrierX - drawX);
					epy1 = (23 - (barrierY - drawY)) * 46;
				end
				else if(drawX >= barrierX && drawY < barrierY)
				begin
					epx1 = 23 + (drawX - barrierX);
					epy1 = (23 - (barrierY - drawY)) * 46;
				end
				else if(drawX < barrierX && drawY >= barrierY)
				begin
					epy1 = (23 + (drawY-barrierY))*46;
					epx1 = 23 - (barrierX - drawX);
				end
				else
				begin
					epy1 = (23 + (drawY-barrierY))*46;
					epx1 = 23 + (drawX - barrierX);
				end
				if (explosion_draw != 0)
					data = explosion_draw;
			end
		end	
		
		if(statue[1][3])			//explosion for enemy2
		begin
			if((drawX+23 >= barrierX1 && drawX-23 < barrierX1) && (drawY+23 >= barrierY1 && drawY-23 < barrierY1))
			begin
				if(drawX < barrierX1 && drawY < barrierY1)
				begin
					epx2 = 23 - (barrierX1 - drawX);
					epy2 = (23 - (barrierY1 - drawY)) * 46;
				end
				else if(drawX >= barrierX1 && drawY < barrierY1)
				begin
					epx2 = 23 + (drawX - barrierX1);
					epy2 = (23 - (barrierY1 - drawY)) * 46;
				end
				else if(drawX < barrierX && drawY >= barrierY)
				begin
					epy2 = (23 + (drawY-barrierY1))*46;
					epx2 = 23 - (barrierX1 - drawX);
				end
				else
				begin
					epy2 = (23 + (drawY-barrierY1))*46;
					epx2 = 23 + (drawX - barrierX1);
				end
				if (explosion_draw2 != 0)
					data = explosion_draw2;
			end
		end	
			if(drawX>=s && drawX<(s+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = 8'h53*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-s)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=c && drawX<(c+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = 8'h43*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-c)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=o && drawX<(o+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = 8'h4f*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-o)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=r && drawX<(r+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = 8'h52*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-r)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=e && drawX<(e+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = 8'h45*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-e)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=font_x && drawX<(font_x+font_size_x) && drawY>=font_y && drawY<(font_y+font_size_y))
			begin
				font_addr = (score/10)%10*16+8'h30*16 + (drawY-font_y); //get the first decimal font
				case(font_data[7-(drawX-font_x)])
						1'b1:
							data = 24'hb62309;
						default: ;
				endcase
			end
			if(drawX>=font_2x && drawX<(font_2x+font_size_x) && drawY>=font_2y && drawY<(font_2y+font_size_y))
			begin
				font_addr = (score/100)%10*16+8'h30*16 + (drawY-font_2y);   //get the second decimal
				case(font_data[7-(drawX-font_2x)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
			if(drawX>=font_3x && drawX<(font_3x+font_size_x) && drawY>=font_3y && drawY<(font_3y+font_size_y))
			begin
				
				font_addr = (score/1000)%10*16+8'h30*16 + (drawY-font_y);  //get the third decimal
				case(font_data[7-(drawX-font_3x)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
			if(drawX>=520 && drawX<(520+font_size_x) && drawY>=font_3y && drawY<(font_3y+font_size_y))
			begin
				font_addr = (score%10)*16+8'h30*16 + (drawY-font_3y); //get the first decimal font
				case(font_data[7-(drawX-520)])
						1'b1:
							data = 24'hb62309;
						default: ;
				endcase
			end
		end
		if(statue[0][2])			//Game over: 198 * 154
		begin
			if((drawX+99 >= go_X && drawX-99 <= go_X) && (drawY+77 >= go_Y && drawY-77 < go_Y))
			begin
				if(drawX < go_X && drawY < go_Y)
				begin
					xgo = 99 - (go_X - drawX);
					ygo = (77 - (go_Y - drawY)) * 198;
				end
				else if(drawX >= go_X && drawY < go_Y)
				begin
					xgo = 99 + (drawX - go_X);
					ygo = (77 - (go_Y - drawY)) * 198;
				end
				else if(drawX < go_X && drawY >= go_Y)
				begin
					ygo = (77 + (drawY-go_Y))*198;
					xgo = 99 - (go_X - drawX);
				end
				else
				begin
					ygo = (77 + (drawY-go_Y))*198;
					xgo = 99 + (drawX - go_X);
				end
				data = gameover_draw;
				
			end
			//////////////////////////////////Your score////////////////////////////
			if(drawX>=230 && drawX<(230+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h59*16 + (drawY-Your_Y); //Y: 230*
				case(font_data[7-(drawX-230)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=245 && drawX<(245+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h4f*16 + (drawY-Your_Y); //O: 245*150
				case(font_data[7-(drawX-245)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=260 && drawX<(260+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h55*16 + (drawY-Your_Y); //U
				case(font_data[7-(drawX-260)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=275 && drawX<(275+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h52*16 + (drawY-Your_Y); //R
				case(font_data[7-(drawX-275)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=300 && drawX<(300+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h53*16 + (drawY-Your_Y); //S
				case(font_data[7-(drawX-300)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=315 && drawX<(315+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h43*16 + (drawY-Your_Y); //C
				case(font_data[7-(drawX-315)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=330 && drawX<(330+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h4f*16 + (drawY-Your_Y); //O
				case(font_data[7-(drawX-330)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=345 && drawX<(345+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h52*16 + (drawY-Your_Y); //R
				case(font_data[7-(drawX-345)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=360 && drawX<(360+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = 8'h45*16 + (drawY-Your_Y); //E
				case(font_data[7-(drawX-360)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=415 && drawX<(415+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = (score_store%10)*16+8'h30*16 + (drawY-Your_Y); //get the first decimal font
				case(font_data[7-(drawX-415)])
						1'b1:
							data = 24'hb62309;
						default: ;
				endcase
			end
			if(drawX>=400 && drawX<(400+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				font_addr = (score_store/10)%10*16+8'h30*16 + (drawY-Your_Y);   //get the second decimal
				case(font_data[7-(drawX-400)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
			if(drawX>=385 && drawX<(385+font_size_x) && drawY>=Your_Y && drawY<(Your_Y+font_size_y))
			begin
				
				font_addr = (score_store/100)%10*16+8'h30*16 + (drawY-Your_Y);  //get the third decimal
				case(font_data[7-(drawX-385)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
			////////////////////////////highest score//////////////////////////////////////
			if(drawX>=230 && drawX<(230+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h48*16 + (drawY-Highest_Y); //H: 230*200
				case(font_data[7-(drawX-230)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=245 && drawX<(245+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h49*16 + (drawY-Highest_Y); //I: 245*150
				case(font_data[7-(drawX-245)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=260 && drawX<(260+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h47*16 + (drawY-Highest_Y); //G
				case(font_data[7-(drawX-260)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=275 && drawX<(275+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h48*16 + (drawY-Highest_Y); //H
				case(font_data[7-(drawX-275)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=290 && drawX<(290+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h45*16 + (drawY-Highest_Y); //E
				case(font_data[7-(drawX-290)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=305 && drawX<(305+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h53*16 + (drawY-Highest_Y); //S
				case(font_data[7-(drawX-305)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=320 && drawX<(320+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = 8'h54*16 + (drawY-Highest_Y); //T
				case(font_data[7-(drawX-320)])
						1'b1:
							data = 24'hf0e608;
						default: ;
				endcase
			end
			if(drawX>=370 && drawX<(370+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = (highest/1000)%10*16+8'h30*16 + (drawY-Highest_Y); //get the first decimal font
				case(font_data[7-(drawX-370)])
						1'b1:
							data = 24'hb62309;
						default: ;
				endcase
			end
			if(drawX>=415 && drawX<(415+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = (highest%10)*16+8'h30*16 + (drawY-Highest_Y); //get the first decimal font
				case(font_data[7-(drawX-415)])
						1'b1:
							data = 24'hb62309;
						default: ;
				endcase
			end
			if(drawX>=400 && drawX<(400+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				font_addr = (highest/10)%10*16+8'h30*16 + (drawY-Highest_Y);   //get the second decimal
				case(font_data[7-(drawX-400)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
			if(drawX>=385 && drawX<(385+font_size_x) && drawY>=Highest_Y && drawY<(Highest_Y+font_size_y))
			begin
				
				font_addr = (highest/100)%10*16+8'h30*16 + (drawY-Highest_Y);  //get the third decimal
				case(font_data[7-(drawX-385)])
						1'b1 :
							data = 24'hb62309;
						default : ;
				endcase
			end
		end
	end	
	end
	always_comb
	begin
			if(score > highest)
				load = 1;
			else 
				load = 0;
	end
	assign backdrr = xback + yback;
	assign paddr = xplane+yplane;
	assign baddr1 = xbullet1+ybullet1;
	assign baddr2 = xbullet2+ybullet2;
	assign saddr = xbarrier + ybarrier;
	assign goaddr = xgo + ygo;
	assign saddr1= xbarrier + ybarrier;
	assign eaddr = epx1+epy1;
	assign eaddr2 = epx2+epy2;
	assign enemy2_addr = xenemy2 + yenemy2;
	
	frameRAM_P   p0(.read_address(paddr),
							.Clk(frame_clk),
							.data_Out(plane_draw)); 
	frameRAM_b0  b0(.read_address(baddr1),
						 .Clk(frame_clk),
						 .data_Out(bullet_draw1));	
						 
	frameRAM_b1  b1(.read_address(baddr2),
						 .Clk(frame_clk),
						 .data_Out(bullet_draw2));
						 
	frameRAM_Barrier   s0( .read_address(saddr),
								  .Clk(frame_clk),
								  .data_Out(barrier_draw));
	frameRAM_Barrier1   s1( .read_address(saddr1),
								  .Clk(frame_clk),
								  .data_Out(barrier_draw1));
	frameRAM_GO  go(.read_address(goaddr),
						 .Clk(frame_clk),
						 .data_Out(gameover_draw));
	frameRAM_EP  ex(.read_address(eaddr),
						 .Clk(frame_clk),
						 .data_Out(explosion_draw));
	frameRAM_EP1  ex1(.read_address(eaddr2),
						 .Clk(frame_clk),
						 .data_Out(explosion_draw2));
	frameRAM_bkgrd  back0(.read_address(backdrr),
								  .Clk(frame_clk),
								  .data_Out(background));
	frameRAM_enemy2  enemy2(.read_address(enemy2_addr),
								  .Clk(frame_clk),
								  .data_Out(enemy2_draw));
								  
	font_rom 		font0(.addr(font_addr),
								.data(font_data)
								);
	reg_score      high_score(.clk(frame_clk), .load(load),
									  .reset(Reset),
									  .score(score),
									  .q(highest));
	reg_score     your_score(.clk(frame_clk), .load(!statue[0][2]), .reset(Reset),
									 .score(score),
									 .q(score_store));
						 
endmodule

module reg_score (input clk, load, reset,
						input [31:0] score,
						output [31:0] q);
	always_ff @ (posedge clk)
	begin 
			if(reset)
				q <= 0;
			else if (load)
				q <= score;
			else
				q <= q;
	end
endmodule