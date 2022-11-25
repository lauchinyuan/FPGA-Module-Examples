`timescale 1ns/1ns
module tb_divider_five();
reg sys_clk;
reg sys_rst_n;

wire out_clk;

initial
	begin
		sys_clk 	= 	1'b1;
		sys_rst_n 	<= 	1'b0;
		#20
		sys_rst_n 	<= 	1'b1;
		
	end
	
always #10	sys_clk = ~sys_clk;
	
divider_five
#(.MAX_CNT(3'd5))
divider_five_inst
(
	.sys_clk		(sys_clk),
	.sys_rst_n		(sys_rst_n),

	.out_clk        (out_clk)
);

endmodule


