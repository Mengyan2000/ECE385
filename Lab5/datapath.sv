module datapath  (input logic         Clk,LD_BEN, LD_CC, LD_REG, LD_LED,
                  input logic         GatePC, GateMDR, GateALU, GateMARMUX, SR2MUX, ADDR1MUX, MARMUX,
						input logic         MIO_EN, 
					   input logic         LD_MAR, LD_MDR, LD_IR, LD_PC, DRMUX, SR1MUX,
						input logic [1:0]   PCMUX, ADDR2MUX, ALUK,
						input logic         Reset, Continue, Run,
						output logic [9:0] LED,
						//output logic [3:0]   HEX0, HEX1, HEX2, HEX3,
                  output logic [15:0] MAR, MDR, IR,
						output logic        BEN,
						input logic [15:0]  MDR_In);
						
		logic [15:0] PC, PC_Out, my_BUS, data_ALU, MDR_Out, marmuxadd, mdr, SR1_Out, SR2_Out, sr2, imme5, addr2, addr1;
		logic [2:0] DR, SR1, SR2, NZP;
		assign mdr = MDR;
		logic BEN_In;
		
		always_comb 
		begin
			if (LD_LED)
				LED = IR[9:0];
			else LED = 10'b0;
	
		end
		assign SR2 = IR[2:0];
		//select the BUS data using four selection and gate signals
		MUX4        busSelect(.GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), .GateMARMUX(GateMARMUX), 
									 .PC(PC), .ALU(data_ALU), .MDR_Out(MDR), .MARMUX(marmuxadd), .my_BUS(my_BUS));
		//set MAR <- BUS
		shiftreg     s_MAR(.Clk(Clk), .Load(LD_MAR), .Reset(Reset), .D(my_BUS), .Q(MAR));
		
		
		//set PC <- PC + 1 ; PC <- marmuxadd
		shiftreg		s_PC(.Clk(Clk), .Load(LD_PC), .Reset(Reset), .D(PC_Out), .Q(PC));
		MUX_pc         storePC(.PCMUX(PCMUX), .PC_In(PC), .my_BUS(my_BUS), .marmuxadd(marmuxadd), .PC_Out(PC_Out));		
		
		
		//MDR <- M(MAR)
		MUX_2     #(16) MDR_C(.S(MIO_EN), .A(my_BUS), .B(MDR_In), .Q(MDR_Out));
		shiftreg    s_MDR(.Clk(Clk), .Load(LD_MDR), .Reset(Reset), .D(MDR_Out), .Q(MDR));
		
		
		//IR <- MDR
		shiftreg    s_IR(.Clk(Clk), .Load(LD_IR), .Reset(Reset), .D(my_BUS), .Q(IR));
		
		//send signal to all MUXes in reg_file
		MUX_2      #(3) dr(.S(DRMUX), .B(3'b111), .A(IR[11:9]), .Q(DR));
		MUX_2      #(3) sr1(.S(SR1MUX), .A(IR[11:9]), .B(IR[8:6]), .Q(SR1));
		ALU         aluk(.ALUK(ALUK), .SR2(SR2_Out), .SR1(SR1_Out), .ALU_Out(data_ALU));
		
		
		//register file
		reg_file    file(.LD_REG(LD_REG), .Clk(Clk), .reset(Reset), .SR2_addr(SR2), .SR1_addr(SR1), .DR_addr(DR), 
							  .my_BUS(my_BUS), .SR2_Out(sr2), .SR1_Out(SR1_Out));
		MUX_2      SR2_Select(.S(SR2MUX), .A(sr2), .B(16'(signed'(IR[4:0]))), .Q(SR2_Out));
		
		//addrmux
		ADDR2        addr2mux(.ADDR2MUX(ADDR2MUX), .a(16'h000), .b(16'(signed'(IR[5:0]))), .c(16'(signed'(IR[8:0]))), .d(16'(signed'(IR[10:0]))), .Q(addr2));
		MUX_2        #(16)  addr1mux(.S(ADDR1MUX), .B(SR1_Out), .A(PC), .Q(addr1));
		assign marmuxadd = addr1 + addr2;
		
		//ben
		assign BEN_In = (IR[11]&NZP[2]) | (IR[10]&NZP[1]) | (IR[9]&NZP[0]);
		regBEN    regben(.reset(Reset), .Load(LD_BEN), .Clk(Clk), .D(BEN_In), .Q(BEN));		
		setNZP    setnzp(.Clk(Clk), .Load(LD_CC), .reset(Reset), .my_BUS(my_BUS), .NZP(NZP));
		
endmodule

module MUX4 (input logic GatePC, GateMDR, GateALU, GateMARMUX,
				 input logic [15:0] PC, ALU, MDR_Out, MARMUX,
				 output logic [15:0] my_BUS);
		always_comb 
		begin
				if (GatePC)
						my_BUS = PC;
				else if (GateMDR)
						my_BUS = MDR_Out;
				else if (GateALU)
				      my_BUS = ALU;
				else if (GateMARMUX)
						my_BUS = MARMUX;
				else 
						my_BUS = 16'hxxxx;
		
		end		 
				 				 
				 
endmodule
				 
module shiftreg (input logic         Clk, Load, Reset, 
						 input logic  [15:0] D,
						 output logic [15:0] Q);
				always_ff @ (posedge Clk)
	         begin
					if (Reset)
					    Q <= 16'h0000;
					else if (Load)
					    Q <= D;
					/*else
					    Q <= Q;*/
						 
				end
				
						 
endmodule

module MUX_pc (input logic   [1:0]      PCMUX, 
					input logic   [15:0]     PC_In, my_BUS, marmuxadd,
					output logic  [15:0]     PC_Out);
		always_comb
		begin
		     case(PCMUX)
			  2'b00 :
						PC_Out = PC_In + 1;
			  2'b01 :
						PC_Out = my_BUS;
			  2'b10 :
						PC_Out = marmuxadd;
			  default :
			         PC_Out = 16'hxxxx;
			  endcase
		end			
					
endmodule

