module beep
#(parameter Timer_500ms = 25'd24_999_999)
(
	input 	wire 	sys_clk,
	input 	wire 	sys_rst_n,
	
	output 	reg		out
);
reg [24:0] 		cnt;
reg [2:0]		cnt_500ms;
reg [17:0]		max_cnt;
reg [17:0]		freq_cnt;
reg [16:0]		duty;

parameter Do_MAX_CNT = 18'd190_839,
		  Ra_MAX_CNT = 18'd170_067,
		  Mi_MAX_CNT = 18'd151_514,
		  Fa_MAX_CNT = 18'd143_265,
		  So_MAX_CNT = 18'd127_550,
		  La_MAX_CNT = 18'd113_635,
		  Ti_MAX_CNT = 18'd101_213;
		  
parameter Do_DUTY = 17'd95_419,
		  Ra_DUTY = 17'd85_033,
		  Mi_DUTY = 17'd75_756,
		  Fa_DUTY = 17'd71_632,
		  So_DUTY = 17'd63_774,
		  La_DUTY = 17'd56_817,
		  Ti_DUTY = 17'd50_606;
parameter CNT_500MS_MAX = 3'd6;

//cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 25'd0;
	else if(cnt == Timer_500ms)
		cnt <= 25'd0;
	else 
		cnt <= cnt + 25'd1;
		
//cnt_500ms
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_500ms <= 3'd0;
	else if((cnt_500ms == CNT_500MS_MAX) && (cnt == Timer_500ms))
		cnt_500ms <= 3'd0;
	else if(cnt == Timer_500ms)
		cnt_500ms <= cnt_500ms + 3'd1;
	else
		cnt_500ms <= cnt_500ms;
		
//max_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		max_cnt <= Do_MAX_CNT;
	else case(cnt_500ms)
		3'd0:
		max_cnt <= Do_MAX_CNT;
		3'd1:
		max_cnt <= Ra_MAX_CNT;
		3'd2:
		max_cnt <= Mi_MAX_CNT;
		3'd3:
		max_cnt <= Fa_MAX_CNT;
		3'd4:
		max_cnt <= So_MAX_CNT;
		3'd5:
		max_cnt <= La_MAX_CNT;
		3'd6:
		max_cnt <= Ti_MAX_CNT;
		default:
		max_cnt <= Do_MAX_CNT;
		endcase

//duty
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		duty <= Do_DUTY;
	else case(cnt_500ms)
		3'd0:
		duty <= Do_DUTY;
		3'd1:         
		duty <= Ra_DUTY;
		3'd2:         
		duty <= Mi_DUTY;
		3'd3:         
		duty <= Fa_DUTY;
		3'd4:         
		duty <= So_DUTY;
		3'd5:         
		duty <= La_DUTY;
		3'd6:         
		duty <= Ti_DUTY;
		default:      
		duty <= Do_DUTY;
		endcase

//freq_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		freq_cnt <= 18'd0;
	else if(freq_cnt == max_cnt)
		freq_cnt <= 18'd0;
	else 
		freq_cnt <= freq_cnt + 18'd1;

//out
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		out <= 1'b1;
	else if(freq_cnt <= duty)
		out <= 1'b1;
	else 
		out <= 1'b0;

endmodule