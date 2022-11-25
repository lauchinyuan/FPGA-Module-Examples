`timescale 1ns/1ns
module tb_rs232();
reg			sys_clk		;
reg 		sys_rst_n	;
reg			rx			;

wire		tx			;
wire		flag_txe	;

//initial
initial
	begin
		sys_clk = 1'b1		;
		sys_rst_n <= 1'b0	;
	#20
		sys_rst_n <= 1'b1	;
	
	#2000
		data_gen(8'haa);
	#2000
		data_gen(8'haf);
	#2000
		data_gen(8'h0a);
	#2000
		data_gen(8'h0e);

	end



//sys_clk 
always #10 sys_clk = ~sys_clk;



task data_gen
(
	input [7:0] data
);
	integer i;
		for(i = 0;i <= 10;i = i+1)
			begin
				case(i)
					0: rx <= 1'b1;
					1: rx <= 1'b0;
					2: rx <= data[0];
					3: rx <= data[1];
					4: rx <= data[2];
					5: rx <= data[3];
					6: rx <= data[4];
					7: rx <= data[5];
					8: rx <= data[6];
					9: rx <= data[7];
					10: rx <= 1'b1;
					default:rx <= 1'b1;
				endcase
				# (20*5208);
			end
endtask



rs232 rs232_inst
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.rx			(rx			),

	.tx			(tx			),
	.flag_txe	(flag_txe	)

);

endmodule


