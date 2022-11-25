module cla(a,b,cin,sum,cout);
input [3:0] 	a	;
input [3:0]		b	;
input 			cin	;
output 			cout;
output [3:0] 	sum	; 

wire [4:0] c;
wire [3:0] p;
wire [3:0] g;

//g
assign g = a&b;
//p
assign p = a^b;

//c
assign c[0] = cin;
assign c[1] = g[0] | (p[0]&c[0]);
assign c[2] = g[1] | (p[1]&g[0]) | (p[1]&p[0]&c[0]);
assign c[3] = g[2] | (p[2]&g[1]) | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&c[0]);
assign c[4] = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&c[0]);

//sum
assign sum = a^b^c;

//cout
assign cout = c[4];


endmodule