//顶层模块
module simple_dsp
(
	input wire				clk				,
	input wire				rst_n				,
	
	output wire [11:0] 	fir_in			,
	output wire [9:0] 	s1					,
	output wire	[9:0] 	s2					,
	output wire	[9:0] 	s3					,
	output wire	[36:0]	fir_out			,
	output wire [31:0]  	fir2fifo			,	
	output wire 			fft_out_valid	,
	output wire	[31:0]	fft_out_imag	,
	output wire	[31:0] 	fft_out_real	,
	output wire				fft_out_sop		,
	output wire				fft_out_eop		,
	output wire	[9:0]		fft_out_cnt 	,
	
	//test 以下都是中间变量信号，方便在仿真时观察
	output wire				fft_in_valid_o	,
	output wire				fft_ready_o		,
	output wire				fft_sop_o1		,
	output wire				fft_eop_o1		,
		
	output wire				fifo_full_o		,
	output wire				fifo_rdreq_o 	,
	output wire [9:0] 	cnt_fft_o		,
	output wire [31:0] 	fifo_out_o
);
	wire [11:0]				signal_out		;
	wire						signal_valid	;
	wire						fir_valid		;

	//信号发生器例化
	signal__gen signal__gen_inst
	(
		.clk					(clk			),
		.rst_n				(rst_n		),
		
		.s1					(s1			),
		.s2					(s2			),
		.s3					(s3			),
		.signal_out			(signal_out	),   
		.out_valid			(signal_valid)
	);
	
	//滤波器例化
	filter fir_inst
	(
		.clk				(clk			),
		.rst_n			(rst_n		),
		.data_in			(signal_out	),	
		.data_valid		(signal_valid),

		.data_out		(fir_out		),
		.fir_valid	   (fir_valid	)
	
	);
	
	
	// fft例化
	fft_top fft_inst
	(
		.clk				(clk		),
		.rst_n			(rst_n	),
		.data_in			(fir2fifo	),
		.fir_valid		(fir_valid	),  // FIR滤波器输出数据有效

		.fft_out_valid	(fft_out_valid	),
		.fft_out_real	(fft_out_real	),
		.fft_out_imag	(fft_out_imag	),
		.fft_out_sop	(fft_out_sop	),
		.fft_out_eop	(fft_out_eop	),
		.fft_out_cnt 	(fft_out_cnt	),
		
			//test
		.fft_in_valid_o	(fft_in_valid_o),
		.fft_ready_o		(fft_ready_o	),
		.fft_sop_o1			(fft_sop_o1		),
		.fft_eop_o1			(fft_eop_o1		),
		
		.fifo_full_o		(fifo_full_o	),
		.fifo_rdreq_o 	   (fifo_rdreq_o 	),
		.cnt_fft_o 			(cnt_fft_o		),
		.fifo_out_o			(fifo_out_o)
		
	);
	
	//在使用quartus联合Modelsim进行RTL级仿真时出现bug,但可进行门级仿真	
	//加入这句是为了进行顶层模块门级仿真直接观看FIR输入信号的波形
	assign fir_in 	= signal_out;
	
	//FFT输入数据位宽有限，这里将低位舍去
	assign fir2fifo = fir_out[36:5];
	

endmodule 