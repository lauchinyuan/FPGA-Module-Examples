`timescale 1ns/1ns
module tb_beep();
reg sys_clk;
reg sys_rst_n;
wire out;

//initial
initial
	begin
	sys_clk = 1'b1;
	sys_rst_n <= 1'b0;
	#20
	sys_rst_n <= 1'b1;
	
	end

//sys_clk
always #10	sys_clk = ~sys_clk;


beep
#(.Timer_500ms(25'd24_999_999))
beep_inst1
(
	.sys_clk		(sys_clk),
	.sys_rst_n		(sys_rst_n),

	.out            (out)
);

endmodule

