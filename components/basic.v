/**

Basic modules to use.

* T flip flop
* 2to1 multiplexer
* D flip flop
* ripple carry adder
* full adder

**/

module tFlipFlop(t, q, clock, reset_n);
  input t;
  reg stored_value;
  output q;
  input clock;
  input reset_n;

  assign q = stored_value;

  always @(posedge clock, negedge reset_n)
    begin
      if (reset_n == 1'b0)
		  stored_value <= 0;
      else if (t == 1'b1)
		  stored_value <= ~stored_value;
		else
		  stored_value <= stored_value;
    end
endmodule

// module for a multiplexer 2 to 1
module mux2to1(x, y, s, m);
  input x; //selected when s is 0
  input y; //selected when s is 1
  input s; //select signal
  output m; //output

  assign m = s & y | ~s & x;

endmodule

module dFlipFlop(d, q, clock, reset_n);
  input d; // input to flip flop
  output reg q; // output from flip flop
  input clock; // clock signal
  input reset_n; // syncrhonous active low reset

  always @(posedge clock)
    begin
      if (reset_n == 1'b0)
        q <= 0;
      else
        q <= d;
    end
endmodule

// module for a four bit ripple carry adder
module ripple_adder(ci, a, b, s, co);
    // define the input and output
    input ci; // carry bit
    input [3:0] a; // first 4 bit number
    input [3:0] b; // second 4 bit number
    output [3:0] s; // output
    output co;

    // wires to connect the carry bit to the next full adder
    wire fa0_c, fa1_c, fa2_c;

    // connect full adder carry bits to the other full adder
    // final carry bit is co
    full_adder f1(ci, a[0], b[0], s[0], fa0_c);
    full_adder f2(fa0_c, a[1], b[1], s[1], fa1_c);
    full_adder f3(fa1_c, a[2], b[2], s[2], fa2_c);
    full_adder f4(fa2_c, a[3], b[3], s[3], co);

endmodule

// module for a 1 bit full adder
module full_adder(ci, a, b, s, co);
    // define input and output
    input ci, a, b;
    output s, co;

    // boolean expressions of a full adder
    assign co = (a & b) | (a & ci) | (b & ci);
    assign s = a ^ b ^ ci;
endmodule

/**
 * Counter that counts up to eight bits
 * @input enable enable/disable the counter
 * @input clock signal to increase counter by 1
 * @input clear_b to reset the counter to 0
 *
 * @output q output the 8 bit hexadecimal
 */
module counter(enable, clock, clear_b, q);
  // input enable, clock and the reset signal
  input enable, clock, clear_b;
  // output 8 bit wire
  output [7:0] q;

  // wires for and gates
  wire q0to1, q1to2, q2to3, q3to4, q4to5, q5to6, q6to7;

  and(q0to1, enable, q[0]);
  and(q1to2, q0to1, q[1]);
  and(q2to3, q1to2, q[2]);
  and(q3to4, q2to3, q[3]);
  and(q4to5, q3to4, q[4]);
  and(q5to6, q4to5, q[5]);
  and(q6to7, q5to6, q[6]);

  // init the 8 t flip flops
  tFlipFlop q0(.t(enable), .q(q[0]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q1(.t(q0to1), .q(q[1]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q2(.t(q1to2), .q(q[2]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q3(.t(q2to3), .q(q[3]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q4(.t(q3to4), .q(q[4]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q5(.t(q4to5), .q(q[5]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q6(.t(q5to6), .q(q[6]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q7(.t(q6to7), .q(q[7]), .clock(clock), .reset_n(clear_b));
endmodule
