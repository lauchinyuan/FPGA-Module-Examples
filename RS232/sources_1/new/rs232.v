module rs232
(
	input 	wire		sys_clk		,
	input	wire 		sys_rst_n	,
	input 	wire		rx			,
	
	output 	wire		tx			,
	output	wire		flag_txe	

);
wire 					read_done_txe		;
wire		[7:0]		data_interface		;
wire					data_flag_interface	;

assign flag_txe = read_done_txe;


rs232_rx rx_inst
(
	.sys_clk		(sys_clk			),
	.sys_rst_n		(sys_rst_n			),
	.rx				(rx					),
	.read_done		(read_done_txe   	),  

	.rx_data		(data_interface		),  
	.flag_rxne	    (data_flag_interface)   

);





rs232_tx tx_inst
(
	.sys_clk		(sys_clk				),
	.sys_rst_n		(sys_rst_n				),
	.data_in		(data_interface			), 
	.data_flag		(data_flag_interface	),

	.tx				(tx						),
	.flag_txe		(read_done_txe			)

);

endmodule
