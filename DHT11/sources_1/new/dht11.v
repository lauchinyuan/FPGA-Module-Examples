module dht11
(
	input	wire 		sys_clk		,
	input	wire		sys_rst_n	,
	input	wire		key_in		,

	inout	wire		data_inout	,

	output	wire	[5:0]	sel		,
	output	wire	[7:0]	seg		

	
);

wire			key		;
wire	[19:0]	data	;
wire			sign	;

key_filter 
#(.MAX_CNT(20'd999_999))   //20MS
key_filter_inst
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key_in		(key_in		),

	.key_out    (key	    )

);

dht11_ctrl dth11_ctrl_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.key			(key		),

	.data_inout		(data_inout	),
	
	.data			(data		),
	.sign		    (sign		)

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
	.point			(6'b000100	),
	.sign			(sign		),
	.seg_en			(1'b1		),

	.seg 			(seg 		),
	.sel	        (sel	    )
	
);

endmodule