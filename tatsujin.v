module project(
  CLOCK_50,            //  On Board 50 MHz
  // Your inputs and outputs here
    KEY,
    SW,
    LEDR,
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

  input      CLOCK_50;        //  50 MHz
  input   [9:0]   SW;
  input   [3:0]   KEY;

  // Declare your inputs and outputs here
  // Do not change the following outputs
  output      VGA_CLK;           //  VGA Clock
  output      VGA_HS;          //  VGA H_SYNC
  output      VGA_VS;          //  VGA V_SYNC
  output      VGA_BLANK_N;        //  VGA BLANK
  output      VGA_SYNC_N;        //  VGA SYNC
  output  [9:0]  VGA_R;           //  VGA Red[9:0]
  output  [9:0]  VGA_G;           //  VGA Green[9:0]
  output  [9:0]  VGA_B;           //  VGA Blue[9:0]

  wire resetn;
  assign resetn = KEY[0];

  // Create the colour, x, y and writeEn wires that are inputs to the controller.
  wire [2:0] colour;
  wire [7:0] x;
  wire [6:0] y;
  wire writeEn;

  // Create an Instance of a VGA controller - there can be only one!
  // Define the number of colours as well as the initial background
  // image file (.MIF) for the controller.
  vga_adapter VGA(
  .resetn(resetn),
  .clock(CLOCK_50),
  .colour(colour),
  .x(x),
  .y(y),
  .plot(writeEn),
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
  defparam VGA.BACKGROUND_IMAGE = "black.mif";


  // Instansiate datapath
  // datapath d0(...);

  wire [7:0] start_x = 8'b1010_0101
  wire [6:0] start_y = 7'b1010101;
  wire [2:0] the_color = 3'b100;
  wire [1:0] x_offset, y_offset;

  datapath draw_a_square(.input_colour(the_colour),
                         .x_coords(start_x),
                         .y_coords(start_y),
                         .xOffset(x_offest),
                         .yOffset(y_offset),
                         .finalX(x),
                         .finalY(y),
                         .output_colour(colour)
    );

  square4x4 square_make(.clk(CLOCK_50),
                        .resetn(1'b0),
                        .go(1'b1),
                        .xOffset(x_offset),
                        .yOffset(y_offset),
                        .plot(writeEn)
   );

  // rate_divider for_draw_10_square(.clock(CLOCK_50),
  //                                 .divide_by(28'b0010111110101111000010000000),
  //                                 .reset_b(1'b1),
  //                                 .out_signal(divided_clock)
  //                                 );
  //
  // wire divided_clock;
  //
  // // debug things
  // LEDR[2] = divided_clock;
  //
  // square10 draw_10_squares(.red_sequence(10'b0110101010),
  //                          .yellow_sequence(10'b0000000000),
  //                          .clk(divided_clock),
  //                          .starting_x(start_x),
  //                          .starting_y(start_y),
  //                          .colour(the_colour)
  //                          );

endmodule
