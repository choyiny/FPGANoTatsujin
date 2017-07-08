/**
 * IMPORTANT: must wait 16 ticks before changing the x coordinates
 **/
module square4x4(
  input clk, // please use CLOCK_50
  input x_coords,
  input y_coords,
	input [2:0] input_colour,
  output reg [7:0] finalX,
  output reg [6:0] finalY,
  output [2:0] output_colour
  );
	// init datapath
  datapath draw_square(.input_colour(input_colour),
	                     .x_coords(x_coords),
											 .y_coords(y_coords),
											 .xOffset(xoff),
											 .yOffset(yoff),
											 .finalX(finalX),
											 .finalY(finalY),
											 .output_colour(output_colour)
											 );

  wire [1:0] xoff;
	wire [1:0] yoff;

  // init FSM
	control offset_calc(.clk(clk),
	                    .resetn(1'b1),
											.go(1'b1),
											.xOffset(xoff),
											.yOffset(yoff),
											.plot(1'b1)
											);

endmodule

module datapath(
	input [2:0] input_colour,
	input [7:0] x_coords,
	input [6:0] y_coords,
	input [1:0] xOffset,
	input [1:0] yOffset,
  input draw, // draw the square if 1, erase to black otherwise.
	output reg [7:0] finalX,
	output reg [6:0] finalY,
	output[2:0] output_colour
	);

	assign finalY = {y_coords + yOffset};
	assign finalX = {x_coords + xOffset};

	// set color
	assign output_colour = input_colour[2:0];

endmodule

/**
 * Finite state machine to draw 4x4 square
 *
 * @input clk CLOCK_50 should be used.
 * @input resetn To stop datapath from continuing, and goto resting state
 * @input go signal to start drawing
 *
 * @output xOffset of the square
 * @output yOffset of the square
 * @output plot signal to VGA to draw the square
 */
module control(
	input clk,
	input resetn,
	input go,

	output [1:0] xOffset,
	output [1:0] yOffset,
	output plot);

	reg [5:0] current_state, next_state;
	reg [1:0] xoff;
	reg [1:0] yoff;

	assign xOffset = xoff;
	assign yOffset = yoff;

	localparam 	P1      = 5'd0,
				P2      = 5'd1,
				P3      = 5'd2,
				P4      = 5'd3,
				P5      = 5'd4,
				P6      = 5'd5,
				P7      = 5'd6,
				P8      = 5'd7,
				P9      = 5'd8,
				P10     = 5'd9,
				P11     = 5'd10,
				P12     = 5'd11,
				P13     = 5'd12,
				P14     = 5'd13,
				P15     = 5'd14,
				P16     = 5'd15,
				RESTING = 5'd16;

	always@(posedge clk)
	begin: state_table
		case (current_state)
			P1: next_state = P2;
			P2: next_state = P3;
			P3: next_state = P4;
			P4: next_state = P5;
			P5: next_state = P6;
			P6: next_state = P7;
			P7: next_state = P8;
			P8: next_state = P9;
			P9: next_state = P10;
			P10: next_state = P11;
			P11: next_state = P12;
			P12: next_state = P13;
			P13: next_state = P14;
			P14: next_state = P15;
			P15: next_state = P16;
			P16: next_state = RESTING;
			RESTING: next_state = go ? P1 : RESTING;
			default: next_state = RESTING;
		endcase
	end

	// plot
	assign plot = (current_state != RESTING);

	// assign offset
	always@(*)
	begin: make_output
		case(current_state)
			P1: begin
				xoff <= 2'b00;
				yoff <= 2'b00;
				end
			P2: begin
				xoff <= 2'b01;
				yoff <= 2'b00;
				end
			P3: begin
				xoff <= 2'b10;
				yoff <= 2'b00;
				end
			P4: begin
				xoff <= 2'b11;
				yoff <= 2'b00;
				end
			P5: begin
				xoff <= 2'b00;
				yoff <= 2'b01;
				end
			P6: begin
				xoff <= 2'b01;
				yoff <= 2'b01;
				end
			P7: begin
				xoff <= 2'b10;
				yoff <= 2'b01;
				end
			P8: begin
				xoff <= 2'b11;
				yoff <= 2'b01;
				end
			P9: begin
				xoff <= 2'b00;
				yoff <= 2'b10;
				end
			P10: begin
				xoff <= 2'b01;
				yoff <= 2'b10;
				end
			P11: begin
				xoff <= 2'b10;
				yoff <= 2'b10;
				end
			P12: begin
				xoff <= 2'b11;
				yoff <= 2'b10;
				end
			P13: begin
				xoff <= 2'b00;
				yoff <= 2'b11;
				end
			P14: begin
				xoff <= 2'b01;
				yoff <= 2'b11;
				end
			P15: begin
				xoff <= 2'b10;
				yoff <= 2'b11;
				end
			P16: begin
				xoff <= 2'b11;
				yoff <= 2'b11;
				end
			default: begin
				xoff <= 2'b00;
				yoff <= 2'b00;
				end
			endcase

	end

	always@(posedge clk)
	begin: state_FFs
		if(!resetn) // goto resting if reset
			current_state <= RESTING;
		else
			current_state <= next_state;
	end

endmodule
