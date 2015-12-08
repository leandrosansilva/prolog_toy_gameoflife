% vim, please detect prolog

cell_new_state(dead_cell, 3, live_cell).

cell_new_state(live_cell, Neighbours, live_cell) :-
  member(Neighbours, [2, 3]).

cell_new_state(_, _, dead_cell).

north(coord(X, Y), coord(X, NY)) :- NY is Y - 1.
south(coord(X, Y), coord(X, NY)) :- NY is Y + 1.
west(coord(X, Y), coord(NX, Y)) :- NX is X - 1.
east(coord(X, Y), coord(NX, Y)) :- NX is X + 1.

south_east(coord(X, Y), coord(NX, NY)) :-
  south(coord(X, Y), coord(SX, SY)),
  east(coord(SX, SY), coord(NX, NY)).

south_west(coord(X, Y), coord(NX, NY)) :-
  south(coord(X, Y), coord(SX, SY)),
  west(coord(SX, SY), coord(NX, NY)).

north_west(coord(X, Y), coord(NX, NY)) :-
  north(coord(X, Y), coord(SX, SY)),
  west(coord(SX, SY), coord(NX, NY)).

north_east(coord(X, Y), coord(NX, NY)) :-
  north(coord(X, Y), coord(SX, SY)),
  east(coord(SX, SY), coord(NX, NY)).

neighbours(Coord, Neighbours) :- 
  north_west(Coord, NW),
  north(Coord, N),
  north_east(Coord, NE),
  east(Coord, E),
  south_east(Coord, SE),
  south(Coord, S),
  south_west(Coord, SW),
  west(Coord, W),
  list_to_set([NW, N, NE, E, SE, S, SW, W], Neighbours).

empty_world(world([], [])).

world_add_cell(world(LiveCells, DeadCells), Cell, world(UnionLiveCells, NewDeadCells)) :-
  union([Cell], LiveCells, UnionLiveCells),
  neighbours(Cell, Neighbours),
  union(DeadCells, Neighbours, DeadCellsUnion),
  subtract(DeadCellsUnion, UnionLiveCells, NewDeadCells).

world_add_cells(World, [], World).

world_add_cells(World, [H|T], NewWorld) :-
  world_add_cell(World, H, IntermediateWorld),
  world_add_cells(IntermediateWorld, T, NewWorld).

live_neighbours(world(LiveCells, _), Coord, LiveNeighbours) :-
  neighbours(Coord, Neighbours),
  intersection(LiveCells, Neighbours, LiveNeighbours).

evolve(_, NextGenWorld) :-
  empty_world(NextGenWorld).
