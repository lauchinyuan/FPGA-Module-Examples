`timescale 1ns/1ns
module tb_simple_dsp();
	reg 		clk					;
	reg		rst_n					;
	
	wire [36:0] fir_out			;
	wire [11:0] fir_in			;
	wire [9:0] 	s1					;
	wire [9:0] 	s2					;
	wire [9:0] 	s3					;
	wire [31:0] fir2fifo			;
	wire [31:0] fft_out_imag	;
	wire [31:0] fft_out_real	;
	wire 			fft_out_sop		;
	wire			fft_out_eop		;
	wire			fft_out_valid	;
	
	//test
	wire 			fft_in_valid_o	   ;
	wire 			fft_ready_o	    	;
	wire 			fft_sop_o1		   ;
	wire 			fft_eop_o1		   ;
	wire 			fifo_full_o	    	;
	wire 			fifo_rdreq_o 		;
	wire [9:0] 	fft_out_cnt			;
	wire [9:0] 	cnt_fft_o 			;
	wire [31:0] fifo_out_o			;
	
	initial begin
		clk = 1'b1;
		rst_n <= 1'b0;
	#60
		rst_n <= 1'b1;
	
	end
	
	always #10 clk = ~clk;

	simple_dsp simple_dsp_inst
	(
		.clk					(clk				),
		.rst_n				(rst_n			),
	
		.fir_in				(fir_in			),
		.s1					(s1				),
		.s2					(s2				),
		.s3					(s3				),
		.fir_out				(fir_out			),
		.fir2fifo			(fir2fifo		),	
		.fft_out_valid		(fft_out_valid	),
		.fft_out_imag		(fft_out_imag	),
		.fft_out_real		(fft_out_real	),
		.fft_out_sop		(fft_out_sop	),
		.fft_out_eop		(fft_out_eop	),
		.fft_out_cnt 		(fft_out_cnt	),
			
		//test	
		.fft_in_valid_o	(fft_in_valid_o),
		.fft_ready_o		(fft_ready_o	),
		.fft_sop_o1			(fft_sop_o1		),
		.fft_eop_o1			(fft_eop_o1		),
		
		.fifo_full_o		(fifo_full_o	),
		.fifo_rdreq_o 	   (fifo_rdreq_o 	),
		.cnt_fft_o 			(cnt_fft_o		),
		.fifo_out_o			(fifo_out_o		)
		
	);

endmodule 