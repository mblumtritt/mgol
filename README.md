# Mike's Game of Life

I liked to find out if I'm able to implement a "[Conway's Game of Life](https://en.wikipedia.org/wiki/Game_of_Life)" in [Ruby](https://github.com/ruby) which demonstrates it's current state graphically in an acceptable speed. With the help of [Gosu](https://github.com/gosu/gosu) (which I already used before in some game development) it was easy to have fast (enough) graphics. But the real challenge was to find a fast algorithm in Ruby for the Game of Life automat.

I was aware that Ruby isn't the fastest interpreter around. That why the question was if it's possible to tweak an algorithm to become fast enough. After the first very straight forward Array-based implementation I switched to an [HasLife](http://www.conwaylife.com/wiki/HashLife)-like solution (yes Hashes are really fast in Ruby). With my current implementation I removed any object creation (creating objects in Ruby is very slow) and reduced the algorithm for hash calculation (which was easy as soon as I remembered the good old offset calculation for two dimensional Arrays from my good old assembler days)...

I'm not complete satisfied with the current solution but:

- it's fast,
- it contains some cool tricks
- and I learned a lot about Ruby.
- And it showed again that thinking twice about your algorithms is it worth!

## Installation

Simply clone and bundle this repo:

```
git clone https://github.com/mblumtritt/mgol
cd mgol
bundle
```

You need a C compiler in your environment, because Gosu is a native extension (see [Gosu project](https://github.com/gosu/gosu)).

## Run & Experiment

Simpy start with

```
./bin/mgol
```

I already add some samples from [LifeWiki](www.conwaylife.com/wiki) which can be used for first experiments. You can add optionally a directory which includes RLE patterns (see the fantastic pattern collection at [LifeWiki](www.conwaylife.com/wiki)):

```
./bin/mgol ./my_gol_pattern
```

Look at the code - if you like take it as a challenge to implement your own Board class! :)

## Game Navigation

- [SPACE] toggles between edit/game mode
- [BACKSPACE] clears the game board and enters edit mode
- [ENTER] fills the board with random dots
- [1]..[9] changes the solution (clears the board)
- [ESC] terminates the program

In edit mode:

- [LEFT MOUSE BUTTON] inserts current selected pattern
- [RIGHT MOUSE BUTTON] toggles a single cell
- [LEFT] / [UP] selects previous pattern
- [RIGHT] / [DOWN] selects next pattern
