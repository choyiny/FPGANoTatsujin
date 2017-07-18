/**
 * Module that takes in player input and combines it with the notes to be played and sends out signals to either
 * increase or decrease the score.
 * @input notes the notes the player must hit, should be the lowest bits in each of the three note registers
 * @input player_input the input from the player - the buttons they press
 */
module player_control(
          input [2:0] notes,
          input [2:0] player_input,
          output increase_score,
          output decrease_score);
  assign increase_score = (notes == player_input) && (notes = 3'b111);
  assign decrease_score = (notes != player_input) && (notes = 3'b000);
endmodule
