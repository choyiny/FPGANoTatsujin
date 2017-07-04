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
  // wire to store not_q value
  wire [7:0] not_q;

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
  tFlipFlop q0(.t(enable), .q(q[0]), .not_q(not_q[0]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q1(.t(q0to1), .q(q[1]), .not_q(not_q[1]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q2(.t(q1to2), .q(q[2]), .not_q(not_q[2]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q3(.t(q2to3), .q(q[3]), .not_q(not_q[3]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q4(.t(q3to4), .q(q[4]), .not_q(not_q[4]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q5(.t(q4to5), .q(q[5]), .not_q(not_q[5]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q6(.t(q5to6), .q(q[6]), .not_q(not_q[6]), .clock(clock), .reset_n(clear_b));
  tFlipFlop q7(.t(q6to7), .q(q[7]), .not_q(not_q[7]), .clock(clock), .reset_n(clear_b));
endmodule
