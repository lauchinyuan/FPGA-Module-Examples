module key_ctrl
(
	input 	wire 				sys_clk		,
	input 	wire				sys_rst_n	,
	input 	wire	[3:0]		key_in		,
	
	output 	reg		[3:0]		key_out		
);
wire	[3:0]	key_temp;


always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_out <= 4'b0001;
	else if(key_temp[0] == 1'b1)
		key_out <= 4'b0001;
	else if(key_temp[1] == 1'b1)
		key_out <= 4'b0010;
	else if(key_temp[2] == 1'b1)
		key_out <= 4'b0100;
	else if(key_temp[3] == 1'b1)
		key_out <= 4'b1000;

key_filter 
#(.MAX_CNT(20'd999_999))   //20MS
key_filter1
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key_in		(key_in[0]	),

	.key_out    (key_temp[0]	)
);

key_filter 
#(.MAX_CNT(20'd999_999))   //20MS
key_filter2
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key_in		(key_in[1]	),

	.key_out    (key_temp[1]	)
);

key_filter 
#(.MAX_CNT(20'd999_999))   //20MS
key_filter3
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key_in		(key_in[2]	),

	.key_out    (key_temp[2]	)
);

key_filter 
#(.MAX_CNT(20'd999_999))   //20MS
key_filter4
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key_in		(key_in[3]	),

	.key_out    (key_temp[3]	)
);



endmodule
