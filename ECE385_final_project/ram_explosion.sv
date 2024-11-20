module  frameRAM_EP
(
		input [18:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:2115];

initial
begin
	 $readmemh("E1.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

module  frameRAM_EP1
(
		input [18:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:2115];

initial
begin
	 $readmemh("E1.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule