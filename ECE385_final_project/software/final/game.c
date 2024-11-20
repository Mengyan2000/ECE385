
#include "game.h"

volatile unsigned int * AES_PTR = (unsigned int *) 0x000000c0;


void init_game() {
	//printf("AES_PTR[11] %x", AES_PTR[11]);
	//AES_PTR[11] = 0;
	AES_PTR[0] = 500;
	AES_PTR[1] = 400;
	AES_PTR[11] = 1;     //plane's signal
	AES_PTR[13] = 0;     //bullet & gameover's signal
	AES_PTR[12] = 0;     //barrier's signal
	AES_PTR[15] = 1;
}
void updateGame(char keycode) {
	AES_PTR[10] = keycode;

	//----------------------GAME MODE-----------------------
	if (AES_PTR[15] >= 1) {
		if (keycode == KEY_SPACE) {
			AES_PTR[13] = AES_PTR[13] | 0x01;
			//printf("bullet1 signal is %x", AES_PTR[13]);
		}
		if (keycode == KEY_ENTER) {
			AES_PTR[13] = AES_PTR[13] | 0x02;
			//printf("bullet2 signal is %x", AES_PTR[13]);
		}
		//printf("bulletx is %x", AES_PTR[6]);
		if (keycode == KEY_TAB) {
			AES_PTR[11] &= ~1;
			AES_PTR[11] |= 2;
		}
		else if (keycode == KEY_CAPSLOCK) {
			AES_PTR[11] &= ~2;
			AES_PTR[11] = 1;
		}

		////test if bullet1 is bouncing the edge. Then make it disappear
		if (AES_PTR[4] + 26 >= 0x250) {
			AES_PTR[13] = AES_PTR[13] & ~1;
			//printf("after going off the screen %x \n", AES_PTR[13]);
		}

		////test if bullet2 is bouncing the edge. Then make it disappear
		if (AES_PTR[6] - 26 <= 25 || AES_PTR[6] > 0x370) {
				AES_PTR[13] = AES_PTR[13] & ~2;
				//printf("after going off the screen %x \n", AES_PTR[13]);
		}
		//---------------------set up enemy's movement------------------------------------
		if (AES_PTR[12] > 0) {
			printf("inside movement: %x", AES_PTR[12]);
			if (AES_PTR[0] < AES_PTR[8]) {
				AES_PTR[0] = AES_PTR[0] - 10;
			}
			if (AES_PTR[0] >= AES_PTR[8]) {
				//AES_PTR[0] = AES_PTR[0]-(AES_PTR[0] - AES_PTR[8])/10;
				if (AES_PTR[1] < AES_PTR[9]) {
					AES_PTR[1] = AES_PTR[1] +(AES_PTR[9] - AES_PTR[1])/30;
				}
				if (AES_PTR[1] >= AES_PTR[9]) {
					AES_PTR[1] = AES_PTR[1]-(AES_PTR[1] - AES_PTR[9])/30;
				}
				if (AES_PTR[14] < AES_PTR[9]) {
					AES_PTR[14] = AES_PTR[14] +(AES_PTR[9] - AES_PTR[14])/10;
				}
				if (AES_PTR[14] >= AES_PTR[9]) {
					AES_PTR[14] = AES_PTR[14]-(AES_PTR[14] - AES_PTR[9])/10;
				}
				AES_PTR[0] = AES_PTR[0] - 10;
			}
			//when barrier goes off the edge, make them disappear
			if (AES_PTR[0] - 30 < 10) {
				AES_PTR[12] = 0;
			}
		}
		int count = 0;
		if ((AES_PTR[11]&4) == 4) {
			AES_PTR[2] -= 4;

		}
		if (AES_PTR[2] - 62 < 10) {
			AES_PTR[11] &= ~4;
			AES_PTR[15] -= 100;
		}
		////invoke another two barrier when all died..
		if ((AES_PTR[11] &4) != 4 && (AES_PTR[12] == 0)) {
			AES_PTR[12] = AES_PTR[12] | 0x03;
			AES_PTR[0] = 580;
			AES_PTR[1] = AES_PTR[9]+100;
			AES_PTR[14] = AES_PTR[1] - 200;  //second barrier's Y coordinate
			//printf("another barrier coming");
		}

		//invoke greater enemy
		if (AES_PTR[15] > 500 && (AES_PTR[11]&4) != 4 && AES_PTR[15] < 600) {
			AES_PTR[11] |= 4;
			AES_PTR[2] = 550;
			AES_PTR[3] = 200;
		}
		//printf("AES_PTR[11] %x  \n", AES_PTR[11]);
//-----------------------------#########////////////////////////////////////////////////////
//------------bullet hit enemy, BOOM!!!! point's up!////////////////////////////////////////
		if((AES_PTR[12] & 4) == 4) {
				AES_PTR[12] &= ~4;

		}
		if((AES_PTR[12] & 8) == 8)
				AES_PTR[12] &= ~8;
		if((AES_PTR[11] &5120) == 5120) {  //bullet hit enemy2 5 times
			printf("hitting great 5 times: %x \n", AES_PTR[10]);
			AES_PTR[11] &= ~4;
			AES_PTR[15] += 400;
			AES_PTR[11] &= ~5120;
		}
		if (AES_PTR[13] != 0 && AES_PTR[12]) {
			int i;
			//the first bullet hits planes
			if (AES_PTR[4] + 0x30 >= AES_PTR[0] && AES_PTR[4] - 0x30 <= AES_PTR[0]) {
				if (AES_PTR[5] <= AES_PTR[1]+40 && AES_PTR[5]+40 >= AES_PTR[1]) {
					AES_PTR[12] &= ~1;
					AES_PTR[12] |= 4;
					AES_PTR[15] += 50;
					AES_PTR[13] = AES_PTR[13] & ~1;    //bullet disappear
					//printf("bullet: %x", AES_PTR[13]);
					//printf("barrier: %x", AES_PTR[12]);
				} else if (AES_PTR[5] <= AES_PTR[14]+40 && AES_PTR[5]+40 >= AES_PTR[14]) {
						AES_PTR[12] &= ~2;
						AES_PTR[15] += 50;
						AES_PTR[12] |= 8;
						AES_PTR[13] = AES_PTR[13] & ~1;    //bullet disappear
						//printf("bullet: %x", AES_PTR[13]);
						//printf("barrier: %x", AES_PTR[12]);//make the explosion disappear
				}
			}
			//the second bullet
			if (AES_PTR[6] + 0x35 >= AES_PTR[0] && AES_PTR[6] - 0x35 <= AES_PTR[0]) {
				if (AES_PTR[7] <= AES_PTR[1]+0x28 && AES_PTR[7]+0x28 >= AES_PTR[1]) {
					AES_PTR[12] &= ~1;  //make barrier1 disappear
					AES_PTR[15] += 50;
					AES_PTR[12] |= 4;
					AES_PTR[13] &= ~2;  //make bullet2 disappear
				} else if(AES_PTR[7] <= AES_PTR[14]+0x23 && AES_PTR[7]+0x23 >= AES_PTR[14]) {
					AES_PTR[12] &= ~2;
					AES_PTR[15] += 50;
					AES_PTR[12] |= 8;
					AES_PTR[13] &= ~2;
				}
			}

		}
		if ((AES_PTR[11] &4) ==4) {
			if (AES_PTR[4] + 37*2 >= AES_PTR[2] && AES_PTR[4] - 37*2 <= AES_PTR[2]) {
			if (AES_PTR[5] <= AES_PTR[3]+62 && AES_PTR[5]+62 >= AES_PTR[3]) {
					AES_PTR[11] += 1024;   //don't interfere with keycode AES_PTR[10][7:0]
					AES_PTR[13] &= ~1;
					printf("bullet1 hit big: %x  \n", AES_PTR[11]);
				}
			}
			if (AES_PTR[6] + 74 >= AES_PTR[0] && AES_PTR[6] - 74 <= AES_PTR[0]) {  //the second bullet
				if (AES_PTR[7] <= AES_PTR[1]+62 && AES_PTR[7]+62 >= AES_PTR[1]) {
					AES_PTR[11] += 1024;
					AES_PTR[13] &= ~2;
					printf("bullet2 hit big: %x  \n", AES_PTR[11]);
				}
			}
		}

	}
	//---------------------------------GAME OVER------------------------------------------------
	if ((AES_PTR[12]&1) == 1 && AES_PTR[0] + 40 > AES_PTR[8] && AES_PTR[0] - 40 < AES_PTR[8]
				&& AES_PTR[1] -35 < AES_PTR[9] && AES_PTR[1]+35 > AES_PTR[9]) {
		AES_PTR[11] = 0;
		AES_PTR[12] = 0;
		AES_PTR[13] = 4;
		AES_PTR[15] = 0;
	} else if ((AES_PTR[12]&2) == 2 && (AES_PTR[0] + 40) > AES_PTR[8] && AES_PTR[0] - 40 < AES_PTR[8]
					&& AES_PTR[14] -35 < AES_PTR[9] && AES_PTR[14]+35 > (AES_PTR[9])) {
		AES_PTR[11] = 0;
		AES_PTR[12] = 0;
		AES_PTR[13] = 4;
		AES_PTR[15] = 0;

	} else if ((AES_PTR[11]&4) == 4 && (AES_PTR[2] + 62) > AES_PTR[8] && AES_PTR[2] - 62 < AES_PTR[8]
					&& AES_PTR[3] -74 < AES_PTR[9] && AES_PTR[3]+74 > (AES_PTR[9])) {
		AES_PTR[11] = 0;
		AES_PTR[15] -= 500;
		AES_PTR[12] = 0;
		AES_PTR[13] = 4;
		AES_PTR[15] = 0;

	}
	printf("point up-to-date: %d, barrier signal is: %x  \n", AES_PTR[15], AES_PTR[12]);

}


