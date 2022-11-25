`timescale 1ns/1ns
module tb_seg_dynamic();
reg 		sys_clk		;
reg			sys_rst_n	;
reg	[19:0]	data		;
reg	[5:0]	point		;
reg			sign		;
reg			seg_en		;

wire [7:0]	seg			;
wire [5:0]	sel			;

//initial
initial
	begin
		sys_clk = 1'b1		;
		sys_rst_n <= 1'b0	;	
		seg_en <= 1'b1		;
	#20
		sys_rst_n <= 1'b1	;
		data <= 20'd999_999	;
		sign <= 1'b0		;
		point <= 6'b000_010	;
	#3000
		data <= 20'd87_654 	;
		sign <= 1'b1		;
	#3000
		data <= 20'd987_654 ;
		sign <= 1'b0		;
		
	#3000
		data <= 20'd654_321	;
	#8000
		data <= 20'd12_345	;
		point <= 6'b001_000	;
	#8000
		seg_en <= 1'b0		;
	
	end


//sys_clk
always #10 sys_clk = ~sys_clk;






seg_dynamic
#(
	.CNT_SEG_MAX(16'd49)
)
seg_dynamic_inst
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.data		(data		),
	.point		(point		),
	.sign		(sign		),
	.seg_en		(seg_en		),

	.seg 		(seg 		),
	.sel        (sel        )
	
);

endmodule
