`timescale 1ns/1ns
module tb_wave_ctrl();
reg			sys_clk  	;
reg			sys_rst_n	;
reg	 [3:0]	wave_sel	;

wire [7:0]	dac_data	;

///1000
parameter DELAY_TIME = 33'd4_294_96700;
//initial
initial
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
	#20 
		sys_rst_n <= 1'b1;
	
	end

//sys_clk
always #10 sys_clk = ~sys_clk;

//wave_sel
initial
	begin
		wave_sel <= 4'b0001;
	# DELAY_TIME
		wave_sel <= 4'b0010;
	# DELAY_TIME
		wave_sel <= 4'b0100;
	# DELAY_TIME
		wave_sel <= 4'b1000;

	end




wave_ctrl wave_ctrl_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.wave_sel		(wave_sel	),

	.dac_data	    (dac_data	)

);
endmodule
