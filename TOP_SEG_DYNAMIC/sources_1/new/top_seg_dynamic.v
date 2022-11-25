module top_seg_dynamic
(
	input	wire		sys_clk		,
	input	wire		sys_rst_n	,
	
	output	wire	[5:0]	sel		,
	output	wire	[7:0]	seg
);

wire	[19:0]	data		;
wire	[5:0]	point		;
wire			seg_en		;
wire			sign        ;





data_gen
#(	.CNT_MAX(23'd499_9),
	.DATA_MAX(20'd999_999))
data_generator
(
	.sys_clk		(sys_clk)	,
	.sys_rst_n		(sys_rst_n)	,

	.data			(data)		,
	.point			(point)		,
	.seg_en			(seg_en)	,
	.sign        	(sign)

);


seg_dynamic
#(
	.CNT_SEG_MAX(16'd49)
)
seg_dynamic_1
(
	.sys_clk		(sys_clk)			,
	.sys_rst_n		(sys_rst_n)			,
	.data			(data)				,
	.point			(point)				,
	.sign			(sign)				,
	.seg_en			(seg_en)			,

	.seg 			(seg)				,
	.sel	        (sel)		
	
);


endmodule
