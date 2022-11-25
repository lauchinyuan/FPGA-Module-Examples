`timescale 1ns/1ns
module tb_ad_ctrl();
reg				sys_clk		;
reg				sys_rst_n	;
reg		[7:0]	ad_data		;

wire 			ad_clk		;
wire			sign		;
wire 	[19:0]	data		;
reg  	[20:0]	ad_data_reg	;

reg				sign_ad_gen	;
reg		[12:0]	volt_ad_gen	;
reg				gen_en		;

parameter 	M		 = 8'd127	,
			VOLT_MAX = 13'd5000;
//initial
initial
	begin	
		sys_clk  = 1'b1;
		sys_rst_n <= 1'b0;
		sign_ad_gen <= 1'b0	;
		gen_en <= 1'b0;
		
	#20
		sys_rst_n <= 1'b1;
	#83000
		gen_en <= 1'b1;
		
	#186000
		sign_ad_gen <= 1'b1	;
	end

//sys_clk
always #10 sys_clk = ~sys_clk;

//volt_ad_gen
always@(posedge ad_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		volt_ad_gen <= 13'd0;
	else if(gen_en == 1'b0)
		volt_ad_gen <= 13'd0;
	else if(volt_ad_gen == VOLT_MAX)
		volt_ad_gen <= 13'd0;
	else
		volt_ad_gen <= volt_ad_gen + 13'd1;

//ad_data_reg
always@(posedge ad_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		ad_data_reg <= 5000 * M;
	else if(sign_ad_gen == 1'b0)  //postive
		ad_data_reg <= volt_ad_gen * (8'd255 - M) + 5000 * M;
	else
		ad_data_reg <= (5000 - volt_ad_gen) * M;
		
//ad_data
always@(posedge ad_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		ad_data <= M;
	else
		ad_data <= ad_data_reg / 5000;



ad_ctrl ad_ctrl_inst
(
	.sys_clk		(sys_clk		),
	.sys_rst_n		(sys_rst_n		),
	.ad_data		(ad_data		),

	.ad_clk			(ad_clk			),
	.sign			(sign			),
	.data           (data           )

);

endmodule