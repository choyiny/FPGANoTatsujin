/**

WORK IN PROGRESS!

**/
module move(CLOCK_50);

  wire animation_clk;

  rate_divider draw_divider(.clock(CLOCK_50),
                            .load_selectors(2'b00), // 1/60 second output
                            .out_signal(animation_clk),
                            .reset_b(1'b1));

  move_red my_red_square_animation(.go(1'b1),
                                   .start_x(4'b1111),
                                   .start_y(4'b1111),
                                   .clock(animation_clk),
                                   .finalX(),
                                   .finalY(),
                                   .output_colour())

endmodule


/**
 * Move a square along the x axis from right to left
 */
module move_red(
  input go,
  input start_x,
  input start_y,
  input clock,
  output [7:0] finalX,
  output [7:0] finalY
  output [2:0] output_colour
  );

  // output colour is always red
  assign output_colour = 3'b100;


endmodule
