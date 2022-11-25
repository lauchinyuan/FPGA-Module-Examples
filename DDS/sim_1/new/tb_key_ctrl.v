`timescale 1ns/1ns
module tb_key_ctrl();
reg 		sys_clk;
reg			sys_rst_n;
reg	[3:0]	key_in;

wire [3:0]	key_out;

reg [24:0]	tb_cnt	;


///1000
parameter	CNT_MAX_500MS	= 	25'd24_999	,
			CNT_2MS			= 	25'd99		,
			CNT_4MS			= 	25'd199		,
			CNT_26MS 		=  	25'd1_299   ,
			CNT_28MS 		=  	25'd1_399   ,	
			KEY_1MS			= 	25'd49		,
			KEY_100MS		= 	25'd4_999	,
			KEY_200MS		= 	25'd9_999	,
			KEY_300MS		= 	25'd14_999	;

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

//tb_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tb_cnt <= 25'd0;
	else if(tb_cnt == CNT_MAX_500MS)
		tb_cnt <= 25'd0;
	else
		tb_cnt <= tb_cnt + 25'd1;
		

//key_in[0]
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in[0]	<= 	1'b1;
	else if((tb_cnt >  CNT_2MS + KEY_1MS) && (tb_cnt <= CNT_4MS + KEY_1MS))
		key_in[0] 	<= {$random} % 2;
	else if((tb_cnt >  CNT_26MS + KEY_1MS) && (tb_cnt <= CNT_28MS + KEY_1MS))
		key_in[0] 	<= {$random} % 2;
	else if((tb_cnt > CNT_4MS + KEY_1MS) && (tb_cnt <= CNT_26MS + KEY_1MS))
		key_in[0]	<= 1'b0;
	else
		key_in[0]	<= 1'b1;
		
//key_in[1]
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in[1]	<= 	1'b1;
	else if((tb_cnt >  CNT_2MS + KEY_100MS) && (tb_cnt <= CNT_4MS + KEY_100MS))
		key_in[1] 	<= {$random} % 2;
	else if((tb_cnt >  CNT_26MS + KEY_100MS) && (tb_cnt <= CNT_28MS + KEY_100MS))
		key_in[1] 	<= {$random} % 2;
	else if((tb_cnt > CNT_4MS + KEY_100MS) && (tb_cnt <= CNT_26MS + KEY_100MS))
		key_in[1]	<= 1'b0;
	else
		key_in[1]	<= 1'b1;

//key_in[2]
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in[2]	<= 	1'b1;
	else if((tb_cnt >  CNT_2MS + KEY_200MS) && (tb_cnt <= CNT_4MS + KEY_200MS))
		key_in[2] 	<= {$random} % 2;
	else if((tb_cnt >  CNT_26MS + KEY_200MS) && (tb_cnt <= CNT_28MS + KEY_200MS))
		key_in[2] 	<= {$random} % 2;
	else if((tb_cnt > CNT_4MS + KEY_200MS) && (tb_cnt <= CNT_26MS + KEY_200MS))
		key_in[2]	<= 1'b0;
	else
		key_in[2]	<= 1'b1;
		
//key_in[3]
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in[3]	<= 	1'b1;
	else if((tb_cnt >  CNT_2MS + KEY_300MS) && (tb_cnt <= CNT_4MS + KEY_300MS))
		key_in[3] 	<= {$random} % 2;
	else if((tb_cnt >  CNT_26MS + KEY_300MS) && (tb_cnt <= CNT_28MS + KEY_300MS))
		key_in[3] 	<= {$random} % 2;
	else if((tb_cnt > CNT_4MS + KEY_300MS) && (tb_cnt <= CNT_26MS + KEY_300MS))
		key_in[3]	<= 1'b0;
	else
		key_in[3]	<= 1'b1;
	
defparam key_ctrl_inst1.key_filter1.MAX_CNT = 20'd999;
defparam key_ctrl_inst1.key_filter2.MAX_CNT = 20'd999;
defparam key_ctrl_inst1.key_filter3.MAX_CNT = 20'd999;
defparam key_ctrl_inst1.key_filter4.MAX_CNT = 20'd999;


key_ctrl key_ctrl_inst1
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.key_in			(key_in		),

	.key_out		(key_out	)
);


endmodule
