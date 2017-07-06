/**
 * This module picks what square should be drawn and outputs its co-ordinates as well as its colour based
 * on the note stream input (the lowest bits of a shifter)
 *
 * @input notes the lowest notes from the shifter
 * @input clock the clock for timing
 * @output squareX the x-coordinate of the square to draw
 * @output colour the colour the VGA module should draw
 */
module pick_square(
          input [9:0] notes,
          input clock,
          output [7:0] squareX,
          output [2:0] colour);
  
  wire [7:0] counter_value;
  counter ticks(
    .clock(clock),
    .q(counter_value),
    .enable(1'b1),
    .clear_b(reset_counter)
  );
  
  wire reset_counter;
  assign reset_counter = (counter_value == 8'd16); // Reset counter when it gets to 16
  
  // Connecting wires
  wire [7:0] x-coordinate;
  assign squareX = x-coordinate;
  wire [9:0] input_notes;
  assign input_notes = notes;
  wire [2:0] colour_wire;
  assign colour = colour_wire;
  
  // Finite state machine
  pick_square_fsm(
    .go(clock), // Will always be running
    .clock(reset_counter), // This essentially makes the finite state machine clock run only every 17 ticks
    .notes(input_notes),
    .squareX(x-coordinate),
    .ccolour(colour_wire)
  );
  
  
endmodule

/**
 * Finite state machine for the square picker.
 *
 * @input go the signal to start the FSM if it 
 * @input clock the clock signal for timing
 * @input notes the lowest bits from the note register, used to determine output colour
 * @output squareX the x-coordinate of the current square
 * @output the colour of the current square
 */
module pick_square_fsm(
          input go,
          input clock,
          input [9:0] notes,
          output [7:0] squareX,
          output [2:0] colour);
  reg [5:0] current_state, next_state;
  
  // States
  localparam  RESTING = 5'd0,
              S0 = 5'd1,
              S1 = 5'd2,
              S2 = 5'd3,
              S3 = 5'd4,
              S4 = 5'd5,
              S5 = 5'd6,
              S6 = 5'd7,
              S7 = 5'd8,
              S8 = 5'd9,
              S9 = 5'd10;
  
  // Colour
  localparam RED = 3'b100,
             BLACK = 3'b000;
  reg [2:0] curr_colour;
  assign colour = curr_colour;

  // Coordinates
  reg [7:0] coordinates;
  localparam initialX = 7'b0, // X-coordinate of first square
             squareOffset = 7'b0000101; // How far the origin of each square should be from each other
  assign squareX = coordinates;
  
  // State transitions
  always @(posedge clock) begin: state_table
    case (current_state):
      P0: next_state = P1;
      P1: next_state = P2;
      P2: next_state = P3;
      P3: next_state = P4;
      P4: next_state = P5;
      P5: next_state = P6;
      P6: next_state = P7;
      P7: next_state = P8;
      P8: next_state = P9;
      P9: next_state = RESTING;
      RESTING: = go ? P0 : RESTING;
    endcase
    
    // Assign outputs
    always @(*) begin: output_assignment
      case (current_state):
        P0: begin
          curr_colour = notes[0] ? RED : BLACK;
          coordinates <= initalX;
          end
        P1: begin
          curr_colour = notes[1] ? RED : BLACK;
          coordinates <= (initialX + squareOffset);
          end
        P2: begin
          curr_colour = notes[2] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 2));
          end
        P3: begin
          curr_colour = notes[3] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 3));
          end
        P4: begin
          curr_colour = notes[4] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 4));
          end
        P5: begin
          curr_colour = notes[5] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 5));
          end
        P6: begin
          curr_colour = notes[6] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 6));
          end
        P7: begin
          curr_colour = notes[7] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 7));
          end
        P8: begin
          curr_colour = notes[8] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 8));
          end
        P9: begin
          curr_colour = notes[9] ? RED : BLACK;
          coordinates <= (initialX + (squareOffset * 9));
          end
      endcase
  end
endmodule
