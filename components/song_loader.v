`timescale 1ns/1ns

module song_loader(song_select, song_output);
  input [4:0] song_select;
  output [99:0] song_output;

  reg [99:0] song;
  assign song_output = song;
  always @(*)
  begin
    case (song_select[4:0])
      // More cases to be added in future, each case is its own song
      default: song <= 100'b0; // Default is no song
    endcase
  end
endmodule
