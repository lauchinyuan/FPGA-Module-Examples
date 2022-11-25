module data_gen
#(	parameter CNT_MAX = 23'd4_999_999,
	parameter DATA_MAX = 20'd999_999	)
(
	input 	wire 	sys_clk		,
	input 	wire 	sys_rst_n	,
	
	output 	reg		[19:0]data	,
	output	wire	[5:0]point	,
	output	reg		seg_en		,
	output	wire	sign

);

reg  [22:0] cnt;
reg  cnt_flag;

//cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 23'd0;
	else if(cnt == CNT_MAX)
		cnt <= 23'd0;
	else
		cnt <= cnt + 23'd1;
		
		
//cnt_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_flag <= 1'b0;
	else if(cnt == CNT_MAX - 23'd1)
		cnt_flag <= 1'b1;
	else 
		cnt_flag <= 1'b0;

//data
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data <= 20'd0;
	else if((data == DATA_MAX)&&(cnt_flag == 1'b1))
		data <= 20'd0;
	else if(cnt_flag == 1'b1)
		data <= data + 20'd1;
	else 
		data <= data;

//point
assign point = 6'b000_000;

//sign
assign sign = 1'b0;

//seg_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		seg_en <= 1'b0;
	else
		seg_en <= 1'b1;
		


endmodule
