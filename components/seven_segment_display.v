// Seven Segment Display Module
module seven_segment_display(c, hex);
    input [3:0] c;
    output [6:0] hex;

    hex_0_control zero(c[0], c[1], c[2], c[3], hex[0]);
    hex_1_control one(c[0], c[1], c[2], c[3], hex[1]);
    hex_2_control two(c[0], c[1], c[2], c[3], hex[2]);
    hex_3_control three(c[0], c[1], c[2], c[3], hex[3]);
    hex_4_control four(c[0], c[1], c[2], c[3], hex[4]);
    hex_5_control five(c[0], c[1], c[2], c[3], hex[5]);
    hex_6_control six(c[0], c[1], c[2], c[3], hex[6]);

endmodule

// modules to control
module hex_0_control(c0, c1, c2, c3, hex0);
    input c0, c1, c2, c3;
    output hex0;
    assign hex0 = (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & c0) | (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0);
endmodule

module hex_1_control(c0, c1, c2, c3, hex1);
    input c0, c1, c2, c3;
    output hex1;
    assign hex1 = (c3 & c1 & c0) | (c2 & c1 & ~c0) | (c3 & c2 & ~c0) | (~c3 & c2 & ~c1 & c0);
endmodule

module hex_2_control(c0, c1, c2, c3, hex2);
    input c0, c1, c2, c3;
    output hex2;
    assign hex2 = (c3 & c2 & c1) | (c3 & c2 & ~c0) | (~c3 & ~c2 & c1 & ~c0);
endmodule

module hex_3_control(c0, c1, c2, c3, hex3);
    input c0, c1, c2, c3;
    output hex3;
    assign hex3 = (c2 & c1 & c0) | (c3 & ~c2 & c1 & ~c0) | (c0 ^ c2) & (~c3 & ~c1);
endmodule

module hex_4_control(c0, c1, c2, c3, hex4);
    input c0, c1, c2, c3;
    output hex4;
    assign hex4 = (~c3 & c0) | (~c3 & c2 & ~c1) | (~c2 & ~c1 & c0);
endmodule

module hex_5_control(c0, c1, c2, c3, hex5);
    input c0, c1, c2, c3;
    output hex5;
    assign hex5 = (c0 & ~c1 & c2 & c3) | (c0 & ~c2 & ~c3) | (c1 & ~c2 & ~c3) | (~c3 & c0 & c1);
endmodule

module hex_6_control(c0, c1, c2, c3, hex6);
    input c0, c1, c2, c3;
    output hex6;
    assign hex6 = (~c3 & ~c2 & ~c1) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0);
endmodule
