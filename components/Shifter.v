`timescale 1ns / 1ns

// 5 bit shifter
// 5 is an easy number to work with
module shifter5Bit(load_val, in, shift, load_n, clock, reset_n, out);
  input [4:0] load_val;
  input in, shift, load_n, reset_n;
  input clock;
  output [4:0] out;
  
  // outputs of bits
  // Left-most bit is bit 0, right most bit is bit 4
  wire bit_0_out, bit_1_out, bit_2_out, bit_3_out, bit_4_out;
  
  assign out = {bit_0_out, bit_1_out, bit_2_out, bit_3_out, bit_4_out};
  
  // Bits
  shifterBit bit_0(
    .in(in),
    .out(bit_0_out),
    .clk(clock),
    .load_val(load_val[0]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n);
  );
  
  shifterBit bit_1(
    .in(bit_0_out),
    .out(bit_1_out),
    .clk(clock),
    .load_val(load_val[1]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n);
  );
  
  shifterBit bit_2(
    .in(bit_1_out),
    .out(bit_2_out),
    .clk(clock),
    .load_val(load_val[2]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n);
  );
  
  shifterBit bit_3(
    .in(bit_2_out),
    .out(bit_3_out),
    .clk(clock),
    .load_val(load_val[3]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n);
  );
  
  shifterBit bit_4(
    .in(bit_3_out),
    .out(bit_4_out),
    .clk(clock),
    .load_val(load_val[4]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n);
  );
endmodule

// Single shifter bit
module shifterBit(load_val, in, shift, load_n, clk, reset_n, out);
  input load_val;
  input in;
  input shift;
  input load_n;
  input clk;
  input reset_n;
  output out;
  
  wire output_wire;
  wire mux_connector;
  wire mux_to_latch;
  
  mux2to1 shift_mux(
    .s(shift), // 1 to take in from input
    .y(in),
    .x(output_wire),
    .m(mux_connector)
  );
  
  mux2to1 load_mux(
    .s(load_n), // 0 to use load_val;
    .x(load_val),
    .y(mux_connector),
    .m(mux_to_latch)
  );
  
  dFlipFlop latch(
    .clock(clk),
    .reset_n(reset_n),
    .q(output_wire),
    .d(mux_to_latch)
  );
  
  assign out = output_wire;
endmodule
