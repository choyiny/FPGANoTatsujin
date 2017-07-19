/**
 * Determines what square is being drawn and its colour
 */
module square_info(
  input [26:0] red_sequence, // Sequences are first 30 bits of shifters
  input [26:0] yellow_sequence,
  input [26:0] blue_sequence,

  // how fast the x,y coordinates should change.
  // this should not be faster than drawing the square (currently 4x4)
  input clk,

  output [7:0] output_x, // outputs the starting x coordinate for a square
  output [6:0] output_y, // outputs the starting y coordinate for a square
  output [2:0] colour // determines the colour (either draw or erase)

  );

  reg [6:0] curr_square_state, next_square_state,
            curr_row_state;

  // Colours to output
  reg [2:0] curr_colour;

  localparam BLACK = 3'b000,
             WHITE = 3'b111,
             RED = 3'b100,
             YELLOW = 3'b110,
             GREEN = 3'b010,
             CYAN = 3'b011,
             BLUE = 3'b001,
             MAGENTA = 3'b101;

  // assign colour to draw
  assign colour = curr_colour;

  // Co-ordinates
  localparam start_x = 7'b0000001,
             start_y = 7'b0110101;
  
  localparam x_offset = 7'b0000101,
             y_offset = 7'b0001011;
  
  reg [7:0] curr_x;
  reg [6:0] curr_y;
  
  // Assign co-ordinate outputs
  assign output_x = curr_x;
  assign output_y = curr_y;

  localparam Square1 = 6'd0, Square2 = 6'd1, Square3 = 6'd2,
             Square4 = 6'd3, Square5 = 6'd4, Square6 = 6'd5,
             Square7 = 6'd6, Square8 = 6'd7, Square9 = 6'd8,
             Square10 = 6'd9, Square11 = 6'd10, Square12 = 6'd11,
             Square13 = 6'd12, Square14 = 6'd13, Square15 = 6'd14,
             Square16 = 6'd15, Square17 = 6'd16, Square18 = 6'd17,
             Square19 = 6'd18, Square20 = 6'd19, Square21 = 6'd20,
             Square22 = 6'd21, Square23 = 6'd22, Square24 = 6'd23,
             Square25 = 6'd24, Square26 = 6'd25, Square27 = 6'd26,
             Square28 = 6'd27, Square29 = 6'd28, Square30 = 6'd29,
             Row_Swap = 6'd30; // Row swap state is when rows are switched
  
  assign swap_now = (curr_square_state == Row_Swap);
  
  localparam row1 = 2'd0, row2 = 2'd1, row3 = 2'd2;
  
  // This changes what row we are drawing in
  always @(posedge clk)
  begin: row_state_table
    case(curr_row_state) // Change row whenever we are in row swap state for square drawing
      row1: curr_row_state = swap_now ? row2 : row1;
      row2: curr_row_state = swap_now ? row3 : row2;
      row3: curr_row_state = swap_now ? row1 : row3;
      default: curr_row_state = row1;
    endcase
    
    case(curr_square_state) // Will cycle through all 30 squares then go to the next row and begin cycle again
      Square1: curr_square_state = Square2;
      Square2: curr_square_state = Square3;
      Square3: curr_square_state = Square4;
      Square4: curr_square_state = Square5;
      Square5: curr_square_state = Square6;
      Square6: curr_square_state = Square7;
      Square7: curr_square_state = Square8;
      Square8: curr_square_state = Square9;
      Square9: curr_square_state = Square10;
      Square10: curr_square_state = Square11;
      Square11: curr_square_state = Square12;
      Square12: curr_square_state = Square13;
      Square13: curr_square_state = Square14;
      Square14: curr_square_state = Square15;
      Square15: curr_square_state = Square16;
      Square16: curr_square_state = Square17;
      Square17: curr_square_state = Square18;
      Square18: curr_square_state = Square19;
      Square19: curr_square_state = Square20;
      Square20: curr_square_state = Square21;
      Square21: curr_square_state = Square22;
      Square22: curr_square_state = Square23;
      Square23: curr_square_state = Square24;
      Square24: curr_square_state = Square25;
      Square25: curr_square_state = Square26;
      Square26: curr_square_state = Square27;
      Square27: curr_square_state = Row_Swap;
     /* Square28: curr_square_state = Square29;
      Square29: curr_square_state = Square30;
      Square30: curr_square_state = Row_Swap;*/ 
      Row_Swap: curr_square_state = Square1;
      default: curr_square_state = Square1;
    endcase
  end

  always@(*)
  begin: make_coordinates
    // Coordinates determined by starting constant defined added with a multiple of the offset constant
	 if (curr_square_state != Row_Swap)
	   begin
		  // Pick square to draw in row
        curr_x = {start_x + {x_offset * curr_square_state}};
        curr_y = {start_y + {y_offset * curr_row_state}};
		  case(curr_row_state) // Pick row to draw in
          row1: curr_colour = red_sequence[curr_square_state] ? RED : BLACK;
          row2: curr_colour = yellow_sequence[curr_square_state] ? YELLOW : BLACK;
          row3: curr_colour = blue_sequence[curr_square_state] ? CYAN : BLACK;
          default: curr_colour = WHITE;
        endcase
		end
    else
	   begin // when in between states draw a black square out of the main game screen
        curr_x = 0;
		  curr_y = 0;
		  curr_colour = BLACK;
		end
  end
endmodule
