module bcd8421
#(
	parameter SHIFT_MAX = 5'd21
)
(
	input 	wire			sys_clk		,
	input 	wire 			sys_rst_n	,
	input 	wire 	[19:0]	data		,
	input 	wire			sign		,
	
	output	reg		[3:0]	unit		,
	output	reg		[3:0]	ten			,
	output	reg		[3:0]	hun			,
	output	reg		[3:0]	tho			,
	output	reg		[3:0]	ten_tho		,
	output	reg		[3:0]	hun_hun		,
	output 	reg      		sign_out

);

reg 	[4:0]	shift_cnt	;
reg				shift_flag	;
reg		[43:0]	shift_data	;
reg 			sign_temp	;

//shift_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		shift_flag <= 1'b0;
	else
		shift_flag <= ~shift_flag;
		
		

//shift_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		shift_cnt <= 5'd0;
	else if((shift_cnt == SHIFT_MAX)&&(shift_flag == 1'b1))
		shift_cnt <= 5'd0;
	else if(shift_flag == 1'b1)
		shift_cnt <= shift_cnt + 5'd1;
	else
		shift_cnt <= shift_cnt;


//sign_temp
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sign_temp <= sign;
	else if((shift_flag == 1'b0)&&(shift_cnt == 5'd0))
		sign_temp <= sign;
	else
		sign_temp <= sign_temp;


//shift_data
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		shift_data <= {24'd0,data};		//initial
	else if((shift_flag == 1'b0)&&(shift_cnt == 5'd0))
		shift_data <= {24'd0,data}; //ready for shift
	else if((shift_flag == 1'b0)&&(shift_cnt != SHIFT_MAX)&&(shift_cnt != SHIFT_MAX - 5'd1))  	
		begin
			if(shift_data[43:40] > 4'd4)
				shift_data[43:40] <= shift_data[43:40] + 4'd3;
			if(shift_data[39:36] > 4'd4)
				shift_data[39:36] <= shift_data[39:36] + 4'd3;
			if(shift_data[35:32] > 4'd4)
				shift_data[35:32] <= shift_data[35:32] + 4'd3;
			if(shift_data[31:28] > 4'd4)
				shift_data[31:28] <= shift_data[31:28] + 4'd3;
			if(shift_data[27:24] > 4'd4)
				shift_data[27:24] <= shift_data[27:24] + 4'd3;
			if(shift_data[23:20] > 4'd4)
				shift_data[23:20] <= shift_data[23:20] + 4'd3;
		
		end
	else if((shift_flag == 1'b1)&&(shift_cnt != SHIFT_MAX)&&(shift_cnt != SHIFT_MAX - 5'd1))
		shift_data <= shift_data << 44'd1;
	else 
		shift_data <= shift_data;
		




//hun_hun
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		hun_hun <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		hun_hun <= shift_data[43:40];
	else
		hun_hun <= hun_hun;
		
//ten_tho
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		ten_tho <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		ten_tho <= shift_data[39:36];
	else
		ten_tho <= ten_tho;
		
		
//tho
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tho <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		tho <= shift_data[35:32];
	else
		tho <= tho;
		
//hun
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		hun <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		hun <= shift_data[31:28];
	else
		hun <= hun;

//ten
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		ten <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		ten <= shift_data[27:24];
	else
		ten <= ten;
		
//unit
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		unit <= 4'b0;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		unit <= shift_data[23:20];
	else
		unit <= unit;
		
//sign_out 
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sign_out <= sign_temp;
	else if(shift_cnt == SHIFT_MAX - 5'd1)
		sign_out <= sign_temp;
	else
		sign_out <= sign_out;

endmodule
