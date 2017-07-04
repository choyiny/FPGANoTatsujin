# Verilog Rhythm Game
Verilog Rhythm Game - CSCB58 Summer Computer Organization Project

By: Cho Yin Yong, Austin Seto

## Description
This is a rhythm game for FGPA boards in which four different kinds of notes are represented with four different buttons on the FGPA board. On a connected screen the notes are displayed as coloured streams, where each node as their own colour. Where black appears, the note is not to be played. Where a colour appears, the note is to be played. 

## How it works

Each note will be associated with a shifter containing `n` bits, where `n` is the maximum length for a song. Each clock cycle (controlled by a rate divider), the shifter will right shift. Is the player has the button for a note down when the right most bit is a 1, they get a point. The shifter bits lowest bits are drawn on a VGA screen in coloured boxes. A zero is a black square (or no square drawn) while a one is a coloured square.  

A song is loaded by simultaneously loading every shifter bit with a binary sequence that determines when notes should be played. There is a [Note Map Tool](https://github.com/AustinSeto/Note-Map-Tool) meant to help generate these sequences. 

## Acknowledgements
The VGA Module is taken from Lab 6 of this course: http://www.utsc.utoronto.ca/~bharrington/cscb58/labs.shtml
