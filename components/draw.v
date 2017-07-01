module datapath(
	input [2:0] input_colour,
	input [6:0] coords,
	input [1:0] xOffset,
	input [1:0] yOffset,
  input draw, // draw the square if 1, erase to black otherwise.
	input resetn,
	input saveX,
	output[7:0] finalX,
	output[6:0] finalY,
	output[2:0] output_colour
	);

	// setup x coordinate
	reg[7:0] x_coordinate;

	always @ (posedge saveX) begin
		x_coordinate <= {1'b0, coords};
	end

	assign finalY = {coords + yOffset};
	assign finalX = {x_coordinate + xOffset};

	// set color
  always @(*)
  begin
    // use input colour if draw
    if (draw)
      assign output_colour = input_colour[2:0];
    // erase to black otherwise
    else
      assign ouput_colour = 3'b000;
  end

endmodule

/**
 * Output an xOffset and yOffset each clock cycle. In total, output 16 offset pairs.
 * Used along with datapath to draw a four by four square in VGA.
 *
 * @input clk CLOCK_50 should be used.
 * @input resetn To stop datapath from continuing, and goto resting state
 * @input go signal to start drawing
 *
 * @output xOffset of the square
 * @output yOffset of the square
 * @output plot signal to VGA to draw the square
 */
module draw_four_by_four(
	input clk,
	input resetn,
	input go,

	output reg [1:0] xOffset,
	output reg [1:0] yOffset,
	output plot);

	reg [5:0] current_state, next_state;

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
				xOffset <= 2'b00;
				yOffset <= 2'b00;
				end
			P2: begin
				xOffset <= 2'b01;
				yOffset <= 2'b00;
				end
			P3: begin
				xOffset <= 2'b10;
				yOffset <= 2'b00;
				end
			P4: begin
				xOffset <= 2'b11;
				yOffset <= 2'b00;
				end
			P5: begin
				xOffset <= 2'b00;
				yOffset <= 2'b01;
				end
			P6: begin
				xOffset <= 2'b01;
				yOffset <= 2'b01;
				end
			P7: begin
				xOffset <= 2'b10;
				yOffset <= 2'b01;
				end
			P8: begin
				xOffset <= 2'b11;
				yOffset <= 2'b01;
				end
			P9: begin
				xOffset <= 2'b00;
				yOffset <= 2'b10;
				end
			P10: begin
				xOffset <= 2'b01;
				yOffset <= 2'b10;
				end
			P11: begin
				xOffset <= 2'b10;
				yOffset <= 2'b10;
				end
			P12: begin
				xOffset <= 2'b11;
				yOffset <= 2'b10;
				end
			P13: begin
				xOffset <= 2'b00;
				yOffset <= 2'b11;
				end
			P14: begin
				xOffset <= 2'b01;
				yOffset <= 2'b11;
				end
			P15: begin
				xOffset <= 2'b10;
				yOffset <= 2'b11;
				end
			P16: begin
				xOffset <= 2'b11;
				yOffset <= 2'b11;
				end
			default: begin
				xOffset <= 2'b00;
				yOffset <= 2'b00;
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
