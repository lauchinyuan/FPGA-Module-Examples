module filter
(
	input wire 					clk			,
	input wire					rst_n			,
	input wire		[11:0] 	data_in		,	
	input wire					data_valid	,
	
	output	wire	[36:0]	data_out		, //滤波器输出数据
	output	wire				fir_valid	
	
);


	fir_ip fir_inst(
		.clk(clk),              //                     clk.clk
		.reset_n(rst_n),          //                     rst.reset_n
		.ast_sink_data(data_in),    //   avalon_streaming_sink.data
		.ast_sink_valid(data_valid),   //                        .valid
		.ast_sink_error(),   //                        .error
		.ast_source_data(data_out),  // avalon_streaming_source.data
		.ast_source_valid(fir_valid), //                        .valid
		.ast_source_error()  //                        .error
	);


endmodule 