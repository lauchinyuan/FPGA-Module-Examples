`timescale 1ns/1ns
module tb_key_filter();
reg sys_clk;
reg sys_rst_n;
reg key_in;
reg [20:0]tb_cnt;

wire key_out;
parameter 	TB_DELAY_MAX 	=	21'd1_499_999   ,
			TB_DELAY_2MS 	=  	21'd999_99      ,
			TB_DELAY_4MS 	=  	21'd199_999     ,
			TB_DELAY_26MS 	=  	21'd1_299_999   ,
			TB_DELAY_28MS 	=  	21'd1_399_999   ;


initial
	begin
		sys_clk 	= 	1'b1;
		sys_rst_n 	<= 	1'b0;
		#20
		sys_rst_n 	<= 	1'b1;
	end

//sys_clk
always #10	sys_clk = ~sys_clk;

//counter for testbench
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tb_cnt <= 21'd0;
	else if (tb_cnt == TB_DELAY_MAX)
		tb_cnt <= 21'd0;
	else
		tb_cnt <= tb_cnt + 21'd1;
		
//key_in		
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in <= 1'b1;
	else if(((tb_cnt >= TB_DELAY_2MS)&&(tb_cnt <= TB_DELAY_4MS))
	||((tb_cnt >= TB_DELAY_26MS)&&(tb_cnt <= TB_DELAY_28MS)))
		key_in <= {$random} % 2;
	else if((tb_cnt > TB_DELAY_4MS)&&(tb_cnt < TB_DELAY_26MS))
		key_in <= 1'b0;
	else
		key_in <= 1'b1;
	
	

key_filter
#(.MAX_CNT(20'd999_999))
key_filter_inst
(
	.sys_clk	(sys_clk),
	.sys_rst_n	(sys_rst_n),
	.key_in		(key_in),

	.key_out    (key_out)

);

endmodule
