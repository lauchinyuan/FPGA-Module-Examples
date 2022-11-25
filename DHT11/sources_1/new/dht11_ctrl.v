module dht11_ctrl
(
	input	wire		sys_clk		,
	input	wire		sys_rst_n	,
	input	wire		key			,
	
	inout	wire		data_inout	,
	
	output	reg	[19:0]	data		,
	output	reg			sign		

);
parameter	WAIT_1S = 5'b00_001,
			START	= 5'b00_010,
			ASK		= 5'b00_100,
			READ	= 5'b01_000,
			WAIT_2S = 5'b10_000;
			
			
reg		[4:0]	cnt_us		;
reg				clk_us		;
reg				data_d1		;
reg				data_d2		;
wire			fall_flag	;
wire			rise_flag	;
reg		[4:0]	state		;	
reg		[20:0]	cnt_1us		;
reg		[5:0]	bit_cnt		;
reg				error_flag	;
reg		[39:0]	data_bit	;
reg				out_state	;
reg				master_ctrl_en;
reg 	[7:0]	check		;

//cnt_us
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_us <= 5'd0;
	else if(cnt_us == 5'd24)
		cnt_us <= 5'd0;
	else
		cnt_us <= cnt_us + 5'd1;
		
//clk_us
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		clk_us <= 1'b1;
	else if(cnt_us == 5'd24)
		clk_us <= ~clk_us;

//data_d1 & data_d2
//将输入数据作延迟，与clk_us同步边缘
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		begin
		data_d1 <= 1'b1;
		data_d2 <= 1'b1;
		end
	else
		begin
		data_d1 <= data_inout;
		data_d2 <= data_d1;
		end

//fall_flag
//下降沿标志
assign fall_flag = (~data_d1)&(data_d2);

//rise_flag
//上升沿标志
assign	rise_flag = (data_d1)&(~data_d2);

//state machine
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		state <= WAIT_1S;
	else case(state)
		WAIT_1S:
		if(cnt_1us == 21'd999_999)
			state <= START;
		else 
			state <= WAIT_1S;
			
		START:
		if((fall_flag == 1'b1)&&(cnt_1us > 21'd1808))
			state <= ASK;
		else 
			state <= START;
			
		ASK:
		if(((rise_flag==1'b1)||(fall_flag==1'b1))&&((cnt_1us<50)||(cnt_1us>120)))
		 //电平保持时间过长或者过短
			state <= START;
		else if(fall_flag == 1'b1)
			state <= READ; //正确跳转到READ状态
		else 
			state <= ASK;
			
		READ:
		if((rise_flag==1'b1)&&((cnt_1us<21'd48)||(cnt_1us>21'd52)))
			state <= START; //低电平保持时间并非约等于50us
		else if((fall_flag==1'b1)&&
		((cnt_1us<21'd24)||(cnt_1us>21'd30&&cnt_1us<21'd68)||(cnt_1us>21'd72)))
			state <= START; //数据高电平时间不在合理范围内
		else if((fall_flag==1'b1)&&(bit_cnt==6'd39))
			state <= WAIT_2S;  //数据接收完成，进入等待状态
		else 
			state <= READ;
		
		WAIT_2S:
		if((cnt_1us==21'd1)&&(check!=data_bit[7:0]))
			state <= START;  //check error
		else if(cnt_1us==21'd1_999_999)
			state <= START; //计时完成，回到start状态等待下一次信号到来
		
		default:
			state <= WAIT_1S;
	
	endcase



//cnt_1us
//计时
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)  
		cnt_1us <= 21'd0;
	else if((state == WAIT_1S) && (cnt_1us == 21'd999_999))
		cnt_1us <= 21'd0;
	else if(state == START && fall_flag == 1'b1 && cnt_1us > 21'd1808)
		cnt_1us <= 21'd0;  //进入ASK状态的同时将计数器计数值清零
		
	//在ASK和READ状态下，上升沿以及下降沿都会使得cnt_1us计数器清零
	else if((state==ASK)&&((rise_flag==1'b1)||(fall_flag==1'b1))) 
		cnt_1us <= 21'd0;
	else if((state==READ)&&((rise_flag==1'b1)||(fall_flag==1'b1)))
		cnt_1us <= 21'd0;
	else if((state==WAIT_2S)&&(cnt_1us==21'd1_999_999))
		cnt_1us <= 21'd0;
	else
		cnt_1us <= cnt_1us + 21'd1;

	
	
//bit_cnt
//用于记录bit位数，检测满足40个数据bit，跳转到下一状态
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n==1'b0)
		bit_cnt <= 6'd0;
	else if(state == READ && fall_flag == 1'b1 && bit_cnt == 6'd39)
		bit_cnt <= 6'd0;
	else if(state == READ && fall_flag == 1'b1)
		bit_cnt <= bit_cnt + 6'd1;
	else 
		bit_cnt <= bit_cnt;
		
//data_bit
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_bit <= 40'b0;
	else if(state == READ && fall_flag == 1'b1)
		if((cnt_1us >= 21'd26)&&(cnt_1us <= 21'd30)) //bit 0
			data_bit <= {data_bit[38:0],1'b0};
		else if((cnt_1us >= 21'd68)&&(cnt_1us <= 21'd72)) //bit 1
			data_bit <= {data_bit[38:0],1'b1};
	else 
		data_bit <= data_bit;
		
//sign
//符号位，1代表负值，0代表正值
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sign <= 1'b0;
	else if(state == WAIT_2S && data_bit[15] == 1 && out_state == 0) //说明输出温度是负值
		sign <= 1'b1;
	else if(state <= WAIT_2S)  //只有在WAIT_2S状态下，代表数据接收完毕才会改变sign的数值
		sign <= 1'b0;
		
	else 
		sign <= sign;




//out_state 
//0：输出温度
//1：输出湿度
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n==1'b0)
		out_state <= 1'b0;
	else if(key == 1'b1)
		out_state <= ~out_state;
	else 
		out_state <= out_state;
	
	
	
//check 校验数据
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		check <= 8'b0;
	else if(state==WAIT_2S || cnt_1us==21'd0)
	//计算正确的校验数据
		check <= data_bit[39:32]+data_bit[31:24]+data_bit[23:16]+data_bit[15:8];
	else 
		check <= check;
		
//data
//输出至数码管的数据信号，数码管的小数点位已经设置为6'b000_100，代表有两个小数点位
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data <= 20'd0;
	else if(state == WAIT_2S && error_flag == 1'b1)
		data <= 20'd0;
	else if(state == WAIT_2S && out_state == 1'b0) //输出温度数据
		data <= data_bit[23:16]*100 + data_bit[14:8];  //data_bit[15]是符号位，不用于计算
	else if(state == WAIT_2S && out_state == 1'b1)//输出湿度数据
		data <= data_bit[39:32]*100 + data_bit[31:24];
		
//master_ctrl_en
//主机控制信号
//1：主机获得总线控制权
//0：主机放弃对总线的控制
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		master_ctrl_en <= 1'b0;
	else if(state == START && (cnt_1us>=0 && cnt_1us<=18007)) //获得18ms以上的控制权，以拉低总线
		master_ctrl_en <= 1'b1;
	else 
		master_ctrl_en <= 1'b0;
		
//data_inout
//控制data_inout总线
assign data_inout = (master_ctrl_en == 1'b1)? 1'b0 : 1'bz;

	


//error_flag
//错误标志，用于仿真查错
always@(posedge clk_us or negedge sys_rst_n)
	if(sys_rst_n==1'b0)
		error_flag <= 1'b0;
	else case(state)
		ASK:
		if(((rise_flag==1'b1)||(fall_flag==1'b1))&&((cnt_1us<50)||(cnt_1us>120)))
		 //电平保持时间过长或者过短
		error_flag <= 1'b1;
		
		
		READ:
		if((rise_flag==1'b1)&&((cnt_1us<21'd48)||(cnt_1us>21'd52)))
			error_flag <= 1'b1;//低电平保持时间并非约等于50us
		else if((fall_flag==1'b1)&&((cnt_1us<21'd24)||(cnt_1us>21'd30&&cnt_1us<21'd68)||(cnt_1us>21'd72)))
			error_flag <= 1'b1;//数据高电平时间不在合理范围内
		else 
			error_flag <= 1'b0;
		
		WAIT_2S:
		if((cnt_1us==21'd1)&&(check!=data_bit[7:0]))
			error_flag <= 1'b1;  //check error
		else 
			error_flag <= 1'b0;
			
		default:
			error_flag <= 1'b0;
		
		
	endcase



endmodule