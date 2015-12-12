# Conway's Game of Life in Prolog

So... I am finally studying Prolog.

As I got really interested in the Conway's Game of Life, so decided to use it
as exercise on learning new programming languages and refreshing the ones I know.

I recommend reading more about it on 
<a href="https://en.wikipedia.org/wiki/Conway's_Game_of_Life">Wikipedia</a>.

This implementation is very simple and not very performatic. 
It consists in an infinite world - as opposite to a limited matrix - where the
cells can grow indefinitely on any direction. 

In order to print the world on screen, I created a struct `world_window/4`, which
shows a limited area of the world, but it does not mean there is nothing happening
anywhere else!

My development environment is Debian testing (stretch) 64-bit with Swi-Prolog 7
and Ubuntu 14.04 64-bit with Swi-Prolog 6.

Usage:

From command-line:
```bash
$ ./run_gof.sh
```

Or from `swipl`, using the predicate `game_of_life/2`:
```prolog
?- [gof].
true.
?- game_of_life(
  [cell(4, 1), cell(4, 2), cell(4, 3)], 
  world_window(0, 0, 10, 10)).
```

To add cells on positions (4,1), (4,2) and (4,3) and observe a window which
starts on position (0,0) and has dimension of 10x10 (height x width).

As I am still very newbie in Prolog, expert developers will look to my code
and say: *What a piece of shit!* and they will be right :-)

As future improvements I would say:
- Being able to move the window to explore other regions of the world;
- Use some GUI like XPCE and draw in a kind of canvas, without the
  limitation of a terminal.

But I am not really sure I'll work on it in the future. Just too lazy :-(
