module wave_ctrl
(
	input 	wire		sys_clk		,
	input 	wire		sys_rst_n	,
	input	wire [3:0]	wave_sel	,
	
	output	wire [7:0]	dac_data	

);
reg	[31:0]		pharse_add		;
reg	[11:0]		addr_reg		;
reg	[13:0]		addr			;

parameter	P_WORD	= 	32'd262144,
			A_WORD	= 	12'd0,
			P_MAX	= 	32'hffffffff,
			A_MAX	= 	12'hfff;

//pharse_add
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		pharse_add <= 32'd0;
	else if(pharse_add == P_MAX)
		pharse_add <= 32'd0;
	else
		pharse_add <= pharse_add + P_WORD;
		
//addr_reg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr_reg <= 12'd0;
	else if(addr_reg == A_MAX)
		addr_reg <= 12'd0;
	else
		addr_reg <= pharse_add[31:20] + P_WORD;

//addr
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr <= 14'd0;
	else case(wave_sel)
		4'b0001:	addr <= addr_reg + 14'd0;
		4'b0010:	addr <= addr_reg + 14'd4096;
		4'b0100:	addr <= addr_reg + 14'd8192;
		4'b1000:	addr <= addr_reg + 14'd12288;
		default:	addr <= addr_reg + 14'd0;
		
	endcase



rom_8x163384 rom_wave_inst (
  .clka	(sys_clk		),
  .ena	(sys_rst_n		),
  .addra(addr			),
  .douta(dac_data		) 
);


endmodule