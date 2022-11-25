module ad_ctrl
(
	input 	wire			sys_clk		,
	input	wire			sys_rst_n	,
	input	wire	[7:0]	ad_data		,

	output	wire			ad_clk		,
	output	reg				sign		,
	output	reg		[19:0]	data

);
reg			cnt_div4	;
reg			clk_12500k	;
reg	[10:0]	cnt_sum		;
reg			cnt_en_n	;
reg			cnt_en_reg	;
wire		sum_flag	;
reg			cnt_flag	;
reg	[17:0]	sum			;
reg [7:0]	ave			;
reg	[26:0]	precision_p	;
reg	[26:0]	precision_n	;


//cnt_div4
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_div4 <= 1'b0;
	else if(cnt_div4 == 1'b1)
		cnt_div4 <= 1'b0;
	else 
		cnt_div4 <= cnt_div4 + 1'b1;

//clk_12500k
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		clk_12500k <= 1'b1;
	else if(cnt_div4 == 1'b1)
		clk_12500k <= ~clk_12500k;

//ad_clk
assign ad_clk = ~clk_12500k;

//cnt_sum
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_sum <= 11'd0;
	else if(cnt_sum == 11'd1024)
		cnt_sum <= 11'd0;
	else if(cnt_en_n == 1'b0)
		cnt_sum <= cnt_sum + 11'd1;
		
//cnt_en_n
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_en_n <= 1'b0;
	else if(cnt_sum == 11'd1024)
		cnt_en_n <= 1'b1;

//cnt_en_reg
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_en_reg <= 1'b0;
	else 
		cnt_en_reg <= cnt_en_n;

//sum_flag
assign sum_flag = cnt_en_n ^ cnt_en_reg;

//cnt_flag
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_flag <= 1'b0;
	else if((cnt_en_reg == 1'b0) && (cnt_en_n == 1'b1))
		cnt_flag <= 1'b1;
	else
		cnt_flag <= 1'b0;
		

//sum
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sum <= 18'd0;
	else if(cnt_en_n == 1'b0)
		sum <= sum + ad_data;
		
		
//ave
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		ave <= 8'd0;
	else if(sum_flag == 1'b1)
		ave <= sum/1024;
		
//precision_p
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		precision_p <= 27'd0;
	else if(cnt_flag == 1'b1)
		precision_p <= ((1000*5)/(255-ave)) << 13;

//precision_n
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		precision_n <= 27'd0;
	else if(cnt_flag == 1'b1)
		precision_n <= ((1000*5)/ave) << 13;

//sign
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sign <= 1'b0;
	else if(cnt_en_n == 1'b0)
		sign <= 1'b0;
	else if(ad_data >= ave)
		sign <= 1'b0;
	else
		sign <= 1'b1;
		
//data
always@(posedge clk_12500k or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data <= 20'd0;
	else if((cnt_en_n == 1'b1) && (ad_data >= ave))
		data <= ((ad_data - ave) * precision_p) >> 13;
	else if((cnt_en_n == 1'b1) && (ad_data < ave))
		data <= ((ave - ad_data) * precision_n) >> 13;
		

endmodule