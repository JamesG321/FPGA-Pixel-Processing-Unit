//FPGA PPU (pixel processing unit)
//Designed by James Guo
//sprites.sv
//modules to draw sprites to vga protocol

//top level sprite Encoder
//supports 4 sprites and a background, can be upscaled/downscaled 
//supports layers when sprites collide
//supports "transparent" pixels for sprites
module spriteEncode(x,y,r,g,b,obj,color,clk,reset);
	input logic [9:0] x;
	input logic [8:0] y;
	//array to indicate area of sprite
	//is high if current processing pixel belongs to one of the objects
	//obj[0] is frontmost layer, obj[3] is backmost.
	input logic [3:0] obj;
	//RGB values for sprites obj[0]-obj[3]
	input logic [23:0] color [3:0];
	input logic clk;
	input logic reset;
	//RGB value to output to vga protocol
	output logic [7:0] r,g,b;
	//defines RGB value for background of screen
	logic [23:0] background;
	assign background = 24'h0FB2FF;
	//define RGB value for transparent pixel
	logic [23:0] transparent;
	assign transparent = 24'hFFFFFF;
	//nested decesion tree to determine what object/background current pixel belongs to.
	always @(posedge clk)begin
		if(reset)begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end if(color[0] == transparent) begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end else if(obj[0] == 1)begin
			r <= color[0] [23:16];
			g <= color[0] [15:8];
			b <= color[0] [7:0];
		end else if(color[1] transparent) begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end else if(obj[1] == 1)begin 
			r <= color[1] [23:16];
			g <= color[1] [15:8];
			b <= color[1] [7:0];
		
		end else if(color[2] transparent) begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end else if(obj[2] == 1)begin 
			r <= color[2] [23:16];
			g <= color[2] [15:8];
			b <= color[2] [7:0];
		
		end else if(color[3] == transparent) begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end else if(obj[3] == 1)begin 
			r <= color[3] [23:16];
			g <= color[3] [15:8];
			b <= color[3] [7:0];
		end else begin
			r <= background [23:16];
			g <= background [15:8];
			b <= background [7:0];
		end
	end
	
endmodule

//draw a square with side length length[4:0]
module drawSquare(x,y,xStart,yStart,length,draw,color,clk);
	output logic draw;
	output logic [23:0] color;
	input logic [9:0] x, xStart;
	input logic [8:0] y, yStart;
	input logic [4:0] length;
	input logic clk;
	assign color = 24'hFFFFFE;
	//draws white square when within range
	always @(posedge clk)begin
		if(x 	<= (xStart+length) && y <= (yStart+length) && x >= xStart && y >= yStart)begin
			draw <= 1;
		end else begin
			draw <= 0;
		end
	end
	
endmodule

//draws a 15*15 pixel sprite to vga, with top-left pixel of sprite being
//(xStart,yStart) this postion can be moved between frames for animation.
module drawSprite(x,y,xStart,yStart,sprite,draw,color,clk,reset);
 	output logic draw;
	output logic [23:0] color;
	input logic reset;
	//x,y is current pixel from vga interface
	//xStart and yStart is top-left corner of sprite square
	input logic [9:0] x, xStart;
	input logic [8:0] y, yStart;
	input reg [23:0] sprite [255:0];
	input logic clk;	
	
	//outputs RGB value for corresponding pixel within sprite range.
	always @(posedge clk)begin
		if(reset)begin
			draw <= 0;
		end else if(x 	<= (xStart+15) && y <= (yStart+15) && x >= xStart && y >= yStart)begin
			draw <= 1;
			//x + y *4
			//draw <=  test16[(y-yStart)][(x-xStart)];
			color <= sprite [(x-xStart) + ((y-yStart) * 16)];
		end else begin
			draw <= 0;
			color <= 0;
		end
		
	end

endmodule

//decode 8 bit color (Not used here, but can be used for 24-bit RGB to 8-bit downgrade)
//module colorDecode(color,r,g,b);
//	output logic [7:0] r,g,b;
//	input logic [7:0] color;
//	assign r = color[7:5] * 32;
//	assign g = color[4:2] * 32;
//	assign b = color[1:0] * 64;
//endmodule 


