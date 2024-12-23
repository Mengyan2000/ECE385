module  frameRAM_bkgrd
(
		input [18:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

		// mem has width of 3 bits and a total of 400 addresses
		logic [23:0] mem [0:10559];

		initial
		begin
			 $readmemh("background_12.txt", mem);
		end


		always_ff @ (posedge Clk) begin
			data_Out<= mem[read_address];
		end

endmodule