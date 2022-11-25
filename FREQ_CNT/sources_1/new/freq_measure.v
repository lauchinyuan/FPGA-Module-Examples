module freq_measure
#(	parameter MEA_CNT_MAX 	= 27'd74_999_999	,
	parameter CNT_250MS 	= 27'd124_999_999	,
	parameter CNT_1250MS 	= 27'd62_499_999	,
	parameter Fstd			= 50'd100_000		
	)
(
	input 	wire		sys_clk			,
	input 	wire		sys_rst_n		,
	input	wire		test_clk		,
	
	output	reg	[49:0]	freq_data		
);
wire		std_pll_clk					;
wire		std_pll_locked				;
wire		std_clk						;


reg [26:0]	mea_cnt						;
reg			gate						;
reg			gate_test					;
reg			gate_t_reg					;
reg			get_data					;
reg [26:0]	x_cnt						;
reg [26:0]	y_cnt						;

//std_clk
assign	std_clk = std_pll_clk & std_pll_locked;




//mea_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		mea_cnt <= 27'd0;
	else if(mea_cnt == MEA_CNT_MAX)
		mea_cnt <= 27'd0;
	else
		mea_cnt <= mea_cnt + 27'd1;
		

//gate	
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		gate <= 1'b0;
	else if(mea_cnt == CNT_250MS)
		gate <= 1'b1;
	else if(mea_cnt == CNT_1250MS)
		gate <= 1'b0;
	
		
//gate_test
always@(posedge test_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		gate_test <= 1'b0;
	else 
		gate_test <= gate;

//gate_t_reg
always@(posedge test_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		gate_t_reg <= 1'b0;
	else
		gate_t_reg <= gate_test;
		
//get_data
always@(posedge test_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		get_data <= 1'b0;
	else if((gate_t_reg == 1'b1) && (gate_test == 1'b0))
		get_data <= 1'b1;
	else
		get_data <= 1'b0;
		
		
//x_cnt
always@(posedge test_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		x_cnt <= 27'd0;
	else if(gate_test == 1'b1)
		x_cnt <= x_cnt + 27'd1;
	else if(get_data == 1'b1)
		x_cnt <= 27'd0;
		
		
//y_cnt
always@(posedge std_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		y_cnt <= 27'd0;
	else if(gate_test == 1'b1)
		y_cnt <= y_cnt + 27'd1;

		
always@(posedge test_clk or negedge sys_rst_n)
	if(get_data == 1'b1)
		y_cnt <= 27'd0;
		
//freq_data
always@(posedge test_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		freq_data <= 50'd0;
	else if(get_data)
		freq_data <=  (x_cnt*Fstd)/y_cnt;
		

//std_clk
clk_wiz_0 clk_100m_inst
(
	.clk_out1		(std_pll_clk	),     
	.reset			(~sys_rst_n		), 
	.locked			(std_pll_locked	), 

	.clk_in1		(sys_clk		)
);      	




endmodule