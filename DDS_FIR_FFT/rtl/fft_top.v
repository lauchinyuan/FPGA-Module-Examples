module fft_top
(
	input wire				clk				,
	input wire				rst_n				,
	input wire	[31:0] 	data_in			,
	input wire				fir_valid		,  // FIR滤波器输出数据有效
	
	output wire				fft_out_valid	,
	output wire	[31:0] 	fft_out_real	,
	output wire	[31:0]	fft_out_imag	,
	output wire				fft_out_sop		,
	output wire				fft_out_eop		,
	
	//记录fft输出的序号，方便仿真观察结果
	output reg	[9:0]		fft_out_cnt  	,
	
	//将中间变量输出方便观察分析
	output wire				fft_in_valid_o	,
	output wire				fft_ready_o		,
	output wire				fft_sop_o1		,
	output wire				fft_eop_o1		,
	output wire				fifo_full_o		,
	output wire				fifo_rdreq_o 	,
	output wire [9:0] 	cnt_fft_o		,
	output wire [31:0] 	fifo_out_o		
	
);

	parameter N = 10'd512;  // FFT点数

	wire [31:0]		fifo_out		;//FIFO输出数据
	wire				fifo_full	;//FIFO满
	
	wire 				fifo_rdreq	;	
	wire 				fft_sop		;
	wire 				fft_eop		;
	wire 				fft_in_valid;   
	wire				fft_ready	;
	
	
	
	//例化fifo模块
	fifo_ip fifo_32x512 
	(
		.clock		(clk				),
		.data			(data_in			),  
		.rdreq		(fifo_rdreq		),   
		
		// 当FIR滤波器的输出信号有效就将其存入fifo中，fifo若存满将自动停止存储
		.wrreq		(fir_valid		),
		.empty		(					),
		.full			(fifo_full		),
		.q       	(fifo_out		)
	);
	
	//例化fifo_fft_ctrl控制模块
	fifo_fft_ctrl fifo_fft_ctrl_inst
	(
		.clk				(clk			),
		.rst_n			(rst_n		),
		.fir_valid		(fir_valid	), //fir滤波有效标志
		.fft_ready		(fft_ready	), //代表fft单元可以接收输入
		.fifo_empty		(				), 
		.fifo_full		(fifo_full	), //FIFO存满

		.fifo_rdreq		(fifo_rdreq		),
		.fft_sop			(fft_sop			),  //fft数据输入的开始标志
		.fft_eop			(fft_eop			),  //fft数据输入的结尾标志
		.fft_in_valid  (fft_in_valid  ),	//输入fft的数据有效
		.cnt_fft_o 		(cnt_fft_o)	
		
	);

	fft_ip fft_inst (
			.clk				(clk		),          //    clk.clk
			.reset_n			(rst_n	),      //    rst.reset_n
			.sink_valid		(fft_in_valid),   //   sink.sink_valid
			.sink_ready		(fft_ready),   //       .sink_ready
			.sink_error		(2'b0),   //       .sink_error
			.sink_sop		(fft_sop),     //       .sink_sop
			.sink_eop		(fft_eop),     //       .sink_eop
			.sink_real		(fifo_out),    //       .sink_real
			.sink_imag		(32'b0),    //       .sink_imag
			
			.inverse			(1'b0),      //       .inverse
			.source_valid	(fft_out_valid), // source.source_valid
			.source_ready	(1'b1), //       .source_ready
			.source_error	(), //       .source_error
			.source_sop		(fft_out_sop),   // .source_sop
			.source_eop		(fft_out_eop),   // .source_eop
			.source_real	(fft_out_real),  // .source_real
			.source_imag	(fft_out_imag),  //.source_imag
			.source_exp		(				)   
	);
	
	
	//cnt_fft_out_cnt用于记录输出FFT的序号，方便在Modelsim中观察
	//由于是时序电路，会比实际数据输出延迟一个时间单位
	always @ (posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0) begin
			fft_out_cnt <= 10'd0;
		end else if(fft_out_cnt == 10'd512) begin
		//计数到最大值
			fft_out_cnt <= 10'd0;
		end else if(fft_out_valid) begin
			fft_out_cnt <= fft_out_cnt + 10'd1;
		end else begin
			fft_out_cnt <= 10'd0;
		end
	end
	
	
	//将中间变量输出方便观察分析
	assign fft_in_valid_o 	= fft_in_valid	;
	assign fft_ready_o	 	= fft_ready		;
	assign fft_sop_o1	 		= fft_sop		;
	assign fft_eop_o1	 		= fft_eop		;
	assign fifo_full_o  		= fifo_full		;
	assign fifo_rdreq_o 		= fifo_rdreq	;
	assign fifo_out_o 		= fifo_out		;
	
endmodule