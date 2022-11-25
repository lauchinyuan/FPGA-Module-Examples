module inf_decoder
(
	input 	wire		sys_clk		,
	input 	wire		sys_rst_n	,
	input	wire		inf_in		,
	
	output	reg			repeat_en	,
	output	reg	[19:0]	data_out		
);

reg				inf_in_reg		;
reg				inf_in_reg1		;
wire			fall_flag		;
wire			rise_flag		;
reg		[6:0]	state			;
reg		[22:0]	cnt_110ms		;
reg		[19:0]	cnt				;
reg		[19:0]	cnt_reg			;
reg				fall_flag_reg	;
reg				rise_flag_reg	;
reg				rise_flag_reg2	;
reg		[3:0]	data_bit_cnt	;
reg		[1:0]	data_byte_cnt	;
reg				data			;
reg		[7:0]	addr_s_temp		;
reg		[7:0]	addr_c_temp		;
reg		[7:0]	data_s_temp		;
reg		[7:0]	data_c_temp		;
reg				data_finished 	;




reg				error_flag		;



parameter	IDLE				= 		7'b000_0001	,
			INTRODUCE_9000U		= 		7'b000_0010	,
			INTRODUCE_4500U		= 		7'b000_0100	,
			DATA				= 		7'b000_1000	,
			WAIT_REP			= 		7'b001_0000	,
			REP_9000U			= 		7'b010_0000	,
			REP_2250U			= 		7'b100_0000	,
			TIME_540U			= 		15'd26_999	,
			TIME_580U			=		15'd28_999	,
			TIME_1670U			= 		17'd83_499	,
			TIME_1710U			= 		17'd85_499	,
			TIME_9200U			=		19'd459_999	,
			TIME_8800U			=		19'd439_999	,
			TIME_4600U			= 		19'd229_999	,
			TIME_4400U			= 		19'd219_999	,
			TIME_100000U		= 		23'd4_999_999,
			TIME_120000U		= 		23'd5_999_999,
			TIME_2240U			= 		17'd111_999	,
			TIME_2260U			= 		17'd112_999	,
			
			ADDR				= 		8'h12		;
			
			

//inf_in_reg and inf_in_reg1
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		begin
			inf_in_reg 	<= 	1'b1;
			inf_in_reg1 <= 	1'b1;
		end
	else 
		begin
			inf_in_reg 	<= 	inf_in;
			inf_in_reg1 <= 	inf_in_reg;
		end

//fall_flag
assign	fall_flag = (inf_in_reg == 1'b0) && (inf_in_reg1 == 1'b1);

//rise_flag
assign	rise_flag = (inf_in_reg == 1'b1) && (inf_in_reg1 == 1'b0);

//state
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		state <= IDLE;
	else if(error_flag == 1'b1)
		state <= IDLE;
	else case(state)
		IDLE:
		if(fall_flag == 1'b1)
			state	<= 		INTRODUCE_9000U	;
			
		INTRODUCE_9000U:
		if((rise_flag_reg == 1'b1)&&((cnt_reg > TIME_8800U) && 
			(cnt_reg <= TIME_9200U)))
			state	<= 		INTRODUCE_4500U	;
			
		INTRODUCE_4500U:
			if((fall_flag_reg == 1'b1)&&((cnt_reg > TIME_4400U) &&
			(cnt_reg <= TIME_4600U)))
			state 	<= 		DATA			;
		
		DATA:
			if((data_bit_cnt == 4'd7) 	&& 
				(data_byte_cnt == 2'd3) && 
				(rise_flag_reg == 1'b1)	&&
				((cnt_reg > TIME_540U) 	&&
				(cnt_reg <= TIME_580U)))
			state 	<= 		WAIT_REP		;
			
		WAIT_REP:
			if((fall_flag == 1'b1) 			&& 
				(cnt_110ms <= TIME_120000U) &&
				(cnt_110ms > TIME_100000U))
			state 	<= 		REP_9000U		;
			
			else if(cnt_110ms == TIME_120000U)
			state 	<= 		IDLE			;
			
		
		REP_9000U:
			if((rise_flag_reg == 1'b1)		&&
				((cnt_reg > TIME_8800U) 	&& 
				(cnt_reg <= TIME_9200U)))
			state 	<= 		REP_2250U		;
		
		REP_2250U:
			if((fall_flag_reg == 1'b1)		&&
				((cnt_reg > TIME_2240U)	&& (cnt_reg <= TIME_2260U)))
			state	<= 		WAIT_REP		;
			
		
		default: 
			state <= IDLE;
	
	endcase

//cnt_110ms
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_110ms <= 23'd0;
	else case(state)
		IDLE: 
		if(fall_flag == 1'b1)
			cnt_110ms <= 23'd1;
		else
			cnt_110ms <= 23'd0;
		WAIT_REP:
		if(fall_flag == 1'b1)
			cnt_110ms <= 23'd1;
		else
			cnt_110ms <= cnt_110ms + 23'd1;
		default:
			cnt_110ms <= cnt_110ms + 23'd1;
		
	endcase

//cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 20'd0;
	else if((fall_flag == 1'b1) || (rise_flag == 1'b1))
		cnt <= 20'd0;
	else 
		cnt <= cnt + 20'd1;
		
//cnt_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_reg	<= 20'd0;
	else if(state == IDLE)
		cnt_reg <= 20'd0;
	else if((fall_flag == 1'b1) || (rise_flag == 1'b1))
		cnt_reg	<= cnt;
	
//fall_flag_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		fall_flag_reg <= 1'b0;
	else 
		fall_flag_reg <= fall_flag;
		
//rise_flag_reg & rise_flag_reg2
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		begin
		rise_flag_reg <= 1'b0;
		rise_flag_reg2<= 1'b0;
		end
	else
		begin
		rise_flag_reg <= rise_flag;
		rise_flag_reg2<= rise_flag_reg;
		end
		
//data
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data <= 1'b0;
	else if(state == IDLE)
		data <= 1'b0;
	else if((state == DATA) && (fall_flag_reg == 1'b1) && 
	(cnt_reg <= TIME_580U) && (cnt_reg > TIME_540U) )  //0
		data <= 1'b0;
	else if((state == DATA) && (fall_flag_reg == 1'b1) && 
	(cnt_reg <= TIME_1710U) && (cnt_reg > TIME_1670U)) //1
		data <= 1'b1;
		
//data_bit_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_bit_cnt <= 4'd8;
	else case(state)
		DATA:
		if((rise_flag_reg == 1'b1) && ((data_bit_cnt == 4'd7) || (data_bit_cnt == 4'd8)))
		data_bit_cnt <= 4'd0;
		else if(rise_flag_reg == 1'b1)
		data_bit_cnt <= data_bit_cnt + 4'd1;
		default:
		data_bit_cnt <= 4'd8;
	endcase
		
//data_byte_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_byte_cnt <= 2'd0;
	else case(state)
		DATA:
		begin
/* 			if((rise_flag_reg == 1'b1) && (data_bit_cnt == 4'd7) && (data_byte_cnt == 2'd3))
			data_byte_cnt <= 2'd3; */
			if((rise_flag_reg == 1'b1) && (data_bit_cnt == 4'd7))
			data_byte_cnt <= data_byte_cnt + 2'd1;
		end
		default:
		data_byte_cnt <= 2'd0;
	endcase
		
//addr_s_temp
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
	addr_s_temp <= 8'd0;
	else case(state)
		DATA:
		if((rise_flag_reg == 1'b1) && (data_byte_cnt == 2'd0))
		addr_s_temp <= {data,addr_s_temp[7:1]};
		default:
		addr_s_temp <= 8'd0;
	endcase


//addr_c_temp
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
	addr_c_temp <= 8'd0;
	else case(state)
		DATA:
		if((rise_flag_reg == 1'b1) && (data_byte_cnt == 2'd1))
		addr_c_temp <= {data,addr_c_temp[7:1]};
		default:
		addr_c_temp <= 8'd0;
	endcase
		
//data_s_temp
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
	data_s_temp <= 8'd0;
	else case(state)
		DATA:
		if((rise_flag_reg == 1'b1) && (data_byte_cnt == 2'd2))
		data_s_temp <= {data,data_s_temp[7:1]};
		
		default:
		data_s_temp <= 8'd0;
	endcase
		
//data_c_temp
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
	data_c_temp <= 8'd0;
	else case(state)
		DATA:
		if((rise_flag_reg == 1'b1) && (data_byte_cnt == 2'd3))
		data_c_temp <= {data,data_c_temp[7:1]};
		
/* 		WAIT_REP:
		data_c_temp <= data_c_temp; */
		
		default:
		data_c_temp <= 8'd0;
		
	endcase

//data_finished
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_finished <= 1'b0;
	else if((state == DATA) && (data_bit_cnt == 4'd7) && 
	(data_byte_cnt == 2'd3) && (rise_flag_reg == 1'b1))
		data_finished <= 1'b1;
	else
		data_finished <= 1'b0;
		
//data_out
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_out <= 20'd0;
	else if((data_finished == 1'b1) && 
			(data_c_temp == ~data_s_temp))
		data_out <=	data_s_temp;
			
//repeat_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		repeat_en <= 1'b0;
	else if((state == WAIT_REP) && (rise_flag_reg == 1'b1)	&&
	((cnt_reg > TIME_540U)	&& (cnt_reg <= TIME_580U)))
		repeat_en <= 1'b1;
	else
		repeat_en <= 1'b0;

	
//error_flag
always@(posedge sys_clk or negedge sys_rst_n)
		if(sys_rst_n == 1'b0)
			error_flag <= 1'b0;
		else case(state)
		IDLE: 
			error_flag <= 1'b0;
			
		INTRODUCE_9000U:
			if((rise_flag_reg == 1'b1)&&((cnt_reg <= TIME_8800U) || 
			(cnt_reg > TIME_9200U)))
				error_flag <= 1'b1;
				
		INTRODUCE_4500U:
			if((fall_flag_reg == 1'b1)&&((cnt_reg <= TIME_4400U) || 
			(cnt_reg > TIME_4600U)))
				error_flag <= 1'b1;
		
		DATA:	//data time error
		begin
			if((rise_flag_reg == 1'b1)&&((cnt_reg <= TIME_540U) || 
			(cnt_reg > TIME_580U)))
				error_flag <= 1'b1;
			else if((fall_flag_reg == 1'b1)&&((cnt_reg <= TIME_540U) || 
			((cnt_reg > TIME_580U) && (cnt_reg <= TIME_1670U)) ||
			(cnt_reg > TIME_1710U)))
				error_flag <= 1'b1;
				
			if((rise_flag_reg2 == 1'b1) &&		//addr error
				(data_bit_cnt == 4'd0)	&&
				(data_byte_cnt ==2'd1)	&&
				(addr_s_temp != ADDR))
				error_flag <= 1'b1;
				
			if((rise_flag_reg2 == 1'b1) &&		//addr format error
				(data_bit_cnt == 4'd0)	&&
				(data_byte_cnt ==2'd2)	&&
				(addr_s_temp != ~addr_c_temp))
				error_flag <= 1'b1;
				
			if((data_finished == 1'b1)	&&
				(data_s_temp != ~data_c_temp))
				error_flag <= 1'b1;		
		end
				
		WAIT_REP:
			begin
			if((data_finished == 1'b1)	&&
				(data_s_temp != ~data_c_temp))
				error_flag <= 1'b1;	
				
			if((fall_flag == 1'b1) 			&& 
				((cnt_110ms > TIME_120000U) ||
				(cnt_110ms <= TIME_100000U)))
				error_flag <= 1'b1;
			end
			
		REP_9000U:
			if((rise_flag_reg == 1'b1)		&&
				((cnt_reg <= TIME_8800U) 	||
				(cnt_reg > TIME_9200U)))
				error_flag	<= 1'b1;
		REP_2250U:	
			if((fall_flag_reg == 1'b1)		&&
				((cnt_reg <= TIME_2240U)	|| (cnt_reg > TIME_2260U)))
				error_flag <= 1'b1;
				
		default:
			error_flag <= 1'b0;
		
		
	endcase

	

endmodule