module dig_volt
(
	input 	wire			sys_clk		,
	input 	wire			sys_rst_n	,
	input 	wire	[7:0]	ad_data		,

	output 	wire			ad_clk		,
	output 	wire	[5:0] 	sel			,
	output	wire	[7:0]	seg	
);

wire	[19:0]		data	;
wire				sign	;



ad_ctrl ad_ctrl_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.ad_data		(ad_data	),

	.ad_clk			(ad_clk		),
	.sign			(sign		),
	.data           (data       )

);

seg_dynamic
#(
	.CNT_SEG_MAX (16'd49_999)
)
seg_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.data			(data		),
	.point			(6'b001000	),
	.sign			(sign		),
	.seg_en			(1'b1		),

	.seg 			(seg 		),
	.sel	        (sel	    )
	
);

endmodule