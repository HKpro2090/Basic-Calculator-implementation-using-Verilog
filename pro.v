//Main Module
module pro(num,loada,loadb,a,b,op,rst,mode,HEX0,HEX1,HEX4,HEX5,HEX6,HEX7,neg);
input [3:0]mode;
input [8:0] num;
input rst,loada,loadb;
output [7:0] op;
reg [7:0] op2;
output [6:0] HEX0,HEX1,HEX4,HEX5,HEX6,HEX7;
output [7:0]a,b;
output neg;
inputfunction f1(.num(num),.loada(loada),.loadb(loadb),.a(a),.b(b));
displayfunction f2(.outputresbin(a),.neg(0),.rst(rst),.hex1(HEX6),.hex2(HEX7));
displayfunction f3(.outputresbin(b),.neg(0),.rst(rst),.hex1(HEX4),.hex2(HEX5));
functions f4(.a(a),.b(b),.op1(op),.mode(mode),.neg(neg));
displayfunction f5(.outputresbin(op),.neg(neg),.rst(rst),.hex1(HEX0),.hex2(HEX1));
endmodule

//Module to Load and Display User Input
module inputfunction(num,a,b,loada,loadb);
input [8:0] num;
input loada,loadb;
output reg [3:0]b;
output reg [7:0]a;
always@(loada or loadb)
begin
	if(num == 9'b0000000000 && loada)
		a = 8'b00000000;
	if(num == 9'b0000000001 && loada)
		a = 8'b00000001;
	if(num == 10'b0000000010 && loada)
		a = 8'b00000010;
	if(num == 9'b0000000100 && loada)
		a = 8'b00000011;
	if(num == 9'b0000001000 && loada)
		a = 8'b00000100;
	if(num == 9'b0000010000 && loada)
		a = 8'b00000101;
	if(num == 9'b0000100000 && loada)
		a = 8'b00000110;
	if(num == 9'b0001000000 && loada)
		a = 8'b00000111;
	if(num == 9'b0010000000 && loada)
		a = 8'b00001000;
	if(num == 9'b0100000000 && loada)
		a = 8'b00001001;
	
	if(num == 9'b0000000000 && loadb)
		b = 4'b0000;
	if(num == 9'b0000000001 && loadb)
		b = 4'b0001;
	if(num == 9'b0000000010 && loadb)
		b = 4'b0010;
	if(num == 9'b0000000100 && loadb)
		b = 4'b0011;
	if(num == 9'b0000001000 && loadb)
		b = 4'b0100;
	if(num == 9'b0000010000 && loadb)
		b = 4'b0101;
	if(num == 9'b0000100000 && loadb)
		b = 4'b0110;
	if(num == 9'b0001000000 && loadb)
		b = 4'b0111;
	if(num == 9'b0010000000 && loadb)
		b = 4'b1000;
	if(num == 9'b0100000000 && loadb)
		b = 4'b1001;
end
endmodule 




//Module to select operation and calculate result
module functions(a,b,op1,mode,neg);
input [3:0]a,b,mode;
output [7:0]op1;
reg [7:0] op1;
output reg neg;
always@(a or b)
begin
	op1 = 8'b00000000;
	if(mode == 4'b0001)
		begin
		op1 = a+b;
		neg = 0;
		end
	if(mode == 4'b0010)
		begin
		op1 = a*b;
		neg =0;
		end
	if(mode == 4'b0100)
		begin
		if(b > a)
			begin 
			op1=b-a;
			neg = 1;
			end
		else
			begin
			op1=a-b;
			neg = 0;
			end
		end
	if(mode == 4'b1000)
		begin
		op1 = a/b;
		neg = 0;
		end
end
endmodule

//Module to Convert the Binary result into BCD and Display on 7-segment Display
module displayfunction(outputresbin,neg,rst,hex1,hex2,HEX2);
input [7:0] outputresbin;
input rst,neg;
output reg [6:0]hex1,hex2,HEX2;
reg [15:0]temp;
reg [3:0]bcd1,bcd2;
initial 
begin
hex1 = 7'b1111111;
hex2 = 7'b1111111;
bcd1 = 4'b0000;
bcd2 = 4'b0000;
end
integer i;
always@(outputresbin)
begin
      temp[7:0]=outputresbin;
		temp[15:8]=8'b00000000;
		for (i=0; i<8; i=i+1) 
		begin
         if (temp[11:8] >= 5)
            temp[11:8] = temp[11:8] + 3;
         if (temp[15:12] >= 5)
            temp[15:12] = temp[15:12] + 3;
         temp = temp << 1;
      end
bcd2<=temp[15:12];
bcd1<=temp[11:8];
end
always@(bcd1 or bcd2 or neg or rst)
begin
	if(rst)
		begin
			hex1=7'b1111111;
			hex2=7'b1111111;
		end
	else if(neg==1)
		begin
		hex2=7'b0111111;
		HEX2=7'b0111111;
		case(bcd1)
		      4'b0000 : hex1 = 7'b1000000;
            4'b0001 : hex1 = 7'b1111001;
            4'b0010 : hex1 = 7'b0100100;
				4'b0011 : hex1 = 7'b0110000;
            4'b0100 : hex1 = 7'b0011001;
            4'b0101 : hex1 = 7'b0010010;
            4'b0110 : hex1 = 7'b0000010;
            4'b0111 : hex1 = 7'b1111000;
            4'b1000 : hex1 = 7'b0000000;
            4'b1001 : hex1 = 7'b0010000;
				default : hex1 = 7'b1111111;
		endcase
		end
	else if(neg==0)
		  begin
		  case (bcd1) 
		      4'b0000 : hex1 = 7'b1000000;
            4'b0001 : hex1 = 7'b1111001;
            4'b0010 : hex1 = 7'b0100100;
				4'b0011 : hex1 = 7'b0110000;
            4'b0100 : hex1 = 7'b0011001;
            4'b0101 : hex1 = 7'b0010010;
            4'b0110 : hex1 = 7'b0000010;
            4'b0111 : hex1 = 7'b1111000;
            4'b1000 : hex1 = 7'b0000000;
            4'b1001 : hex1 = 7'b0010000;
				default : hex1 = 7'b1111111;
				endcase
				case (bcd2) 
 		      4'b0000 : hex2 = 7'b1000000;
            4'b0001 : hex2 = 7'b1111001;
            4'b0010 : hex2 = 7'b0100100;
				4'b0011 : hex2 = 7'b0110000;
            4'b0100 : hex2 = 7'b0011001;
            4'b0101 : hex2 = 7'b0010010;
            4'b0110 : hex2 = 7'b0000010;
            4'b0111 : hex2 = 7'b1111000;
            4'b1000 : hex2 = 7'b0000000;
            4'b1001 : hex2 = 7'b0010000;
				default : hex2 = 7'b1111111;
				endcase
			end			
end
endmodule
