`timescale 1ns/1ns

module noteshifter(output_blue,
                   output_red,
                   output_yellow,
                   slow_clk,
                   load_n,
                   input_red,
                   input_yellow,
                   input_blue);

  output [26:0] output_blue, output_red, output_yellow;
  input slow_clk;
  
  input [99:0] input_red, input_yellow, input_blue;
  input load_n;

  reg [99:0] blue_reg = {100{1'b0}};
  reg [99:0] red_reg = {100{1'b0}};
  reg [99:0] yellow_reg = {100{1'b0}};

  assign output_red = red_reg[99:73];
  assign output_blue = blue_reg[99:73];
  assign output_yellow = yellow_reg[99:73];

  always @ (posedge slow_clk) begin
    if (load_n == 1'b0) // If not loading a song in
      begin
        // Shift every register one note over on every clock tick
        blue_reg <= blue_reg << 1;
	      red_reg <= red_reg << 1;
	      yellow_reg <= yellow_reg << 1;
      end
    else // If loading a song in
      begin
        blue_reg <= input_blue;
        red_reg <= input_red;
        yellow_reg <= input_yellow;
      end
  end
endmodule
