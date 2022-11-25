`timescale 1ns/1ns
module tb_dht11();
reg			sys_clk		;
reg			sys_rst_n	;
reg			key			;
	
wire		data_inout	;

wire [5:0]	sel			;
wire [7:0]	seg			;
reg			data_out	;
reg 		link		;

parameter 	D_40MS	=	40_000_000	,
			D_30MS	= 	30_000_000	,
			D_30US	= 	30_000		,
			D_80US	= 	80_000		,
			D_1000MS= 	1000_000_000,
			D_200MS	= 	200_000_000	,
			
			D_50US	= 	50_000		,
			D_27US	= 	27_000		,
			D_70US	=	70_000		;


initial
	begin
	sys_clk	= 1'b1;
	sys_rst_n <= 1'b0;
	key	<= 1'b1;
	data_out <= 1'b1;
	link	<= 1'b1;
	#30
	sys_rst_n <= 1'b1;
	#D_1000MS 
	link	<= 1'b0;  //释放控制权
	#D_30MS			//DHT11至少需要获得18ms的总线控制权
	link	<= 1'b1; //收回控制权
	data_out <= 1'b1;
	#D_30US
	
	//响应ASK
	data_out <= 1'b0;
	#D_80US
	data_out <= 1'b1;
	#D_80US
	

//测试数据1,温度：24.26,湿度70,数据流：01000110_00000000__00011000_00011010__01111000
	//数据部分
	
	//bit[39]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[38]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[37]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[36]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[35]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[34]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[33]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[32]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[31]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[30]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[29]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[28]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[27]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[26]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[25]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[24]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	
	//bit[23]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[22]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[21]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[20]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[19]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[18]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[17]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[16]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[15]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[14]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[13]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[12]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[11]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[10]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[9]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[8]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	
	//bit[7]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[6]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[5]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[4]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[3]
	//1
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_70US	
	
	//bit[2]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[1]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	//bit[0]
	//0
	data_out <= 1'b0;
	#D_50US
	data_out <= 1'b1;
	#D_27US
	
	data_out <= 1'b0;


	end
	
//sys_clk
always#10 sys_clk = ~sys_clk;


//data_inout
assign data_inout = (link)?data_out : 1'bz;





dht11 dht11_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.key_in			(key		),

	.data_inout		(data_inout	),

	.sel			(sel		),
	.seg		    (seg		)

	
);

endmodule