/**
 * Stores a score as a signed 32-bit integer. 
 *
 * @input increase Increase the score by 1
 * @input decrease Decrease the score by 1
 * @input reset Will reset score to zero
 * @output score the score as a signed 32-bit integer
 */
module score_counter(
          input increase,
          input decrease,
          input reset,
          output [31:0] score);
  reg signed [31:0] storage;
  assign score = storage;
  always @(*) begin
    if (reset)
      storage <= 0;
    else if (increase)
      storage <= storage + 1;
    else if (decrease)
      storage <= storage - 1;
  end
endmodule
