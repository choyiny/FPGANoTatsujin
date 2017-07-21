/**
 * Rate divider given a CLOCK_50
 * @input clock to be used
 * @input load_selectors select at which rate the rate divider should output
 * @input divide_by 28 bits to countdown
 * @input reset_b a synchronous reset for the rate divider
 * @output out_signal the output signal
 */
module rate_divider_choose(clock, load_selectors, out_signal, reset_b);
  reg [27:0] stored_value;
  input reset_b;
  output out_signal;

  input [1:0] load_selectors; // controls how fast the clock goes
  input clock;

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
              stored_value <= 28'b00010111110101111000100010000; // slowest
          else if (load_selectors == 2'b10)
              stored_value <= 28'b00010111110101111110000100000; // slower
          else if (load_selectors == 2'b01)
              stored_value <= 28'b0001011111011111110000100000; // normal
          else
              stored_value <= 28'b0001011111010100000010000000; // insane
        end
      // stored value is not 0
      else
          stored_value = stored_value - 1'b1;
    end
endmodule


/**
 * Rate divider given a CLOCK_50
 * @input clock to be used
 * @input load_selectors select at which rate the rate divider should output
 * @input divide_by 28 bits to countdown
 * @input reset_b a synchronous reset for the rate divider
 * @output out_signal the output signal
 */
module rate_divider(clock, divide_by, out_signal, reset_b);
  reg [27:0] stored_value;
  input reset_b;
  output out_signal;

  input [27:0] divide_by; // 28 bit
  input clock;

  assign out_signal = (stored_value == 1'b0);

  // begin always block
  always @ (posedge clock)
    begin
      // reset
      if (reset_b == 1'b0) begin
          stored_value <= 0;
	      end
      // stored value is 0
      else if (stored_value == 1'b0)
        begin
          // 28'b1011111010111100001000000000; | 200 million
          // 28'b0101111101011110000100000000; | 100 million
          // 28'b0010111110101111000010000000; | 50 million
          // 28'b0000000000000000000000010000; | 16
          stored_value <= divide_by;
        end
      // decrement by 1 if stored value is not 0
      else
          stored_value <= stored_value - 1'b1;
    end
endmodule
