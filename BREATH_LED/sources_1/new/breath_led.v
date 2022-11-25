module breath_led
(
	input 	wire 		sys_clk,
	input 	wire 		sys_rst_n,
	
	
	output 	reg			led_out

);

parameter	CNT_1US_MAX	= 6'd49,
			CNT_1MS_MAX	= 10'd999,
			CNT_1S_MAX	= 10'd999;

reg [5:0] cnt_1us;
reg	[9:0] cnt_1ms;
reg [9:0] cnt_1s;

//cnt_1us
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_1us <= 6'd0;
	else if(cnt_1us == CNT_1US_MAX)
		cnt_1us <= 6'd0;
	else
		cnt_1us <= cnt_1us + 6'd1;
		
//cnt_1ms
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_1ms <= 10'd0;
	else if((cnt_1ms == CNT_1MS_MAX)&&(cnt_1us == CNT_1US_MAX))
		cnt_1ms <= 10'd0;
	else if (cnt_1us == CNT_1US_MAX)
		cnt_1ms <= cnt_1ms + 10'd1;
	else
		cnt_1ms <= cnt_1ms;

	
//cnt_1s
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_1s <= 10'd0;
	else if((cnt_1s == CNT_1S_MAX)&&(cnt_1ms == CNT_1MS_MAX)&&(cnt_1us == CNT_1US_MAX))
		cnt_1s <= 10'd0;
 	else if ((cnt_1ms == CNT_1MS_MAX)&&(cnt_1us == CNT_1US_MAX))
		cnt_1s <= cnt_1s + 10'd1;
	else
		cnt_1s <= cnt_1s;

//led_out
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		led_out <= 1'b1;
	else if(cnt_1ms <= cnt_1s)
		led_out <= 1'b0;
	else 
		led_out <= 1'b1;


endmodule

