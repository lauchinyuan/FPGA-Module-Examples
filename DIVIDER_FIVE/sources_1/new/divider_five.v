`timescale 1ns/1ns
module divider_five
#(parameter MAX_CNT = 3'd5)
(
	input  	wire 		sys_clk		,
	input 	wire 		sys_rst_n	,
	
	output 	wire		out_clk
);
reg [2:0] cnt;
reg clk1;
reg clk2;

//cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 3'd0;
	else if(cnt == MAX_CNT - 3'd1)
		cnt <= 3'd0;
	else
		cnt <= cnt + 3'd1;
//clk1
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		clk1 <= 1'b0;
	else if((cnt == MAX_CNT - 3'd3)||(cnt == MAX_CNT - 3'd2))
		clk1 <= 1'b1;
	else
		clk1 <= 1'b0;

//clk2
always@(negedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		clk2 <= 1'b0;
	else if((cnt == MAX_CNT - 3'd3)||(cnt == MAX_CNT - 3'd2))
		clk2 <= 1'b1;
	else
		clk2 <= 1'b0;

assign out_clk = clk1 | clk2;

endmodule









