/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x000000c0;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void keyExpansion(unsigned char* prevKey, unsigned char* newKey)
{
	unsigned char temp[4];
	int i;
	for (i = 0; i < 16; i++) {
		newKey[i] = prevKey[i];
		//printf("copying first 16 keys %x \n", newKey[i]);
	}
	int index = 16;

	while (index < 176) {

		for (i = 0; i < 4; i++) {
			temp[i] = newKey[i+index-4];
			//printf("temp[i] = %x  \n", newKey[i+index-4]);
		}
		if (index%16 == 0) {
			unsigned char copy[4];
			copy[0] = temp[1];
			copy[1] = temp[2];
			copy[2] = temp[3];
			copy[3] = temp[0];
			//printf("temp0 %x \n", copy[1]);
			for (i = 0; i < 4; i++) {
				temp[i] = aes_sbox[copy[i]];
				//printf("after SubByte %x %x \n", temp[i], copy[i]);
			}
			unsigned char rcon = (Rcon[index/16] >> 24);
			//printf("rcon is %x  \n", rcon);
			temp[0] = temp[0] ^ rcon;
		}
		for (i = 0; i < 4; i++) {
			newKey[index] = temp[i] ^ newKey[index-16];
			//printf("new Key after %x %x %x \n", newKey[index-16], newKey[index], i);
			index++;
		}
	}



}

void AddRoundKey(unsigned char* state, unsigned char* roundKey) {
	for (int i = 0; i < 16; i++) {
		state[i] = state[i] ^ roundKey[i];
	}
}

void SubBytes(unsigned char* state)
{
	int i;
	for (i = 0; i < 16; i++) {
		state[i] = aes_sbox[state[i]];
	}
}

void ShiftRows(unsigned char* state)
{
	unsigned char temp[16];

	temp[0] = state[0];
	temp[1] = state[5];
	temp[2] = state[10];
	temp[3] = state[15];
	temp[4] = state[4];
	temp[5] = state[9];
	temp[6] = state[14];
	temp[7] = state[3];
	temp[8] = state[8];
	temp[9] = state[13];
	temp[10] = state[2];
	temp[11] = state[7];
	temp[12] = state[12];
	temp[13] = state[1];
	temp[14] = state[6];
	temp[15] = state[11];

	for(int i = 0; i< 16; i++) {
		state[i] = temp[i];
	}
}

void Mixcolumns(unsigned char* state)
{
	unsigned char temp[16];
	int i;
		temp[0] = (unsigned char)(gf_mul[state[0]][0] ^ gf_mul[state[1]][1] ^ state[2] ^ state[3]);
		//printf("calculating gf_mul %x  \n", gf_mul[state[0]][0]);
		temp[1] = (unsigned char)(state[0] ^ gf_mul[state[1]][0] ^ gf_mul[state[2]][1] ^ state[3]);
		temp[2] = (unsigned char)(state[0] ^ state[1] ^ gf_mul[state[2]][0] ^ gf_mul[state[3]][1]);
		temp[3] = (unsigned char)(gf_mul[state[0]][1] ^ state[1] ^ state[2] ^ gf_mul[state[3]][0]);

		temp[4] = (unsigned char)(gf_mul[state[4]][0] ^ gf_mul[state[5]][1] ^ state[6] ^ state[7]);
		temp[5] = (unsigned char)(state[4] ^ gf_mul[state[5]][0] ^ gf_mul[state[6]][1] ^ state[7]);
		temp[6] = (unsigned char)(state[4] ^ state[5] ^ gf_mul[state[6]][0] ^ gf_mul[state[7]][1]);
		temp[7] = (unsigned char)(gf_mul[state[4]][1] ^ state[5] ^ state[6] ^ gf_mul[state[7]][0]);

		temp[8] = (unsigned char)(gf_mul[state[8]][0] ^ gf_mul[state[9]][1] ^ state[10] ^ state[11]);
		temp[9] = (unsigned char)(state[8] ^ gf_mul[state[9]][0] ^ gf_mul[state[10]][1] ^ state[11]);
		temp[10] = (unsigned char)(state[8] ^ state[9] ^ gf_mul[state[10]][0] ^ gf_mul[state[11]][1]);
		temp[11] = (unsigned char)(gf_mul[state[8]][1] ^ state[9] ^ state[10] ^ gf_mul[state[11]][0]);

		temp[12] = (unsigned char)(gf_mul[state[12]][0] ^ gf_mul[state[13]][1] ^ state[14] ^ state[15]);
		temp[13] = (unsigned char)(state[12] ^ gf_mul[state[13]][0] ^ gf_mul[state[14]][1] ^ state[15]);
		temp[14] = (unsigned char)(state[12] ^ state[13] ^ gf_mul[state[14]][0] ^ gf_mul[state[15]][1]);
		temp[15] = (unsigned char)(gf_mul[state[12]][1] ^ state[13] ^ state[14] ^ gf_mul[state[15]][0]);
		for (i = 0; i < 16; i++) {
			state[i] = temp[i];
			//printf("printing MixColumn %x   \n", temp[i]);
		}
}
/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	//printf("start encypting... \n");
	// Implement this function
		int round = 9;
		int i;
		unsigned char round_key_arr[176];
		unsigned char state_arr[16];
		unsigned char* state = state_arr;
		unsigned char* round_key = round_key_arr;
		unsigned char key_arr[16];
		for (i = 0; i < 16; i++)
		{
			state[i] = charsToHex(msg_ascii[2*i], msg_ascii[2*i+1]);
			key_arr[i] = charsToHex(key_ascii[2*i], key_ascii[2*i+1]);
			//printf("encrypt key %x \n", key_arr[i]);
		}

		keyExpansion(key_arr, round_key);

		//printf("%x %x\n", state[0], state[15]);

		AddRoundKey(state, round_key);
		//printf("initial roundkey %x %x %x %x  \n", round_key[0], round_key[3], round_key[8], round_key[15]);
		//printf("roundkey: %x %x \n", state[3], state[15]);

		for (i = 0; i < round; i++)
		{
			round_key += 16;

			SubBytes(state);

			ShiftRows(state);

			Mixcolumns(state);


			AddRoundKey(state, round_key);
		}
		SubBytes(state);
		ShiftRows(state);
		round_key += 16;
		AddRoundKey(state, round_key);
		/*printf("\nThe last round_key is: \n");
		for(i = 0; i < 16; i++){
			printf("%hhx", round_key[i]);
		}*/
		for (i = 0; i < 4; i++) {

			msg_enc[i] = (state[4*i]<<24)+(state[4*i+1]<<16)+(state[4*i+2]<<8)+state[4*i+3];
			key[i] = (key_arr[4*i]<<24)+(key_arr[4*i+1]<<16)+(key_arr[4*i+2]<<8) +key_arr[4*i+3];
			//printf("%x %x \n", msg_enc[i], key[i]);
		}

}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
	int i;

	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];



	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];
	//printf("msg_enc3 is %x  \n", AES_PTR[7]);
	AES_PTR[14] = 1;
	while (AES_PTR[15] == 0);


	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
	AES_PTR[14] = 0;
	//printf("decrypted message 3 is %x", AES_PTR[8]);

}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
