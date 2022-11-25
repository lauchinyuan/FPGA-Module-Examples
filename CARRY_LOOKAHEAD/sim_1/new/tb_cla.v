`timescale 1ns/1ns
module tb_cla();
reg [3:0] a	;
reg [3:0] b	; 
reg 	cin		;
wire	cout	;
wire [3:0] sum	;

initial
	begin
	a = 4'd1;
	b = 4'd2;
	cin = 1'b0;
	#500
	a = 4'd2;
	#500
	a = 4'd3;
	#500
	a = 4'd4;
	#500
	a = 4'd5;
	#200
	b = 4'd8;
	a = 4'd1;
	cin = 1'b1;
	#500
	a = 4'd2;
	#500
	a = 4'd3;
	#500
	a = 4'd4;
	#500
	a = 4'd5;
	#200
	b = 4'd8;
	
	
	end



cla cla_inst
(
.a		(a),
.b		(b),
.cin	(cin),
.sum	(sum),
.cout   (cout)
);
endmodule