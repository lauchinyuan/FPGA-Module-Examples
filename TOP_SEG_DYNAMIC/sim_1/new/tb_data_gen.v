`timescale 1ns/1ns
module tb_data_gen();
reg 	sys_clk;
reg		sys_rst_n;

wire 	[19:0]data;
wire	[5:0]point;
wire 	seg_en;
wire 	sign;

//initial
initial
	begin
	sys_clk = 1'b1;
	sys_rst_n <= 1'b0;
	#20
	sys_rst_n <= 1'b1;
	end

//sys_clk
always #10 sys_clk = ~sys_clk;


data_gen
#(	.CNT_MAX(23'd49),
	.DATA_MAX(20'd999_999))
data_gen_inst
(
	.sys_clk		(sys_clk),
	.sys_rst_n		(sys_rst_n),

	.data			(data),
	.point			(point),
	.seg_en			(seg_en),
	.sign           (sign)

);


endmodule


