module test_clk_gen
(
	input 	wire		sys_clk			,
	input 	wire		sys_rst_n		,
	
	output 	wire		test_clk		
);
wire	clk_pll			;
wire	locked_pll		;

//test_clk
assign 	test_clk = locked_pll & clk_pll;


clk_wiz_1_6250k clk_6250k_inst
(

		.clk_out1	(clk_pll		),  

		.reset		(~sys_rst_n		),
		.locked		(locked_pll		),        
		.clk_in1	(sys_clk		)
);     



endmodule
