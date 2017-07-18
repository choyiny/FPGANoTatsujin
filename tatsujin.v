module tatsujin(
    CLOCK_50, //  On Board 50 MHz
  // input
    KEY,
    SW,
   LEDR,
   HEX0,
   HEX1,
  // The ports below are for the VGA output.  Do not change.
  VGA_CLK,               //  VGA Clock
  VGA_HS,              //  VGA H_SYNC
  VGA_VS,              //  VGA V_SYNC
  VGA_BLANK_N,            //  VGA BLANK
  VGA_SYNC_N,            //  VGA SYNC
  VGA_R,               //  VGA Red[9:0]
  VGA_G,               //  VGA Green[9:0]
  VGA_B               //  VGA Blue[9:0]
  );

  input CLOCK_50;
  input  [9:0]  SW;
  input  [3:0]  KEY;
  output [17:0] LEDR;
  output [7:0]  HEX0, HEX1;

  // Do not change the following outputs
  output      VGA_CLK;           //  VGA Clock
  output      VGA_HS;          //  VGA H_SYNC
  output      VGA_VS;          //  VGA V_SYNC
  output      VGA_BLANK_N;        //  VGA BLANK
  output      VGA_SYNC_N;        //  VGA SYNC
  output  [9:0]  VGA_R;           //  VGA Red[9:0]
  output  [9:0]  VGA_G;           //  VGA Green[9:0]
  output  [9:0]  VGA_B;           //  VGA Blue[9:0]

  // Create the colour, x, y and writeEn wires that are inputs to the controller.
  wire [2:0] colour;
  wire [7:0] x;
  wire [6:0] y;
  wire writeEn;

  // Create an Instance of a VGA controller - there can be only one!
  // Define the number of colours as well as the initial background
  // image file (.MIF) for the controller.
  vga_adapter VGA(
    .clock(CLOCK_50),
    .colour(colour),
    .x(x),
    .y(y),
    .plot(1'b1),
    /* Signals for the DAC to drive the monitor. */
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_BLANK(VGA_BLANK_N),
    .VGA_SYNC(VGA_SYNC_N),
    .VGA_CLK(VGA_CLK));
    defparam VGA.RESOLUTION = "160x120";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    defparam VGA.BACKGROUND_IMAGE = "bg.mif";

  wire [6:0] row = 7'b0110101;

  wire [7:0] x_wip;
  wire [2:0] colour_wip;

  wire [99:0] song;

  square4x4 draw(.clk(CLOCK_50),
                 .x_coords(x_wip),
                 .y_coords(row),
                 .input_colour(colour_wip),
                 .finalX(x),
                 .finalY(y),
                 .output_colour(colour)
    );

  pick_square square_select(.notes(output_song),
                            .clock(CLOCK_50),
                            .squareX(x_wip),
                            .colour(colour_wip));

  wire [9:0] output_song;
  noteshifter shifter(output_song, slow_clock);

  wire increase_score, decrease_score;

  // this sends increase or decrease signal
  player_control click_right({3{output_song[0]}},
                             ~(KEY[2:0]),
                             increase_score,
                             decrease_score);

  // this module holds the score
  wire [7:0] the_score;
  score_counter count_player_score(increase_score,
                                   decrease_score,
                                   1'b0,
                                   slow_clock,
                                   the_score);

  wire slow_clock;
  assign LEDR[9:0] = output_song;
  assign LEDR[17] = slow_clock;
  assign LEDR[16] = !(slow_clock);

  seven_segment_display lo(the_score[3:0], HEX0);
  seven_segment_display hi(the_score[7:4], HEX1);

  rate_divider slower_clock(CLOCK_50, 28'b0001011111010111100001000000, slow_clock, 1'b1);

endmodule

module noteshifter(output_song, slow_clk);
  output [9:0] output_song;
  input slow_clk;

  reg [99:0] song_reg = {50{2'b01}};

  assign output_song = song_reg[99:90];

  always @ (negedge slow_clk)
    song_reg <= song_reg << 1;

endmodule
