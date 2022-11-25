`timescale 1ns/1ns
module tb_rs232_rx();
reg				sys_clk		 ;
reg				read_done	 ;   
reg 			sys_rst_n	 ;
reg				rx			 ;

wire	[7:0]	rx_data		 ;
wire			flag_rxne	 ;


//initial
initial
	begin
		sys_clk = 1'b1					;
		sys_rst_n <= 1'b0				;
		read_done <= 1'b1				;
	#20
		sys_rst_n <= 1'b1				;
	#3000
		data_gen(8'haa)					;
	#5000
		reading()						;
	#3000
		data_gen(8'hfa)					;
	#50000
		data_gen(8'haa)					;
	end


//sys_clk
always #10 sys_clk = ~sys_clk			;






task data_gen
(
	input [7:0] data
);
	integer i;
		for(i = 0;i <= 10;i = i+1)
			begin
				case(i)
					0: rx <= 1'b1;
					1: rx <= 1'b0;
					2: rx <= data[0];
					3: rx <= data[1];
					4: rx <= data[2];
					5: rx <= data[3];
					6: rx <= data[4];
					7: rx <= data[5];
					8: rx <= data[6];
					9: rx <= data[7];
					10: rx <= 1'b1;
					default:rx <= 1'b1;
				endcase
				# (20*5208);
			end
endtask

task reading();
	begin
	#50000
		read_done <= 1'b0;
	#50000
		read_done <= 1'b1;
	end
endtask
	


rs232_rx rs232_rx_inst
(
	.sys_clk		(sys_clk		),
	.sys_rst_n		(sys_rst_n		),
	.rx				(rx				),
	.read_done		(read_done		),

	.rx_data		(rx_data		),
	.flag_rxne	    (flag_rxne	    )

);

endmodule


