`timescale 1ns/1ns
module tb_inf_decoder();
reg			sys_clk		;
reg			sys_rst_n	;
reg			inf_in		;

wire		repeat_en	;
wire [19:0]	data_out	;

parameter 	T9000U	= 	9_000_000	,
			T4500U	= 	4_500_000	,
			T560U	=	560_000		,
			T1690U	=	1_690_000	,
			T2250U	= 	2_250_000	,
			T50000U = 	50_000_000	,
			T100000U=	100_000_000	;
			
			

//initial
initial
	begin
		sys_clk = 1'b1		;
		sys_rst_n <= 1'b0	;
		inf_in	 <= 1'b1	;
	#20
		sys_rst_n <= 1'b1	;
		
//INTRODUCE
	#300
		inf_in	<= 	1'b0	;
	#T9000U
		inf_in  <= 	1'b1	;
	#T4500U
//ADDR_S
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U
	
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	

//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	

//ADDR_C
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	
	
//DATA_S
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//DATA_C
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	
	
//0
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T560U	
	
//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U	

//1
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
	#T1690U
		
//stop bit
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;	

#T50000U
//repeat
		inf_in 	<= 	1'b0	;
	#T9000U
		inf_in	<= 	1'b1	;
	#T2250U
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;
		
#T100000U
//repeat
		inf_in 	<= 	1'b0	;
	#T9000U
		inf_in	<= 	1'b1	;
	#T2250U
		inf_in	<= 	1'b0	;
	#T560U
		inf_in 	<= 	1'b1	;


	end

always #10	sys_clk = ~sys_clk;

inf_decoder inf_decoder_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.inf_in			(inf_in		),

	.repeat_en		(repeat_en	),
	.data_out		(data_out	)	
);

endmodule