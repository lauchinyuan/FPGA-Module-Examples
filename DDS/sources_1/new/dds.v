module dds
(
	input 	wire			sys_clk		,
	input 	wire			sys_rst_n	,
	input 	wire	[3:0]	key_in		,
	
	output	wire			dac_clk		,
	output	wire	[7:0]	dac_data	
);

wire	[3:0]	key		;

assign	dac_clk = sys_clk	;


key_ctrl key_ctrl_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.key_in			(key_in		),

	.key_out		(key		)
);

wave_ctrl wave_ctrl_inst1
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.wave_sel		(key		),

	.dac_data	    (dac_data	)

);

endmodule


