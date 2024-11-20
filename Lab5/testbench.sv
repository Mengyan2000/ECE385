module testbench();

timeunit 1ns;

timeprecision 1ns;

//instantiate some input logic
logic Clk = 0;
logic [9:0] SW, LED;
logic CE, UB, LB, OE, WE;
logic Continue, Run;
logic [15:0] ADDR;
logic [2:0] nzp;

logic [6:0] HEX0,
		 HEX1,
		 HEX2,
		 HEX3;

logic [15:0] MAR, MDR, IR, PC, R0, R1, my_BUS, HEXdata;
 //I wrote asterisk bc Campuswire
//creates italics with an asterisk

//Inside the TopLevel module, there will be
//the Hi module instantiated as
//Hi Hi2(.asterisk);

slc3_testtop slc3(.*);

assign MAR = slc3.slc.d0.MAR;
assign MDR = slc3.slc.d0.MDR;
assign IR = slc3.slc.d0.IR;
assign PC = slc3.slc.d0.PC;
assign R0 = slc3.slc.d0.file.reg0;
assign R1 = slc3.slc.d0.file.reg1;
assign nzp = slc3.slc.d0.NZP;
assign my_BUS = slc3.slc.d0.my_BUS;
assign HEXdata = slc3.slc.memory_subsystem.hex_data;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 
initial begin: TEST_VECTORS
	// reset// //I/O test 1
/*SW = 10'b0000000011;   
Run = 0;
Continue = 0;
#5 
#5 Run = 0;
Continue = 1;
#30 Run = 1;
 Continue = 1;	   
#100 SW = 10'b0000000101;// Second test
	Continue = 0;
	Run = 1;

	#50 SW = 10'b0101010111;
	#50 SW = 10'b0000000000;
	#50 SW = 10'b1111111111;*/
/*	
//I/O test 2	
SW = 10'b0000000110;   
Run = 0;
Continue = 0;
#10 Continue = 1;
Run = 0;
#30 Continue = 1;
Run = 1;
#50 SW = 10'b0000001010;// Second test
	Continue = 0;
	Run = 1;	
#30 Continue = 1;
Run = 1;
//third test, HEx=000f
#60 SW = 10'b0000001111;
Continue = 0;
Run = 1;
#30 Continue = 1;
Run = 1;
//fourth input, HEX = 0101
#60 SW = 10'b0100000001;
Continue = 0;
Run = 1;
#30 Continue = 1;
Run = 1;
//fifth test HEX = 008C
#60 SW = 10'b0010001100;
Continue = 0;
Run = 1;*/
/*//self-modifying test
SW = 10'b0000001011;    //000B
Run = 0;
Continue = 0;
#10 Continue = 1;
Run = 0;
#30 Continue = 1;
Run = 1;
#40 SW = 10'b1111111111;// Second test 03FF
	Continue = 0;
	Run = 1;	
#30 Continue = 1;
Run = 1;
//third test, HEx=020f
#100 SW = 10'b1000001111;
Continue = 0;
Run = 1;
#30 Continue = 1;
Run = 1;
//fourth input, HEX = 0101
#100 SW = 10'b0100000001;
Continue = 0;
Run = 1;
#30 Continue = 1;
Run = 1;
#30 Continue = 1;
Run = 1;*/
/*
//XOR test
SW = 10'b0000010100;    //0014
Run = 0;
Continue = 0;
#10 Continue = 1; //trigger run
Run = 0;
#30 Continue = 1;
Run = 1;

#50 SW = 10'b1110110001;
	 Continue = 0;
	 Run = 1;

#20 Continue = 1;
	Run = 1;

#60 SW = 10'b1000001111;
	 Continue = 0;
	 Run = 1;
#20 Continue = 1;
Run = 1;
#180 Continue = 0;
Run = 1;
#20 Continue = 1;
Run = 1;*/
/*	 
//Multiplication test
SW = 10'b0000110001;    //0031
Run = 0;
Continue = 0;
#10 Continue = 1; //trigger run
Run = 0;
#30 Continue = 1;
Run = 1;

#100 SW = 10'b0000001010; //000A
	  Continue = 0;
	  Run = 1;
#20 Continue = 1;
Run = 1;

#60 SW = 10'b0000000101; //0005
	 Continue = 0;
	 Run = 1;
	 
#20 Continue = 1;
	 Run = 1;
	 
#140 Continue = 0;
	 Run = 1;
	 */
	 
//Sort test
SW = 10'b0001011010;    //005A
Run = 0;
Continue = 0;
#10 Continue = 1; //trigger run
Run = 0;
#30 Continue = 1;
Run = 1;

#100 Continue = 0; Run = 1;
	 SW = 10'b0000000011; //display
#20 Continue = 1;
    Run = 1;
#150 Continue = 0; Run = 1; //1
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //2
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //3
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //4
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //5
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //6
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //7
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //8
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //9
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //10
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //11
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //12
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //13
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //14
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //15
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //16
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //17
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1;
	 SW = 10'b0000000010; //sort
#50 Continue = 1; Run = 1;
#26000 Continue = 0; Run = 1;
	SW = 10'b0000000011; //display //1
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //2
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //3
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //4
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //5
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //6
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //7
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //8
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //9
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //10
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //11
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //12
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //13
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //14
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //15
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //16
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1; //17
 #50 Continue = 1; Run = 1;
#150 Continue = 0; Run = 1;
	 
end
endmodule