module tatsujin(
  CLOCK_50, //  On Board 50 MHz
  // input
  KEY,
  SW,
  LEDR,
	LEDG,
  HEX0,
  HEX1,
  HEX4,
  HEX5,
  HEX6,
  HEX7,
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
  input  [17:0]  SW;
  input  [3:0]  KEY;
  output [17:0] LEDR;
  output [7:0]  HEX6, HEX7, HEX4, HEX5, HEX0, HEX1;

  // Do not change the following outputs
  output      VGA_CLK;           //  VGA Clock
  output      VGA_HS;          //  VGA H_SYNC
  output      VGA_VS;          //  VGA V_SYNC
  output      VGA_BLANK_N;        //  VGA BLANK
  output      VGA_SYNC_N;        //  VGA SYNC
  output  [9:0]  VGA_R;           //  VGA Red[9:0]
  output  [9:0]  VGA_G;           //  VGA Green[9:0]
  output  [9:0]  VGA_B;           //  VGA Blue[9:0]
  output [4:0] LEDG;
  // Create the colour, x, y and writeEn wires that are inputs to the controller.
  wire [2:0] colour;
  wire [7:0] x;
  wire [6:0] y;
  wire writeEn;

  // Create an Instance of a VGA controller - there can be only one!
  // Define the number of colours as well as the initial background
  // image file (.MIF) for the controller.
  vga_adapter VGA(
    .resetn(1'b1),
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

  wire [6:0] y_wip;
  wire [7:0] x_wip;
  wire [2:0] colour_wip;

  wire [99:0] song_loader;

  // draws an individual square
  square4x4 draw(.clk(CLOCK_50),
                 .x_coords(x_wip),
                 .y_coords(y_wip),
                 .input_colour(colour_wip),
                 .finalX(x),
                 .finalY(y),
                 .output_colour(colour)
    );

  // outputs new x and y coordinates to draw all 3 rows
  square_info animation(.red_sequence(output_red),
                        .yellow_sequence(output_yellow),
                        .blue_sequence(output_blue),
                        .clk(draw_clock),
                        .output_x(x_wip),
                        .output_y(y_wip),
                        .colour(colour_wip));

  // above square_info will output a new x & y coordinate every 17 ticks
  // note: 16 tick drawing, 1 tick buffer
  wire draw_clock;
  rate_divider drawing_clock(CLOCK_50, 28'b0000000000000000000000010011, draw_clock, 1'b1);

  wire [99:0] load_red, load_yellow, load_blue;
  
  // Note storage
  note_storage notes(.output_blue(output_blue),
                     .output_red(output_red),
                     .output_yellow(output_yellow),
                     .slow_clk(reset_counter),
                     .load_n(!KEY[3]),
                     .input_red(load_red),
                     .input_yellow(load_yellow),
                     .input_blue(load_blue));

  // Song loader
  wire [7:0] total_notes;
  song_loader songs(.song_select(SW[3:0]),
                    .output_red(load_red),
                    .output_yellow(load_yellow),
                    .output_blue(load_blue),
                    .output_total_notes(total_notes));
  
  wire increase_score, decrease_score;

  // shifting the song by 1 every counter tick
  wire [25:0] output_blue, output_red, output_yellow;

  // this sends increase or decrease signal
  player_control click_right({output_red[25], output_yellow[25], output_blue[25]},
                             ~(KEY[2:0]), // 2 = red, 1 = yellow, 0 = blue
                             increase_score,
                             decrease_score);


  assign LEDG[4] = output_red[25];
  assign LEDG[2] = output_yellow[25];
  assign LEDG[0] = output_blue[25];

  // this module holds the score using the increase and decrease signals
  wire [7:0] the_score;
  score_counter count_player_score(.increase_score(increase_score),
                                   .decrease_score(decrease_score),
                                   .reset(!KEY[3]),
                                   .clk(reset_counter),
                                   .score(the_score));
  
  wire [7:0] counter_value;
  wire reset_counter;
  assign reset_counter = (counter_value == 8'd2); // Reset counter when it gets to 2
  
  counter ticks(
    .clock(slow_clock),
    .q(counter_value),
    .enable(1'b1),
    .clear_b(!reset_counter)
  );
  // Display score to screen
  seven_segment_display lo(the_score[3:0], HEX6);
  seven_segment_display hi(the_score[7:4], HEX7);
  
  seven_segment_display lo(total_notes[3:0], HEX4);
  seven_segment_display hi(total_notes[7:4], HEX5);

  // module to calculate the combo.
  wire [7:0] the_combo;
  combo_counter count_player_combo(increase_score,
                                   decrease_score,
                                   reset_counter,
                                   the_combo);

  seven_segment_display combo_lo(the_combo[3:0], HEX0);
  seven_segment_display combo_hi(the_combo[7:4], HEX1);

  // NOTE: (to self) this works!
  // controls the speed of the song
  // rate_divider speed_of_song(.clock(CLOCK_50),
  //                            .divide_by(28'b00010111110101111000000100000),
	// 						                .out_signal(slow_clock),
	// 							              .reset_b(1'b1));
  wire slow_clock;
  rate_divider_choose speed_of_song2(.clock(CLOCK_50),
                                     .load_selectors(SW[1:0]),
                                     .out_signal(slow_clock),
                                     .reset_b(1'b1));
endmodule
