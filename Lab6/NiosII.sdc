#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "10.0 MHz" [get_ports ADC_CLK_10]
create_clock -period "50.0 MHz" [get_ports MAX10_CLK1_50]
create_clock -period "50.0 MHz" [get_ports MAX10_CLK2_50]




# SDRAM CLK
create_generated_clock -name {clk_dram_ext} -source [get_pins { u0|sdram_pll|sd1|pll7|clk[0] } ] [get_ports {DRAM_CLK}] 
 #        m_lab61_soc|sdram_pll|sd1|pll7|clk[1]          

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# suppose +- 100 ps skew
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
# max 5.4(max) +0.4(trace delay) +0.1 = 5.9
# min 2.7(min) +0.4(trace delay) -0.1 = 3.0
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[0]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[0]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[1]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[1]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[2]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[2]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[3]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[3]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[4]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[4]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[5]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[5]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[6]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[6]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[7]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[7]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[8]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[8]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[9]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[9]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[10]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[10]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[11]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[11]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[12]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[12]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[13]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[13]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[14]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[14]]
set_input_delay -clock clk_dram_ext -max 5.9 [get_ports DRAM_DQ[15]]
set_input_delay -clock clk_dram_ext -min 3.0 [get_ports DRAM_DQ[15]]

set_input_delay -max -clock clk_dram_ext 5.9 [get_ports KEY[0]]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports KEY[0]]
set_input_delay -max -clock clk_dram_ext 5.9 [get_ports KEY[1]]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports KEY[1]]

set_input_delay -max -clock clk_dram_ext 5.9 [get_ports ARDUINO_IO[9]]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports ARDUINO_IO[9]]
set_input_delay -max -clock clk_dram_ext 5.9 [get_ports ARDUINO_IO[12]]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports ARDUINO_IO[12]]


set_input_delay -max -clock clk_dram_ext 5.9 [get_ports altera_reserved_tdi]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports altera_reserved_tdi]
set_input_delay -max -clock clk_dram_ext 5.9 [get_ports altera_reserved_tms]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports altera_reserved_tms]

#shift-window
set_multicycle_path -from [get_clocks {clk_dram_ext}] \
                    -to [get_clocks { u0|sdram_pll|sd1|pll7|clk[0] }] \
						  -setup 2
						  
#**************************************************************
# Set Output Delay
#**************************************************************
# suppose +- 100 ps skew
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
# max 1.5+0.1 =1.6
# min -0.8-0.1 = 0.9
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[0]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[0]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[1]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[1]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[2]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[2]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[3]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[3]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[4]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[4]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[5]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[5]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[7]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[7]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[8]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[8]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[9]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[9]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[10]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[10]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[11]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[11]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[12]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[12]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[13]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[13]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[14]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[14]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ[15]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ[15]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[0]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[0]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[1]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[1]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[2]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[2]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[3]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[3]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[4]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[4]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[5]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[5]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[7]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[7]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[8]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[8]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[9]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[9]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[10]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[10]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[11]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[11]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR[12]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR[12]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_BA[0]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_BA[0]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_BA[1] DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_BA[1] DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {altera_reserved_tdo DRAM_LDQM DRAM_UDQM ARDUINO_RESET_N ARDUINO_IO[7] ARDUINO_IO[10] ARDUINO_IO[11] ARDUINO_IO[13]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {altera_reserved_tdo DRAM_LDQM DRAM_UDQM ARDUINO_RESET_N ARDUINO_IO[7] ARDUINO_IO[10] ARDUINO_IO[11] ARDUINO_IO[13]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[0]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[0]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[1]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[1]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[2]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[2]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[3]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[3]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[4]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[4]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[5]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[5]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[7]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[7]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[8]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[8]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {LEDR[9]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {LEDR[9]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX0[0] HEX0[1] HEX0[1] HEX0[2] HEX0[3] HEX0[4] HEX0[5] HEX0[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX0[0] HEX0[1] HEX0[1] HEX0[2] HEX0[3] HEX0[4] HEX0[5] HEX0[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX1[0] HEX1[1] HEX1[1] HEX1[2] HEX1[3] HEX1[4] HEX1[5] HEX1[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX1[0] HEX1[1] HEX1[1] HEX1[2] HEX1[3] HEX1[4] HEX1[5] HEX1[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX2[0] HEX2[1] HEX2[1] HEX2[2] HEX2[3] HEX2[4] HEX2[5] HEX2[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX2[0] HEX2[1] HEX2[1] HEX2[2] HEX2[3] HEX2[4] HEX2[5] HEX2[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX3[0] HEX3[1] HEX3[1] HEX3[2] HEX3[3] HEX3[4] HEX3[5] HEX3[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX3[0] HEX3[1] HEX3[1] HEX3[2] HEX3[3] HEX3[4] HEX3[5] HEX3[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX4[0] HEX4[1] HEX4[1] HEX4[2] HEX4[3] HEX4[4] HEX4[5] HEX4[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX4[0] HEX4[1] HEX4[1] HEX4[2] HEX4[3] HEX4[4] HEX4[5] HEX4[6]}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {HEX5[0] HEX5[1] HEX5[1] HEX5[2] HEX5[3] HEX5[4] HEX5[5] HEX5[6]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {HEX5[0] HEX5[1] HEX5[1] HEX5[2] HEX5[3] HEX5[4] HEX5[5] HEX5[6]}]

set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {VGA_B[0] VGA_B[1] VGA_B[2] VGA_HS}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {VGA_B[0] VGA_B[1] VGA_B[2] VGA_HS}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {VGA_G[0] VGA_G[2] VGA_VS}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {VGA_G[0] VGA_G[2] VGA_VS}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {VGA_R[0] VGA_R[1] VGA_R[2] VGA_R[3]}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {VGA_R[0] VGA_R[1] VGA_R[2] VGA_R[3]}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
#set false path for switches and LEDs, we don't care when it changes
# set_false_path 
set_false_path -from [get_ports {SW[0] SW[1] SW[2] SW[3] SW[4] SW[5] SW[6] SW[7]}] -to [get_ports {LEDR[0] LEDR[1] LEDR[2] LEDR[3] LEDR[4] LEDR[5] LEDR[6] LEDR[7]}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



