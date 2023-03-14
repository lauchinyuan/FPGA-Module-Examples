module signal__gen
(
	input wire 				clk		,
	input wire 				rst_n		,
	output wire [9:0] 	s1			,
	output wire	[9:0] 	s2			,
	output wire	[9:0] 	s3			,
	output wire [11:0] 	signal_out,   //三个信号相加后为了使得数据不溢出，需要增加2位
	output wire				out_valid			
);

	wire [9:0] fsin_o1, fsin_o2, fsin_o3;  //三个信号产生器输出量
	wire [11:0] fsin_o1_ext, fsin_o2_ext, fsin_o3_ext; //有符号扩展
	wire			out_valid1, out_valid2, out_valid3; //三个信号产生器有效标志

	//不同的相位增量，可以产生不同的频率
	parameter 	INC_100k		=32'd8589935,
					INC_750k		=32'd64424509,
					INC_1M		=32'd85899346;

	nco_ip nco_100k (
			.clk				(clk			), // clk.clk
			.clken			(1'b1			), //  in.clken
			.phi_inc_i		(INC_100k	), // .phi_inc_i
			.fsin_o			(fsin_o1		), // out.fsin_o
			.out_valid		(out_valid1	), // .out_valid
			.reset_n    	(rst_n      )	// rst.reset_n
		);
		
	nco_ip nco_750k (
			.clk				(clk			), // clk.clk
			.clken			(1'b1			), //  in.clken
			.phi_inc_i		(INC_750k	), // .phi_inc_i
			.fsin_o			(fsin_o2		), // out.fsin_o
			.out_valid		(out_valid2	), // .out_valid
			.reset_n    	(rst_n  	   )	// rst.reset_n
		);

	nco_ip nco_1M (
			.clk				(clk			), // clk.clk
			.clken			(1'b1			), //  in.clken
			.phi_inc_i		(INC_1M		), //.phi_inc_i
			.fsin_o			(fsin_o3		), // out.fsin_o
			.out_valid		(out_valid3	), // .out_valid
			.reset_n    	(rst_n      )	// rst.reset_n
		);	
	
	//无符号数加法需要将操作数进行符号位扩展再相加
	assign fsin_o1_ext = {{2{fsin_o1[9]}},fsin_o1};
	assign fsin_o2_ext = {{2{fsin_o2[9]}},fsin_o2};
	assign fsin_o3_ext = {{2{fsin_o3[9]}},fsin_o3};

	//三个信号相加后为了使得数据不溢出，需要增加位宽
	assign signal_out = fsin_o1_ext + fsin_o2_ext + fsin_o3_ext;
	
	//输出有效信号，只有当三个信号都有效时，才认为有效
	assign out_valid = out_valid1 & out_valid2 & out_valid3;
	
	//在使用quartus联合Modelsim进行RTL级仿真时出现bug,但可进行门级仿真	
	//加入这三句是为了进行顶层模块门级仿真直接观看中间数据的波形
	assign s1 = fsin_o1;
	assign s2 = fsin_o2;	
	assign s3 = fsin_o3;		


endmodule