module rs232_tx
(
	input 	wire		sys_clk		,
	input 	wire		sys_rst_n	,
	input	wire [7:0]	data_in		,
	input 	wire		data_flag	,

	output 	reg			tx			,
	output	reg			flag_txe	

);

reg			data_flag_reg		;
reg			tx_cnt_en			;
reg			tx_get_data			;
reg	[7:0]	data_reg			;
reg	[12:0]	tx_cnt   			;
reg	[3:0]	bit_cnt				;	

parameter TX_CNT_MAX = 13'd5207;
parameter BIT_CNT_MAX = 4'd11;

//data_flag_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_flag_reg <= 1'b0;
	else 
		data_flag_reg <= data_flag;

//tx_cnt_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tx_cnt_en <= 1'b0;
	else if((data_flag == 1'b1) && (data_flag_reg == 1'b0))
		tx_cnt_en <= 1'b1;
	else if((tx_cnt == TX_CNT_MAX) && (bit_cnt == BIT_CNT_MAX))
		tx_cnt_en <= 1'b0;
	else if(data_flag_reg == 1'b1)
		tx_cnt_en <= 1'b1;
	else
		tx_cnt_en <= tx_cnt_en;
		
//tx_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tx_cnt <= 13'd0;
	else if((tx_cnt_en == 1'b1) && (tx_cnt == TX_CNT_MAX))
		tx_cnt <= 13'd0;
	else if(tx_cnt_en == 1'b1)
		tx_cnt <= tx_cnt + 13'd1;
	else
		tx_cnt <= tx_cnt;
		
		
//bit_cnt
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		bit_cnt <= 4'd0;
	else if((tx_cnt == TX_CNT_MAX ) && (bit_cnt == BIT_CNT_MAX))
		bit_cnt <= 4'd0;
	else if(tx_cnt == TX_CNT_MAX)
		bit_cnt <= bit_cnt + 4'd1;
	else
		bit_cnt <= bit_cnt;

//tx_get_data
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tx_get_data <= 1'b0;
	else if((tx_cnt == 13'd1) && (bit_cnt == 4'd0))
		tx_get_data <= 1'b1;
	else
		tx_get_data <= 1'b0;
		
//data_reg 
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_reg <= 8'b0;
	else if(tx_get_data == 1'b1)
		data_reg <= data_in;
	else
		data_reg <= data_reg;
		
//flag_txe
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		flag_txe <= 1'b1;
	else
		flag_txe <= ~tx_cnt_en;
		
//tx
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tx <= 1'b1;
	else case(bit_cnt)
	4'd00:		tx <= 1'b1;
	4'd01:		tx <= 1'b1;
	4'd02:		tx <= 1'b0;
	4'd03:		tx <= data_reg[0];
	4'd04:		tx <= data_reg[1];
	4'd05:		tx <= data_reg[2];
	4'd06:		tx <= data_reg[3];
	4'd07:		tx <= data_reg[4];
	4'd08:		tx <= data_reg[5];
	4'd09:		tx <= data_reg[6];
	4'd10:		tx <= data_reg[7];
	4'd11:		tx <= 1'b1;
	default:	tx <= 1'b1;
	endcase




endmodule


