module key_filter
#(parameter	MAX_CNT = 20'd999_999)   //20MS
(
	input 	wire 	sys_clk,
	input 	wire 	sys_rst_n,
	input 	wire	key_in,
	
	output	reg		key_out

);
reg [19:0]	cnt;

//cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 20'd0;	
	else if((key_in == 1'b0)&&(cnt != MAX_CNT))
		cnt <= cnt + 20'd1;
	else if(key_in == 1'b1)
		cnt <= 20'd0;

//key_out
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_out <= 1'b0;	
	else if(cnt == MAX_CNT - 20'd1)
		key_out <= 1'b1;
	else if(cnt == MAX_CNT)
		key_out <= 1'b0;
	else
		key_out <= key_out;


endmodule