/**
 * Finite state machine to draw 10 squares to the screen
 */
module square10(
  input [9:0] red_sequence, // this reads the first 10 bits of a shifter
  input [9:0] yellow_sequence,

  // how fast the x,y coordinates should change.
  // this should not be faster than drawing the square (currently 4x4)
  input clk,
  input resetn,
  output plot,

  output reg [7:0] starting_x, // outputs the starting x coordinate for a square
  output [6:0] starting_y, // outputs the starting y coordinate for a square
  output [2:0] colour // determines the colour (either draw or erase)

  );

  reg [6:0] current_state, next_state;

  // Colours to output
  // BLACK = 0
  // RED = 1
  // YELLOW = 2
  // GREEN = 3
  // BLUE = 4
  reg [3:0] draw;

  localparam BLACK = 3'b000,
             RED = 3'b100,
             YELLOW = 3'b110,
             GREEN = 3'b010,
             BLUE = 3'b001;

  // assign colour to draw
  assign colour = draw;

  // Y will always stay constant
  assign starting_y = 7'b1110000;

  localparam SQ1 = 6'd0, SQ2 = 6'd1, SQ3 = 6'd2, SQ4 = 6'd5,
             SQ5 = 6'd6, SQ6 = 6'd7, SQ7 = 6'd8, SQ8 = 6'd9, SQ9 = 6'd10,
             SQ10 = 6'd11, RESTING = 6'd12;

  // clock to change states every clock tick
  always @(posedge clk)
  begin: state_table
    case (current_state)
       SQ1: next_state = SQ2;
       SQ2: next_state = SQ3;
       SQ3: next_state = SQ4;
       SQ4: next_state = SQ5;
       SQ5: next_state = SQ6;
       SQ6: next_state = SQ7;
       SQ7: next_state = SQ8;
       SQ8: next_state = SQ9;
       SQ9: next_state = SQ10;
       SQ10: next_state = RESTING;
       default: next_state = RESTING;
    endcase
  end

  // plot when state is not resting
  assign plot = (current_state != RESTING);

  always@(*)
  begin: make_output
    case(current_state)
      SQ1:
        begin
          starting_x = 7'd10;
          if (red_sequence[0] == 1'b1)
            draw <= RED;
          else
            if (yellow_sequence[0] == 1'b1)
              draw <= YELLOW;
        end
      SQ2: begin
        starting_x = 7'd20;
        if (red_sequence[1] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[1] == 1'b1)
            draw <= YELLOW;
      end
      SQ3: begin
        starting_x = 7'd30;
        if (red_sequence[2] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[2] == 1'b1)
            draw <= YELLOW;
      end
      SQ4: begin
        starting_x = 7'd40;
        if (red_sequence[3] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[3] == 1'b1)
            draw <= YELLOW;
      end
      SQ5: begin
        starting_x = 7'd50;
        if (red_sequence[4] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[4] == 1'b1)
            draw <= YELLOW;
      end
      SQ6: begin
        starting_x = 7'd60;
        if (red_sequence[5] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[5] == 1'b1)
            draw <= YELLOW;
      end
      SQ7: begin
        starting_x = 7'd70;
        if (red_sequence[6] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[6] == 1'b1)
            draw <= YELLOW;
      end
      SQ8: begin
        starting_x = 7'd80;
        if (red_sequence[7] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[7] == 1'b1)
            draw <= YELLOW;
      end
      SQ9: begin
        starting_x = 7'd90;
        if (red_sequence[8] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[8] == 1'b1)
            draw <= YELLOW;
      end
      SQ10: begin
        starting_x = 7'd100;
        if (red_sequence[9] == 1'b1)
          draw <= RED;
        else
          if (yellow_sequence[9] == 1'b1)
            draw <= YELLOW;
      end
      RESTING: starting_x = 7'd0;
    endcase
  end

endmodule
