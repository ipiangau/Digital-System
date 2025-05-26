module memory_game (
	input clock,
	input reset,
	input sw1,
	input [3:0] keypadCol,
	output [7:0] dot_row,
	output [7:0] dot_col,
	output [3:0] keypadRow,
	output [6:0] out1,
	output [6:0] out2,
	output [6:0] out3,
	output [6:0] out4
);
	wire clock_div;
	wire clock_div2;
	wire [2:0] count;
	FrequencyDivider u_a(.clk(clock), .rst(reset), .clk_div(clock_div), .clk_div2(clock_div2));
	Counter u_b(.clk_div(clock_div), .clk_div2(clock_div2), .rst(reset), .count(count), .dot_row(dot_row), .dot_col(dot_col), .sw1(sw1));
	Keypad u_c(.keypadCol(keypadCol), .keypadRow(keypadRow), .clk(clock), .rst(reset), .out1(out1), .out2(out2), .out3(out3), .out4(out4), .sw1(sw1));
endmodule

`define TimeExpire 32'd2500

module FrequencyDivider(clk, rst, clk_div, clk_div2);
	input clk, rst;
	output clk_div;
	output clk_div2;

	reg clk_div;
	reg clk_div2;
	reg [31:0] count;
	reg [31:0] count2;
 
	always@(posedge clk or negedge rst)
	begin
    	if(!rst)
    	begin
        	count2 <= 32'd0;
        	clk_div2 <= 1'b0;
    	end
    	else
    	begin
        	if(count==`TimeExpire)
        	begin
            	count <= 32'd0;
            	clk_div <= ~clk_div;
        	end
        	else
        	begin
            	count <= count + 32'd1;
        	end
        	if(count2==32'd25000000)
        	begin
            	count2 <= 32'd0;
            	clk_div2 <= ~clk_div2;
        	end
        	else
        	begin
            	count2 <= count2 + 32'd1;
        	end
    	end
	end
endmodule

module Counter(clk_div, clk_div2, rst, count, dot_row, dot_col, sw1);
	input rst,clk_div, clk_div2, sw1;
	output [2:0] count;
	output reg [7:0] dot_row;
	output reg [7:0] dot_col;
	reg [4:0] light;
	//reg [4:0] sec;
	reg [2:0]count;
	//reg [3:0]cur,next;
    
	always @(posedge clk_div2 or negedge rst)
	begin
    	if(!rst) begin
        	light <= 4'd0;
    	end
    	else begin
			if(sw1 == 0)begin
				if(light == 10)
				begin
						light = light;
				end
				else
				begin
						light = light+1;
				end
			end
			else begin
				if(light == 14)
				begin
						light = light;
				end
				else
				begin
						light = light+1;
				end
			end
    	end  
	end
    
	always @(posedge clk_div or negedge rst)
	begin
    	if(~rst) begin
        	count <= 0;
    	end
    	else begin
        	count <= count+1;
			case(count)
                	3'd0: dot_row <= 8'b01111111;
                	3'd1: dot_row <= 8'b10111111;
                	3'd2: dot_row <= 8'b11011111;
                	3'd3: dot_row <= 8'b11101111;
                	3'd4: dot_row <= 8'b11110111;
                	3'd5: dot_row <= 8'b11111011;
                	3'd6: dot_row <= 8'b11111101;
                	3'd7: dot_row <= 8'b11111110;
			endcase
			if(light==4'd0) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b10000110;
                	3'd2: dot_col <= 8'b10001110;
                	3'd3: dot_col <= 8'b10000110;
                	3'd4: dot_col <= 8'b10000110;
                	3'd5: dot_col <= 8'b10000110;
                	3'd6: dot_col <= 8'b11100110;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b10001100;
                	3'd2: dot_col <= 8'b10010010;
                	3'd3: dot_col <= 8'b10000010;
                	3'd4: dot_col <= 8'b10000100;
                	3'd5: dot_col <= 8'b10001000;
                	3'd6: dot_col <= 8'b11101111;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
        	end
        	else if(light==4'd1) begin
            	case(count)
                	3'd0: dot_col <= 8'b00111100;
                	3'd1: dot_col <= 8'b01000010;
                	3'd2: dot_col <= 8'b00000010;
                	3'd3: dot_col <= 8'b00111100;
                	3'd4: dot_col <= 8'b00000010;
                	3'd5: dot_col <= 8'b01000010;
                	3'd6: dot_col <= 8'b00111100;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
        	end
        	else if(light==4'd2) begin
            	case(count)
                	3'd0: dot_col <= 8'b00111100;
                	3'd1: dot_col <= 8'b01000010;
                	3'd2: dot_col <= 8'b00000010;
                	3'd3: dot_col <= 8'b00011100;
                	3'd4: dot_col <= 8'b00100000;
                	3'd5: dot_col <= 8'b01000000;
                	3'd6: dot_col <= 8'b01111110;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
        	end
        	else if(light==4'd3) begin
            	case(count)
                	3'd0: dot_col <= 8'b00011000;
                	3'd1: dot_col <= 8'b00111000;
                	3'd2: dot_col <= 8'b00011000;
                	3'd3: dot_col <= 8'b00011000;
                	3'd4: dot_col <= 8'b00011000;
                	3'd5: dot_col <= 8'b00011000;
                	3'd6: dot_col <= 8'b01111110;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
        	end
        	else if(light==4'd4) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b11000000;
                	3'd1: dot_col <= 8'b11000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00110000;
                	3'd5: dot_col <= 8'b00110000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
        	end
        	else if(light==4'd5) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00110000;
                	3'd1: dot_col <= 8'b00110000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000011;
                	3'd3: dot_col <= 8'b00000011;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
        	end
        	else if(light==4'd6) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000011;
                	3'd7: dot_col <= 8'b00000011;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00001100;
                	3'd1: dot_col <= 8'b00001100;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
        	end
        	else if(light==4'd7) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00110000;
                	3'd3: dot_col <= 8'b00110000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b11000000;
                	3'd7: dot_col <= 8'b11000000;
            	endcase
				end
        	end
        	else if(light==4'd8) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b11000000;
                	3'd5: dot_col <= 8'b11000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00001100;
                	3'd3: dot_col <= 8'b00001100;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
        	end
        	else if(light==4'd9) begin
				if(sw1 == 0)begin
            	case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000011;
                	3'd3: dot_col <= 8'b00000011;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            	endcase
				end
				else begin
					case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00001100;
                	3'd7: dot_col <= 8'b00001100;
            	endcase
				end
        	end
			else if(light == 4'd10 && sw1 == 1)begin
				case(count)
                	3'd0: dot_col <= 8'b11000000;
                	3'd1: dot_col <= 8'b11000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            endcase
			end
			else if(light == 4'd11)begin
				case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00001100;
                	3'd5: dot_col <= 8'b00001100;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            endcase
			end
			else if(light == 4'd12)begin
				case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00110000;
                	3'd3: dot_col <= 8'b00110000;
                	3'd4: dot_col <= 8'b00000000;
                	3'd5: dot_col <= 8'b00000000;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            endcase
			end
			else if(light == 4'd13)begin
				case(count)
                	3'd0: dot_col <= 8'b00000000;
                	3'd1: dot_col <= 8'b00000000;
                	3'd2: dot_col <= 8'b00000000;
                	3'd3: dot_col <= 8'b00000000;
                	3'd4: dot_col <= 8'b00000011;
                	3'd5: dot_col <= 8'b00000011;
                	3'd6: dot_col <= 8'b00000000;
                	3'd7: dot_col <= 8'b00000000;
            endcase
			end
        	else begin
            	//dot_row <= 8'b11111111;
            	dot_col <= 8'b00000000;
        	end
    	end
	end
endmodule

module Keypad(keypadCol, keypadRow, clk, rst, out1, out2, out3, out4, sw1);
	input clk, rst, sw1;
	input [3:0] keypadCol;
	output reg [3:0] keypadRow;
	output reg [6:0] out1;
	output reg [6:0] out2;
	output reg [6:0] out3;
	output reg [6:0] out4;
    
	reg [5:0] keypadBuf;
	reg [31:0] keypadDelay;
	reg [4:0] score, count, expected_value;
	reg [5:0] prevKeypadBuf;
	reg gameover;
	//reg [4:0] cur, next;
	always @(posedge clk or negedge rst) begin
    	if (~rst) begin
    	keypadRow <= 4'b1111;
    	keypadBuf <= 5'b00000;
    	keypadDelay <= 32'd0;
      	//count <= 4'd0;
    	end
    	else begin
        	if (keypadDelay == 32'd50000) begin
        	keypadDelay <= 32'd0;
            	case ({keypadRow, keypadCol})
            	8'b1110_1110: keypadBuf <= 5'h7; // Key 7
            	8'b1110_1101: keypadBuf <= 5'h4; // Key 4
            	8'b1110_1011: keypadBuf <= 5'h1; // Key 1
            	8'b1110_0111: keypadBuf <= 5'h0; // Key 0

            	8'b1101_1110: keypadBuf <= 5'h8; // Key 8
            	8'b1101_1101: keypadBuf <= 5'h5; // Key 5
            	8'b1101_1011: keypadBuf <= 5'h2; // Key 2
            	8'b1101_0111: keypadBuf <= 5'hA; // Key A

            	8'b1011_1110: keypadBuf <= 5'h9; // Key 9
            	8'b1011_1101: keypadBuf <= 5'h6; // Key 6
            	8'b1011_1011: keypadBuf <= 5'h3; // Key 3
            	8'b1011_0111: keypadBuf <= 5'hB; // Key B

            	8'b0111_1110: keypadBuf <= 5'hC; // Key F
            	8'b0111_1101: keypadBuf <= 5'hD; // Key E
            	8'b0111_1011: keypadBuf <= 5'hE; // Key D
            	8'b0111_0111: keypadBuf <= 5'hF; // Key C

            	default: keypadBuf <= keypadBuf; // No change
        	endcase
            	case (keypadRow)
            	4'b1110: keypadRow <= 4'b1101;
            	4'b1101: keypadRow <= 4'b1011;
            	4'b1011: keypadRow <= 4'b0111;
            	4'b0111: keypadRow <= 4'b1110;
            	default: keypadRow <= 4'b1110;
        	endcase
        	end
        	else begin
            	keypadDelay <= keypadDelay + 1'b1;
        	end
    	end
	end
	//cur <= 5'd16;
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			count <= 5'd0;
			score <= 5'd0;
			prevKeypadBuf <= 5'd0;
			gameover <= 1'b0;
		end 
		else if (!gameover) begin
			if(sw1 == 0)begin
				case (score)
					0: expected_value <= 5'hF;
					1: expected_value <= 5'hE;
					2: expected_value <= 5'h7;
					3: expected_value <= 5'h3;
					4: expected_value <= 5'hA;
					5: expected_value <= 5'h9;
					default: expected_value <= 5'd16; // Default case
				endcase
			end
			else begin
				case (score)
					0: expected_value <= 5'h2;
					1: expected_value <= 5'h9;
					2: expected_value <= 5'hD;
					3: expected_value <= 5'h0;
					4: expected_value <= 5'h6;
					5: expected_value <= 5'h4;
					6: expected_value <= 5'hF;
					7: expected_value <= 5'h5;
					8: expected_value <= 5'h3;
					9: expected_value <= 5'h8;
					default: expected_value <= 5'd16; // Default case
				endcase
			end

			if (keypadBuf < 5'd17 && keypadBuf != prevKeypadBuf) begin
				if (keypadBuf == expected_value) begin
						score <= score + 1;
				end else begin
						gameover <= 1'b1; // Set gameover if wrong input
				end
				count <= count + 1;
			end

			prevKeypadBuf <= keypadBuf;
		end
	end
// 顯示輸出的更新仍在組合邏輯中處理
	always @(*) begin
	if (gameover==0) begin
		if(sw1 == 0)begin
			if (score == 6) begin
				out1 = 7'b0010010;
				out2 = 7'b0010010;
				out3 = 7'b0001000;
				out4 = 7'b0001100;
			end else if (count == 6 && score != 6) begin
				out1 = 7'b1000111;
				out2 = 7'b1001111;
				out3 = 7'b0001000;
				out4 = 7'b0001110;
			end else begin
				out1 = 7'b1111111;
				out2 = 7'b1111111;
				out3 = 7'b1111111;
				out4 = 7'b1111111;
			end
		end
		else begin
			if (score == 10) begin
				out1 = 7'b0010010;
				out2 = 7'b0010010;
				out3 = 7'b0001000;
				out4 = 7'b0001100;
			end else if (count == 10 && score != 10) begin
				out1 = 7'b1000111;
				out2 = 7'b1001111;
				out3 = 7'b0001000;
				out4 = 7'b0001110;
			end else begin
				out1 = 7'b1111111;
				out2 = 7'b1111111;
				out3 = 7'b1111111;
				out4 = 7'b1111111;
			end
		end
	end
	else begin
			out1 = 7'b1000111;
			out2 = 7'b1001111;
			out3 = 7'b0001000;
			out4 = 7'b0001110;
		end
	end
endmodule



