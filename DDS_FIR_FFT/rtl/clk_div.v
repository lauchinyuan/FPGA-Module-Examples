module clk_div
(
	input  wire  clk,   //  refclk.clk
	input  wire  rst_n,      //   reset.reset
	output wire  outclk, // outclk0.clk
	output wire  locked   
);
	pll_ip pll_ip_inst(
		.refclk(clk)		,   
		.rst(~rst_n)		,      
		.outclk_0(outclk)	, 
		.locked(locked)    	
	);


endmodule