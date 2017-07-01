/**
 * Rate divider given a CLOCK_50
 * @input clock CLOCK_50
 * @input load_selectors select at which rate the rate divider should output
 * @input reset_b a synchronous reset for the rate divider
 * @output out_signal the output signal
 */
module rate_divider(clock, load_selectors, out_signal, reset_b);
  reg [28:0] stored_value;
  input reset_b;
  output out_signal;

  /*
   * load_selectors[1] load_selectors[0] speed
   * 0                 0                 1/60th second
   * 0                 1                 1 second
   * 1                 0                 2 seconds
   * 1                 1                 4 seconds
  */
  input [1:0] load_selectors; // controls how fast the clock goes
  input clock; // CLOCK_50 should be used

  assign out_signal = (stored_value == 1'b0);

  // begin always block
  always @ (posedge clock)
    begin
      // reset
      if (reset_b == 1'b0)
          stored_value <= 0;
      // stored value is 0
      else if (stored_value == 1'b0)
        begin
          if (load_selectors == 2'b11)
              stored_value <= 28'b1011111010111100001000000000; // 200 million
          else if (load_selectors == 2'b10)
              stored_value <= 28'b0101111101011110000100000000; // 100 million
          else if (load_selectors == 2'b01)
              stored_value <= 28'b0010111110101111000010000000; // 50 million
          else
              stored_value <= 28'b0000011110100001001000000000; // 8 million
        end
      // decrement by 1 if stored value is not 0
      else
          stored_value = stored_value - 1'b1;
    end
endmodule
