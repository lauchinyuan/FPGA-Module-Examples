`timescale 1ns/1ns
module tb_top_seg_dynamic();
reg 			sys_clk		;
reg				sys_rst_n	;
wire 	[5:0]	sel			;
wire	[7:0]	seg			;

//initial
initial
	begin
		sys_clk = 1'b1;
		sys_rst_n	<= 1'b0;
		#30
		sys_rst_n 	<= 1'b1;
	
	end


//sys_clk
always #10 sys_clk = ~sys_clk;



top_seg_dynamic top_seg_dynamic_inst
(
	.sys_clk		(sys_clk)	,
	.sys_rst_n		(sys_rst_n)	,

	.sel			(sel)		,
	.seg            (seg)
);

endmodule



