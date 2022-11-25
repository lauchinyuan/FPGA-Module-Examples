module seg_dynamic
#(
	parameter 	CNT_SEG_MAX = 16'd49_999
)
(
	input 	wire		sys_clk		,
	input 	wire		sys_rst_n	,
	input 	wire [19:0]	data		,
	input 	wire [5:0]	point		,
	input	wire 		sign		,
	input 	wire 		seg_en		,
	
	output	reg	 [7:0]	seg 		,
	output	reg	 [5:0]	sel
	
);
reg				cnt_1ms_flag;
wire	[3:0]	unit	    ;
wire	[3:0]	ten		    ;
wire	[3:0]	hun		    ;
wire	[3:0]	tho		    ;
wire	[3:0]	ten_tho     ;
wire	[3:0]	hun_hun	    ;
wire 			sign_out	;
reg		[15:0]	cnt_seg		;
reg		[2:0]	cnt_1ms		;
reg		[23:0]	data_reg	;
reg				dot_display	;
reg		[3:0]	data_display;
reg		[5:0]	sel_temp	;


//cnt_seg
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_seg <= 1'b0;
	else if(cnt_seg == CNT_SEG_MAX)
		cnt_seg <= 1'b0;
	else
		cnt_seg <= cnt_seg + 16'd1;
	
//cnt_1ms_flag
always@(posedge sys_clk or negedge sys_rst_n)
		if(sys_rst_n == 1'b0)
			cnt_1ms_flag <= 1'b0;
		else if(cnt_seg == CNT_SEG_MAX - 16'd1)
			cnt_1ms_flag <= 1'b1;
		else
			cnt_1ms_flag <= 1'b0;

//cnt_1ms
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_1ms <= 3'd0;
	else if((cnt_1ms == 3'd5)&&(cnt_1ms_flag == 1'b1))
		cnt_1ms <= 3'd0;
	else if(cnt_1ms_flag == 1'b1)
		cnt_1ms <= cnt_1ms + 3'd1;
	else
		cnt_1ms <= cnt_1ms;
		
		

//sel_temp    
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sel_temp <= 6'b000_001;
	else if(cnt_1ms_flag == 1'b1)
		sel_temp <= {sel_temp[4:0],sel_temp[5]};

//data_reg     
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_reg <= 24'b1111_1111_1111_1111_1111_1111;   
	else if((hun_hun != 4'b0)||(point[5] != 1'b0 ))
		data_reg <= {hun_hun,ten_tho,tho,hun,ten,unit};

	else if((ten_tho != 4'b0)||(point[4] != 1'b0))
		if(sign_out == 1'b1)
			data_reg <= {4'b1110,ten_tho,tho,hun,ten,unit};
		else
			data_reg <= {4'b1111,ten_tho,tho,hun,ten,unit};
			
	else if((tho != 4'b0) || (point[3] != 1'b0))
		if(sign_out == 1'b1)
			data_reg <= {4'b1111,4'b1110,tho,hun,ten,unit};
		else
			data_reg <= {4'b1111,4'b1111,tho,hun,ten,unit};
			
	else if((hun != 4'b0) || (point[2] != 1'b0))
		if(sign_out == 1'b1)
			data_reg <= {4'b1111,4'b1111,4'b1110,hun,ten,unit};
		else
			data_reg <= {4'b1111,4'b1111,4'b1111,hun,ten,unit};

	else if((ten != 4'b0) || (point[1] != 1'b0))
		if(sign_out == 1'b1)
			data_reg <= {4'b1111,4'b1111,4'b1111,4'b1110,ten,unit};
		else
			data_reg <= {4'b1111,4'b1111,4'b1111,4'b1111,ten,unit};

	else if(ten != 4'b0)
		if(sign_out == 1'b1)
			data_reg <= {4'b1111,4'b1111,4'b1111,4'b1111,4'b1110,unit};
		else
			data_reg <= {4'b1111,4'b1111,4'b1111,4'b1111,4'b1111,unit};

//data_display      
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		data_display <= 4'b1111;  //void
	else if(seg_en == 1'b0)
		data_display <= 4'b1111;  //void
	else if(cnt_1ms_flag == 1'b1)
	case(sel_temp)
		6'b000_001   :		data_display <= data_reg[3:0];
		6'b000_010   :      data_display <= data_reg[7:4];
		6'b000_100   :      data_display <= data_reg[11:8];
		6'b001_000   :      data_display <= data_reg[15:12];
		6'b010_000   :      data_display <= data_reg[19:16];
		6'b100_000   :      data_display <= data_reg[23:20];
		default:			data_display <= 4'b1111;
	endcase
	else
		data_display <= data_display;
	

//dot_display  	
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		dot_display <= 1'b1;
	else if(seg_en == 1'b0)
		dot_display <= 1'b1;
	else if(cnt_1ms_flag == 1'b1)
		if((sel_temp & point) == 6'b000_000)
			dot_display <= 1'b1;
		else
			dot_display <= 1'b0;
	
	else
		dot_display <= dot_display;
	
//sel      
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		sel <= 6'b000_001;
	else
		sel <= sel_temp;

//seg  
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		seg <= 8'hff;
	else	case(data_display)  
			4'b1111	:		seg <= 8'hff;   //void
			4'b1110	:		seg <= 8'hfa;	//negative
			4'd1 	:		seg <= {dot_display,7'b111_1001};
			4'd2 	:		seg <= {dot_display,7'b010_0100};
			4'd3 	:		seg <= {dot_display,7'b011_0000};
			4'd4 	:		seg <= {dot_display,7'b001_1001};
			4'd5 	:		seg <= {dot_display,7'b001_0010};
			4'd6 	:		seg <= {dot_display,7'b000_0010};
			4'd7 	:		seg <= {dot_display,7'b111_1000};
			4'd8 	:		seg <= {dot_display,7'b000_0000};
			4'd9 	:		seg <= {dot_display,7'b001_0000};
			4'd0 	:		seg <= {dot_display,7'b100_0000};
			default	:		seg <= 8'hff					;   //default setting is void 
			endcase


bcd8421
#(
	.SHIFT_MAX(5'd21)
)
bcd8421_inst
(
	.sys_clk		(sys_clk	),
	.sys_rst_n		(sys_rst_n	),
	.data			(data		),
	.sign			(sign		),

	.unit			(unit		),
	.ten			(ten		),
	.hun			(hun		),
	.tho			(tho		),
	.ten_tho		(ten_tho	),
	.hun_hun	    (hun_hun	),
	.sign_out		(sign_out	)

);




endmodule

