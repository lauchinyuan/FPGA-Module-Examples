`timescale 1ns/1ns
module tb_freq_measure();
reg 			sys_clk 		;
reg				sys_rst_n		;
wire			clk_test		;

wire	[49:0]	freq_data		;

//initial
initial
	begin
		sys_clk = 1'b1			;
		sys_rst_n <= 1'b0		;
	#20
		sys_rst_n <= 1'b1		;
	end

//sys_clk
always #10 sys_clk = ~sys_clk	;	


test_clk_gen test_clk_inst
(
	.sys_clk			(sys_clk)		,
	.sys_rst_n			(sys_rst_n)		,

	.test_clk		    (clk_test)
);


freq_measure
#(	.MEA_CNT_MAX 	(27'd74_999		)	,
	.CNT_250MS 		(27'd12_499		)	,
	.CNT_1250MS 	(27'd62_499		) 	,
	.Fstd			(50'd100_000	)	
	)
	freq_measure_inst
(
	.sys_clk		(sys_clk)				,
	.sys_rst_n		(sys_rst_n)				,
	.test_clk		(clk_test)				,

	.freq_data	    (freq_data)
);




endmodule
