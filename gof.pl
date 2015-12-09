% vim, please detect prolog

cell_new_state(dead_cell, 3, live_cell).

cell_new_state(live_cell, Neighbours, live_cell) :-
  member(Neighbours, [2, 3]).

cell_new_state(_, _, dead_cell).

north(cell(X, Y), cell(X, NY)) :- NY is Y - 1.
south(cell(X, Y), cell(X, NY)) :- NY is Y + 1.
west(cell(X, Y), cell(NX, Y)) :- NX is X - 1.
east(cell(X, Y), cell(NX, Y)) :- NX is X + 1.

south_east(cell(X, Y), cell(NX, NY)) :-
  south(cell(X, Y), cell(SX, SY)),
  east(cell(SX, SY), cell(NX, NY)).

south_west(cell(X, Y), cell(NX, NY)) :-
  south(cell(X, Y), cell(SX, SY)),
  west(cell(SX, SY), cell(NX, NY)).

north_west(cell(X, Y), cell(NX, NY)) :-
  north(cell(X, Y), cell(SX, SY)),
  west(cell(SX, SY), cell(NX, NY)).

north_east(cell(X, Y), cell(NX, NY)) :-
  north(cell(X, Y), cell(SX, SY)),
  east(cell(SX, SY), cell(NX, NY)).

neighbours(Cell, Neighbours) :-
  north_west(Cell, NW),
  north(Cell, N),
  north_east(Cell, NE),
  east(Cell, E),
  south_east(Cell, SE),
  south(Cell, S),
  south_west(Cell, SW),
  west(Cell, W),
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

live_neighbours_from_live_set(LiveCells, Cell, LiveNeighbours) :-
  neighbours(Cell, Neighbours),
  intersection(LiveCells, Neighbours, LiveNeighbours).

live_neighbours(world(LiveCells, _), Cell, LiveNeighbours) :-
  live_neighbours_from_live_set(LiveCells, Cell, LiveNeighbours).

try_to_insert_cell_new_world(World, _, dead_cell, World).

try_to_insert_cell_new_world(World, Cell, live_cell, NewWorld) :-
  world_add_cell(World, Cell, NewWorld).

get_cell_state(world(LiveCells, _), Cell, live_cell) :-
  intersection(LiveCells, [Cell], [Cell]).

get_cell_state(_, _, dead_cell).

evolve_util(_, world([], _), NextGenWorld, NextGenWorld).

evolve_util(InitialWorld, world([Cell|LiveTail], _), PartialNextGenWorld, NextGenWorld) :-
  live_neighbours(InitialWorld, Cell, LiveNeighbours),
  length(LiveNeighbours, NLiveNeighbours),
  cell_new_state(live_cell, NLiveNeighbours, NewCellState),
  try_to_insert_cell_new_world(PartialNextGenWorld, Cell, NewCellState, LessPartialNextGenWorld),
  subtract([Cell|LiveTail], [Cell], LiveRemains), % keeps set structure
  evolve_util(InitialWorld, world(LiveRemains, _), LessPartialNextGenWorld, NextGenWorld).

evolve(World, NextGenWorld) :-
  empty_world(EmptyWorld),
  evolve_util(World, World, EmptyWorld, NextGenWorld).
