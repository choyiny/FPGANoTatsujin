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
