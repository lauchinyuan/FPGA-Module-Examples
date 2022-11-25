`timescale 1ns/1ns
module tb_bcd8421();
reg 		sys_clk;
reg			sys_rst_n;
reg			sign;
reg  [19:0]	data;
wire [3:0]	unit;
wire [3:0]	ten;
wire [3:0]	hun;
wire [3:0]	tho;
wire [3:0]	ten_tho;
wire [3:0]	hun_hun;
wire		sign_out;


//initial
initial 
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		data <= 20'd0;
		sign <= 1'b1;
		#20
		sys_rst_n <= 1'b1;
		#3000
		data <= 20'd999_999;
		#3000
		data <= 20'd987_654;
		sign <= 1'b0;
		#3000
		data <= 20'd981_106;
		#2500
		sign <= 1'b1;
		data <= 20'd123_456;
		#2400
		sign <= 1'b0;
		data <= 20'd99_12_30;
		
	end

//sys_clk
always #10 sys_clk = ~sys_clk;



bcd8421
#(
	.SHIFT_MAX(5'd21)
)
bcd8421_inst
(
	.	sys_clk		(sys_clk),
	.	sys_rst_n	(sys_rst_n),
	.	data		(data),
	.	sign		(sign),
	
	.	unit		(unit),
	.	ten			(ten),
	.	hun			(hun),
	.	tho			(tho),
	.	ten_tho		(ten_tho),
	.	hun_hun	    (hun_hun),
	.	sign_out	(sign_out)
	
);


endmodule
