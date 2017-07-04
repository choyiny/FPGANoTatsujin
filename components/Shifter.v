`timescale 1ns / 1ns

// 100 bit shifter
module shifter100Bit(load_val, in, shift, load_n, clock, reset_n, out);
  input [99:0] load_val;
  input in, shift, load_n, reset_n;
  input clock;
  output [99:0] out;
  
  wire [9:0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9;
  
  assign out = {out_9, out_8, out_7, out_6, out_5, out_4, out_3, out_2, out_1, out_0};
  
  shifter10Bit s9(
    .load_val(load_val[99:90]),
    .in(in),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_9)
  );
  
  shifter10Bit s8(
    .load_val(load_val[89:80]),
    .in(out_9[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_8)
  );
  
  shifter10Bit s7(
    .load_val(load_val[79:70]),
    .in(out_8[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_7)
  );
  
  shifter10Bit s6(
    .load_val(load_val[69:60]),
    .in(out_7[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_6)
  );
  
  shifter10Bit s5(
    .load_val(load_val[59:50]),
    .in(out_6[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_5)
  );
  
  shifter10Bit s4(
    .load_val(load_val[49:40]),
    .in(out_5[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_4)
  );
  
  shifter10Bit s3(
    .load_val(load_val[39:30]),
    .in(out_4[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_3)
  );
  
  shifter10Bit s2(
    .load_val(load_val[29:20]),
    .in(out_3[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_2)
  );
  
  shifter10Bit s1(
    .load_val(load_val[19:10]),
    .in(out_2[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_1)
  );
  
  shifter10Bit s0(
    .load_val(load_val[9:0]),
    .in(out_1[0]),
    .shift(shift),
    .load_n(load_n),
    .clock(clock),
    .reset_n(reset_n),
    .out(out_0)
  );
endmodule

// 10 bit shifter
// 10 is another easy number to work with
module shifter10Bit(load_val, in, shift, load_n, clock, reset_n, out);
  input [9:0] load_val;
  input in, shift, load_n, reset_n;
  input clock;
  output [9:0] out;
  
  // outputs of bits
  wire [4:0] lower_5_out, upper_5_out;
  
  assign out = {upper_5_out, lower_5_out};
  
  shifter5Bit upper(
    .load_val(load_val[9:5]),
    .in(in),
    .clk(clock),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n),
    .out(upper_5_out)
  );
  
  shifter5Bit lower(
    .load_val(load_val[4:0]),
    .in(upper_5_out[0]),
    .clk(clock),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n),
    .out(upper_5_out)
  );
endmodule


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
    .load_n(load_n)
  );
  
  shifterBit bit_1(
    .in(bit_0_out),
    .out(bit_1_out),
    .clk(clock),
    .load_val(load_val[1]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n)
  );
  
  shifterBit bit_2(
    .in(bit_1_out),
    .out(bit_2_out),
    .clk(clock),
    .load_val(load_val[2]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n)
  );
  
  shifterBit bit_3(
    .in(bit_2_out),
    .out(bit_3_out),
    .clk(clock),
    .load_val(load_val[3]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n)
  );
  
  shifterBit bit_4(
    .in(bit_3_out),
    .out(bit_4_out),
    .clk(clock),
    .load_val(load_val[4]),
    .reset_n(reset_n),
    .shift(shift),
    .load_n(load_n)
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
