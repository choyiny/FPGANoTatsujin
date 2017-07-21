/**
 * Stores a score as a signed 8-bit integer.
 *
 * @input increase Increase the score by 1
 * @input decrease Decrease the score by 1
 * @input reset Will reset score to zero
 * @output score the score as a signed 8-bit integer
 */
module score_counter(
  input increase_score,
  input decrease_score,
  input reset,
  input clk,
  output [7:0] score);
  reg [7:0] storage;
  assign score = storage;
  always @(posedge clk) begin
    if (reset)
      storage <= 0;
    else if (increase_score)
      storage <= storage + 1;
    else if (decrease_score && storage != 8'b0)
      storage <= storage - 1;
  end
endmodule

/**
 * Simple module to keep track of the combos.
 */
module combo_counter(
  input increase_score,
  input decrease_score,
  input clk,
  output [7:0] combo
  );
  reg [7:0] storage;
  assign combo = storage;
  always @(posedge clk) begin
    if (increase_score)
      storage <= storage + 1;
    else if (decrease_score)
      storage <= 0;
  end
endmodule
