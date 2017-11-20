//FPGA PPU (pixel processing unit)
//Designed by James Guo
//De1_SoC.sv

// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC (CLOCK_50,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	//Port declerations
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input logic CLOCK_50; // 50MHz clock. 
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	//turnning off the HEX lights 
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
	logic [31:0] divided_clocks;
	clock_divider (CLOCK_50, divided_clocks);
	
	//Allocate memory to store sprite "egg"
	reg [23:0] egg [255:0];
	// initialize the hexadecimal reads from the egg.txt file
	initial begin $readmemh("eggdata.txt", egg);
	end
	
	//Allocate memory to store sprite "pokeball"
	reg [23:0] pokeball [255:0];
	// initialize the hexadecimal reads from the pokeball.txt file
	initial begin $readmemh("pokeballdata.txt", pokeball);
	end
	
	//returns the coordinate of the current pixel the driver is processing
	reg [9:0] x;
	reg [8:0] y;
	
	//the rgb values for the current pixel
	reg [7:0] r,g,b;
	
	//reset the screen to all black
	wire reset = ~KEY[0];
	
	//Video driver module, interface for VGA protocol
	video_driver (.CLOCK_50,.reset,.x,.y,.r,.g,.b,.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	//Defines x,y starting coordinate for objects:
	//Sq=white square, Poke=pokeball sprite,Egg= yoshi egg sprite
	reg [9:0] xSq, xPoke, xEgg;
	reg [8:0] ySq, yPoke, yEgg;
	reg frameClk;
	logic [3:0] obj;
	logic [23:0] color [3:0];
	logic [31:0] frameClk_divided;
	clock_divider (frameClk, frameClk_divided);
	//encodes sprite
	spriteEncode(.x,.y,.r,.g,.b,.obj,.color,.clk(CLOCK_50),.reset);
	//draws the corresponding sprites
	drawSquare Square(.x,.y,.xStart(xSq),.yStart(ySq),.length(5'b00110),.draw(obj[1]),.color(color[1]),.clk(CLOCK_50));
	drawSprite pball(.x,.y,.xStart(xPoke),.yStart(yPoke),.sprite(pokeball),.draw(obj[0]),.color(color[0]),.clk(CLOCK_50),.reset);
	drawSprite yoshiEgg(.x,.y,.xStart(xEgg),.yStart(yEgg),.sprite(egg),.draw(obj[2]),.color(color[2]),.clk(CLOCK_50),.reset);	
	
//	frame clk, ticks evertime when frame is refreshed
	always @(posedge CLOCK_50) begin
		if(reset) begin
				frameClk <= 0;
			end else if(frameClk == 0 && (x == 0 && y == 0)) begin
				frameClk <= 1;
			end else if(x == 0 && y == 0) begin
				frameClk <= 0;
			end
	 
	end
	
	//animation speed test
	//pokeball sprite is tossed forward with contsant gravity
	//base gravity = 20 pixels/frame^2
	//starting velocity = SW * base speed
	
	//use LEDRs as visual indicator for speed of pokeball
	assign LEDR = SW;
	
	//x and y velocity
	logic [9:0] vx, vy;
	always @(posedge frameClk_divided[15])begin
		//KEY[3] resets position of pokeball and yoshi egg.
		if(~KEY[3]) begin
			xSq <= 5;
			xPoke <= 5;
			xEgg <=5;
			ySq <= 300;
			yPoke <= 40;
			yEgg <=460;
			vx <= SW;
			vy <= SW;
		end else begin
			ySq <= ySq + 5;
			
			//launches pokeball sprite with press of KEY[1]
			if(~KEY[1] && yPoke < 460) begin
				vy <= vy - 3;
				xPoke <= xPoke + vx;
				yPoke <= yPoke - vy;
			end else begin
				xPoke <= xPoke;
				yPoke <= yPoke;
			end 
		end

	end
endmodule


// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input clock;
	output [31:0] divided_clocks;
	reg [31:0] divided_clocks;
	
	initial
		divided_clocks = 0;
		
	always @(posedge clock)
		divided_clocks = divided_clocks + 1;
endmodule


