module  frameRAM_enemy2
(
		input [18:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:1146];

initial
begin
	 $readmemh("enemy2.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule