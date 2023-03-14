`timescale 1ns/1ns
module tb_signal__gen();
	reg			clk			;
	reg			rst_n			;

	wire [11:0] signal_out	;	
	wire 			out_valid	;
	
	wire [9:0] s1				;
	wire [9:0] s2				;
	wire [9:0] s3				;
	
	
	initial begin
		clk = 1'b1;
		rst_n <= 1'b0;
	#200
		rst_n <= 1'b1;
	
	end
	
	always #10 clk = ~clk;

	signal__gen signal_gen__inst
	(
		.clk			(clk			),
		.rst_n		(rst_n		), 
		
		.s1			(s1			),
		.s2			(s2			),
		.s3			(s3			),
		.signal_out	(signal_out	),   //三个信号相加后为了使得数据不溢出，需要增加位宽
		.out_valid	(out_valid	)	 //输出有效信号，只有当三个信号都有效时，才认为有效
	);
	
	

endmodule