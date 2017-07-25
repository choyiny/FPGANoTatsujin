# FPGA no Tatsujin
FPGA no Tatsujin - CSCB58 Summer Computer Organization Project

By: Cho Yin Yong, Austin Seto

<img src="https://raw.githubusercontent.com/choyiny/FPGANoTatsujin/master/Tatsujin.png" width="500">


This is a game inspired by Tatsujin No Taiko and Guitar Hero, rhythm games that are very popular. We recreated a rhythm game from hardware principles.

## How to play?
3 rows of square move from left to right. When it reaches the end of the box, click the KEY associated with the colour of the square.

* SW[0] - CYAN
* SW[1] - YELLOW
* SW[2] - RED

If you are unable to follow the VGA screen, or the VGA screen is not available, the LEDs above the keys will light up when you are supposed to press the button.

**Scoring System**

Getting a column correct will earn you +1 point, and wrong will earn you +0 points. An empty column is worth 0 points.

* HEX5/6 displays your score
* HEX3/4 displays the highest possible score
* HEX0/1 displays your current combo


Don't feel challenged? Try the settings below:

**Speed of the song**

Controlled by SW[17:16]
* 11 = slowest
* 10 = slower
* 01 = normal
* 00 = insane

**Song**

Controlled by SW[4:0]

Song Name | Author | Setting
--- | --- | ---
Through The Fire and Flames | Austin Seto | 11111
Take on Me | Austin Seto | 00011
Vlad Bit | Vladimir Efimov | 01010
Brian This Project Is Worth Full Marks | Cho Yin Yong | 10111
Rick Roll | Austin Seto | 00101

## Structure
In case you are the awesome few that wants to expand on this project, here is how we structured our project.

File name | Description
--- | ---
`tatsujin.v` | our top level module which links the FPGA board and the VGA to our modules
`basic.v` | contains the basic components (flip flops, adders)
`counters.v` | contains a counter module which counts up to 8 bits.
`draw.v` | drawing 1 4x4 square on the VGA
`note_storage.v` | shifter to shift our 100 bit long song by 1 every clock tick
`player_control.v` | sends an increase or decrease signal based on what player pressed
`rate_divider.v` | a rate divider which controls the speed of the song
`score_counter.v` | a counter to keep track of the score
`seven_segment_display.v` | logic used to display hexadecimal to the HEX displays
`song_loader.v` | loads a song to the game
`square_info.v` | output different x and y coordinates for drawing the 3 rows of squares.

Each note will be associated with a shifter containing n bits, where n is the maximum length for a song. Each clock cycle (controlled by a rate divider), the shifter will right shift. Is the player has the button for a note down when the right most bit is a 1, they get a point. The shifter bits lowest bits are drawn on a VGA screen in coloured boxes. A zero is a black square (or no square drawn) while a one is a coloured square.

A song is loaded by simultaneously loading every shifter bit with a binary sequence that determines when notes should be played. 

## Possible expansion
Here are some ideas we never got to execute that are interesting.
* Hook the notes up to a digital speaker
* Hook up a PS/2 keyboard, because KEY is unreliable, and changing settings through SW is not cool.
* Make a main menu!
* Fancy animation when they get combos.
* Make squares smoothly run through the screen.
* Store songs in ram, because ram is pretty cool.
* Make it multiplayer (on the same keyboard), because multiplayer is more intersting than singleplayer.

## Acknowledgements
* The VGA Module is taken from Lab 6 of this course: http://www.utsc.utoronto.ca/~bharrington/cscb58/labs.shtml
* We used this program to convert a BMP to a FPGA board readable MIF file: http://www.eecg.utoronto.ca/~jayar/ece241_08F/vga/vga-download.html
