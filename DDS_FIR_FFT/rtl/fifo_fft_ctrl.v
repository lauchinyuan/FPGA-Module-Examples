//用于控制fifo的读信号以及fft模块的输入时序
module fifo_fft_ctrl
(
	input wire			clk			,
	input wire			rst_n		,
	input wire			fir_valid	, //fir滤波有效标志
	input wire			fft_ready	, //代表fft单元可以接收输入
	input wire			fifo_empty	, //FIFO空
	input wire			fifo_full	, //FIFO存满
	
	output reg			fifo_rdreq	,
	output wire			fft_sop		,  //fft数据输入的开始标志
	output wire			fft_eop		,  //fft数据输入的结尾标志
	output reg			fft_in_valid, //输入fft有效信号
	output wire [9:0] cnt_fft_o	
	
);						//fifo的输出数据会延迟fifo_rdreq一拍


	reg [9:0] cnt_fft	;		// 从fft的sop到eop之间间隔512个数据
	
	//cnt_fft
	always @ (posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0) begin
			cnt_fft <= 10'd0;
		end else if(cnt_fft == 10'd512) begin 
		//计数到最大值，归零
			cnt_fft <= 10'd0;
		end else if(fifo_rdreq) begin
			cnt_fft <= cnt_fft + 10'd1; 
		end else begin
			cnt_fft <= cnt_fft;
		end
	end

	
	//fifo_rdreq
	always @ (posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0) begin
			fifo_rdreq <= 1'b0;
		end else if(fifo_full && fft_ready) begin
		//FIFO中已经读到了完整的512个数据，且fft模块输入准备好了
			fifo_rdreq <= 1'b1; 
		end else if(cnt_fft == 10'd511) begin
		//FFT模块已经输入了511个数据，包括下一周期的1个，共512个数据输入完毕
		//fifo_rdreq信号拉低
			fifo_rdreq <= 1'b0;
		end else begin
			fifo_rdreq <= fifo_rdreq;
		end
	end
	
	
	//fft_in_valid
	always @ (posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0) begin
			fft_in_valid <= 1'b0;
		end else begin
			//这里是时序电路，得到的是fifo_rdreq上一周期的值
			//由于本次实验中没有fifo空的情况
			//故只要上一周期fifo_rdreq有效，则也代表这一周期输出数据有效
			fft_in_valid <= fifo_rdreq;  
		end
	end
	
	
	
	
	//输入fft数据的有效信号，当计数到1-512时，且fifo输出数据有效才置位
	//assign fft_in_valid = ((cnt_fft >= 10'd1) && (cnt_fft <= 10'd512))? rdreq_d: 1'b0;
	
 	assign fft_sop = (cnt_fft == 10'd1	);
	assign fft_eop = (cnt_fft == 10'd512); 
	
endmodule