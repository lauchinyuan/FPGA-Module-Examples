module rs232_rx
(
	input 	wire		sys_clk		,
	input	wire 		sys_rst_n	,
	input 	wire		rx			,
	input 	wire		read_done	,
	
	output	reg	[7:0]	rx_data		,
	output	reg			flag_rxne	

);

reg			read_done_reg;	
reg			rx_reg1		;
reg			rx_reg2		;
reg			rx_reg		;
reg			start_flag	;
reg			data_en		;
reg	[12:0]	rx_cnt		;
reg			get_data_flag;
reg	[3:0]	data_cnt	;
reg	[7:0] 	data_reg	;
reg			finished	;



parameter 	RX_CNT_MAX	= 	13'd5207	;
parameter	DATA_CNT_MAX= 	4'd8		;


//rx_reg1
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rx_reg1	<= 1'b1;
	else
		rx_reg1 <= rx;
		
//rx_reg2
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rx_reg2	<= 1'b1;
	else
		rx_reg2 <= rx_reg1;

//rx_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rx_reg	<= 1'b1;
	else
		rx_reg <= rx_reg2;

//start_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		start_flag <= 1'b0;
	else if((rx_reg2 == 1'b0) && (rx_reg == 1'b1) && (data_en == 1'b0))
		start_flag <= 1'b1;
	else
		start_flag <= 1'b0;
		
//data_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_en <= 1'b0;
	else if(start_flag == 1'b1)
		data_en <= 1'b1;
	else if((data_cnt == DATA_CNT_MAX) && (get_data_flag == 1'b1))
		data_en <= 1'b0;
	else
		data_en <= data_en;
		
//rx_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rx_cnt <= 13'd0;
	else if(data_en == 1'b0)
		rx_cnt <= 13'd0;
	else if(rx_cnt == RX_CNT_MAX)
		rx_cnt <= 13'd0;
	else
		rx_cnt <= rx_cnt + 13'd1;
		
//get_data_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		get_data_flag <= 1'b0;
	else if(rx_cnt == (RX_CNT_MAX/13'd2))
		get_data_flag <= 1'b1;
	else
		get_data_flag <= 1'b0;

//data_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_cnt <= 4'd0;
	else if((data_cnt == DATA_CNT_MAX) && (get_data_flag == 1'b1))
		data_cnt <= 4'd0;
	else if(get_data_flag == 1'b1)
		data_cnt <= data_cnt + 4'd1;
	else
		data_cnt <= data_cnt;

//data_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_reg <= 8'd0;
	else if((data_cnt > 4'd0) && (get_data_flag == 1'b1))
		data_reg <= {rx_reg,data_reg[7:1]};
	else
		data_reg <= data_reg;
		
//finished
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		finished <= 1'b0;
	else if((data_cnt == DATA_CNT_MAX) && (get_data_flag == 1'b1))
		finished <= 1'b1;
	else
		finished <= 1'b0;
		
//read_done_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		read_done_reg <= 1'b1;
	else 
		read_done_reg <= read_done;
		

		
//flag_rxne
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		flag_rxne <= 1'b0;
	else if(finished == 1'b1)
		flag_rxne <= 1'b1;
	else if((read_done == 1'b0) && (read_done_reg == 1'b1))
		flag_rxne <= 1'b0;
	else
		flag_rxne <= flag_rxne;

//rx_data
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rx_data <= 8'b0;
	else if((finished == 1'b1) && (flag_rxne == 1'b0))
		rx_data <= data_reg;
	else
		rx_data <= rx_data;


endmodule