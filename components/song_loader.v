`timescale 1ns/1ns

module song_loader(song_select, output_red, output_blue, output_yellow);
  input [4:0] song_select;
  output [99:0] output_red, output_blue, output_yellow;

  localparam Through_The_Fire_and_Flames = 4'b1111;// Songs available
  
  reg [99:0] red, blue, yellow;
  assign output_red = red;
  assign output_blue = blue;
  assign output_yellow = yellow;
  
  always @(*)
  begin
    case (song_select[4:0])
      // More cases to be added in future, each case is its own song
      case Through_The_Fire_and_Flames:
        begin
          red    <= 100'b0000000000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010;
          yellow <= 100'b0000000000010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001;
          blue   <= 100'b0000000000000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100;
        end
      default: song <= 100'b0; // Default is no song
    endcase
  end
endmodule
