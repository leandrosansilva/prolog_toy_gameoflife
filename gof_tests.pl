% prolog

:- load_files(gof).

:- use_module(library(plunit)).

:- begin_tests(gof_tests).

test(dead_stays_dead) :-
  cell_new_state(dead_cell, 0, dead_cell),
  cell_new_state(dead_cell, 1, dead_cell),
  cell_new_state(dead_cell, 4, dead_cell),
  cell_new_state(dead_cell, 4, dead_cell),
  cell_new_state(dead_cell, 5, dead_cell),
  cell_new_state(dead_cell, 6, dead_cell),
  cell_new_state(dead_cell, 7, dead_cell),
  cell_new_state(dead_cell, 8, dead_cell).

test(dead_3_neighbour_lives) :-
  cell_new_state(dead_cell, 3, live_cell).

test(live_cell_dies) :-
  cell_new_state(live_cell, 0, dead_cell),
  cell_new_state(live_cell, 1, dead_cell),
  cell_new_state(live_cell, 4, dead_cell),
  cell_new_state(live_cell, 5, dead_cell),
  cell_new_state(live_cell, 6, dead_cell),
  cell_new_state(live_cell, 7, dead_cell),
  cell_new_state(live_cell, 8, dead_cell).

test(live_cell_stays_alive) :-
  cell_new_state(live_cell, 2, live_cell),
  cell_new_state(live_cell, 3, live_cell).

test(coord_north) :-
  north(coord(0, 0), coord(0, -1)),
  north(coord(0, -1), coord(0, -2)),
  north(coord(1, 0), coord(1, -1)).

test(coord_south) :-
  south(coord(0, 0), coord(0, 1)),
  south(coord(0, -1), coord(0, 0)),
  south(coord(1, 0), coord(1, 1)).

test(coord_west) :-
  west(coord(0, 0), coord(-1, 0)),
  west(coord(1, 0), coord(0, 0)),
  west(coord(1, 1), coord(0, 1)).

test(coord_east) :-
  east(coord(0, 0), coord(1, 0)),
  east(coord(-1, 0), coord(0, 0)),
  east(coord(-1, 1), coord(0, 1)).

test(coord_south_east) :-
  south_east(coord(0, 0), coord(1, 1)),
  south_east(coord(1, 1), coord(2, 2)).

test(coord_south_west) :-
  south_west(coord(0, 0), coord(-1, 1)),
  south_west(coord(1, 1), coord(0, 2)).

test(coord_north_west) :-
  north_west(coord(0, 0), coord(-1, -1)),
  north_west(coord(1, 1), coord(0, 0)).

test(coord_north_east) :-
  north_east(coord(0, 0), coord(1, -1)),
  north_east(coord(1, 1), coord(2, 0)).

test(coord_neighbours) :-
  neighbours(coord(0, 0), Neighbours),
  length(Neighbours, 8),
  member(coord(-1, -1), Neighbours), 
  member(coord(0, -1), Neighbours), 
  member(coord(1, -1), Neighbours), 
  member(coord(1, 0), Neighbours), 
  member(coord(1, 1), Neighbours), 
  member(coord(0, 1), Neighbours),
  member(coord(-1, 1) ,Neighbours),
  member(coord(-1, 0), Neighbours).

test(add_cell_to_world) :-
  empty_world(Empty),
  world_add_cell(Empty, coord(0, 0), world(LiveCells, DeadCells)),
  member(coord(0, 0), LiveCells),
  length(LiveCells, 1),
  length(DeadCells, 8),
  member(coord(-1, -1), DeadCells), 
  member(coord(0, -1), DeadCells), 
  member(coord(1, -1), DeadCells), 
  member(coord(1, 0), DeadCells), 
  member(coord(1, 1), DeadCells), 
  member(coord(0, 1), DeadCells),
  member(coord(-1, 1), DeadCells),
  member(coord(-1, 0), DeadCells).

test(add_two_distant_cells) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(3, 6), coord(7, 10)], world(LiveAfter2ndInsertion, DeadAfter2ndInsertion)),
  member(coord(3, 6), LiveAfter2ndInsertion),
  member(coord(7, 10), LiveAfter2ndInsertion),
  length(LiveAfter2ndInsertion, 2),
  length(DeadAfter2ndInsertion, 16).

test(add_multiple_cells) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(4, 7), coord(3, 6)], world(LiveAfter2ndInsertion, DeadAfter2ndInsertion)),
  member(coord(3, 6), LiveAfter2ndInsertion),
  member(coord(4, 7), LiveAfter2ndInsertion),
  length(LiveAfter2ndInsertion, 2),
  length(DeadAfter2ndInsertion, 12).

test(count_two_live_neighbours_of_live_cell) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(4, 7), coord(3, 6), coord(5, 6)], NewWorld),
  live_neighbours(NewWorld, coord(4, 7), LiveNeighbours),
  length(LiveNeighbours, 2),
  member(coord(5, 6), LiveNeighbours),
  member(coord(3, 6), LiveNeighbours).

test(count_three_live_neighbours_of_dead_cell) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(4, 7), coord(3, 6), coord(5, 6)], NewWorld),
  live_neighbours(NewWorld, coord(4, 6), LiveNeighbours),
  length(LiveNeighbours, 3),
  member(coord(5, 6), LiveNeighbours),
  member(coord(4, 7), LiveNeighbours),
  member(coord(3, 6), LiveNeighbours).

test(evolve_single_cell_results_empty_world) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(4, 7)], NewWorld),
  evolve(NewWorld, EvolvedWorld),
  empty_world(EvolvedWorld).

test(evolve_2_square_is_stable) :-
  empty_world(Empty),
  world_add_cells(Empty, [coord(1, 3), coord(2, 3), coord(1, 4), coord(2, 4)], NewWorld),
  evolve(NewWorld, world(LiveCells, DeadCells)),
  length(LiveCells, 4),
  length(DeadCells, 12).

% test(evolve_tree_inline_will_rotate) :-
%   empty_world(Empty),
%   world_add_cells(Empty, [coord(4, 1), coord(4, 2), coord(4, 3)], NewWorld),
%   evolve(NewWorld, world(LiveCells, DeadCells)),
%   length(LiveCells, 3),
%   length(DeadCells, 12).

:- end_tests(gof_tests).
