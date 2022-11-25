`timescale 1ns/1ns
module tb_rs232_tx();

reg			sys_clk		;
reg			sys_rst_n	;
reg [7:0]	data_in		;
reg			data_flag	;

wire		tx			;
wire		flag_txe	;

//initial
initial
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
	#20
		sys_rst_n <= 1'b1;
		data_in <= 8'b0000_1111;
		data_flag <= 1'b1;
		
	#5800
		data_flag <= 1'b0;
		
	#5800000
		data_flag <= 1'b1;
		
	#5800
		data_flag <= 1'b0;
	
	
	
	end


//sys_clk
always #10 sys_clk = ~sys_clk;


rs232_tx rs232_tx_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.data_in		(data_in	),
	.data_flag		(data_flag	),

	.tx				(tx			),
	.flag_txe	    (flag_txe	)

);

endmodule 
