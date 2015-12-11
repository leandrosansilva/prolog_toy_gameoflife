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

test(cell_north) :-
  north(cell(0, 0), cell(0, -1)),
  north(cell(0, -1), cell(0, -2)),
  north(cell(1, 0), cell(1, -1)).

test(cell_south) :-
  south(cell(0, 0), cell(0, 1)),
  south(cell(0, -1), cell(0, 0)),
  south(cell(1, 0), cell(1, 1)).

test(cell_west) :-
  west(cell(0, 0), cell(-1, 0)),
  west(cell(1, 0), cell(0, 0)),
  west(cell(1, 1), cell(0, 1)).

test(cell_east) :-
  east(cell(0, 0), cell(1, 0)),
  east(cell(-1, 0), cell(0, 0)),
  east(cell(-1, 1), cell(0, 1)).

test(cell_south_east) :-
  south_east(cell(0, 0), cell(1, 1)),
  south_east(cell(1, 1), cell(2, 2)).

test(cell_south_west) :-
  south_west(cell(0, 0), cell(-1, 1)),
  south_west(cell(1, 1), cell(0, 2)).

test(cell_north_west) :-
  north_west(cell(0, 0), cell(-1, -1)),
  north_west(cell(1, 1), cell(0, 0)).

test(cell_north_east) :-
  north_east(cell(0, 0), cell(1, -1)),
  north_east(cell(1, 1), cell(2, 0)).

test(cell_neighbours) :-
  neighbours(cell(0, 0), Neighbours),
  length(Neighbours, 8),
  member(cell(-1, -1), Neighbours),
  member(cell(0, -1), Neighbours),
  member(cell(1, -1), Neighbours),
  member(cell(1, 0), Neighbours),
  member(cell(1, 1), Neighbours),
  member(cell(0, 1), Neighbours),
  member(cell(-1, 1) ,Neighbours),
  member(cell(-1, 0), Neighbours).

test(add_cell_to_world) :-
  empty_world(Empty),
  world_add_cell(Empty, cell(0, 0), world(LiveCells, DeadCells)),
  member(cell(0, 0), LiveCells),
  length(LiveCells, 1),
  length(DeadCells, 8),
  member(cell(-1, -1), DeadCells),
  member(cell(0, -1), DeadCells),
  member(cell(1, -1), DeadCells),
  member(cell(1, 0), DeadCells),
  member(cell(1, 1), DeadCells),
  member(cell(0, 1), DeadCells),
  member(cell(-1, 1), DeadCells),
  member(cell(-1, 0), DeadCells).

test(add_two_distant_cells) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(3, 6), cell(7, 10)], world(LiveAfter2ndInsertion, DeadAfter2ndInsertion)),
  member(cell(3, 6), LiveAfter2ndInsertion),
  member(cell(7, 10), LiveAfter2ndInsertion),
  length(LiveAfter2ndInsertion, 2),
  length(DeadAfter2ndInsertion, 16).

test(add_multiple_cells) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 7), cell(3, 6)], world(LiveAfter2ndInsertion, DeadAfter2ndInsertion)),
  member(cell(3, 6), LiveAfter2ndInsertion),
  member(cell(4, 7), LiveAfter2ndInsertion),
  length(LiveAfter2ndInsertion, 2),
  length(DeadAfter2ndInsertion, 12).

test(count_two_live_neighbours_of_live_cell) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 7), cell(3, 6), cell(5, 6)], NewWorld),
  live_neighbours(NewWorld, cell(4, 7), LiveNeighbours),
  length(LiveNeighbours, 2),
  member(cell(5, 6), LiveNeighbours),
  member(cell(3, 6), LiveNeighbours).

test(count_three_live_neighbours_of_dead_cell) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 7), cell(3, 6), cell(5, 6)], NewWorld),
  live_neighbours(NewWorld, cell(4, 6), LiveNeighbours),
  length(LiveNeighbours, 3),
  member(cell(5, 6), LiveNeighbours),
  member(cell(4, 7), LiveNeighbours),
  member(cell(3, 6), LiveNeighbours).

test(evolve_single_cell_results_empty_world) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 7)], NewWorld),
  evolve(NewWorld, EvolvedWorld),
  empty_world(EvolvedWorld).

test(evolve_2_square_is_stable) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(1, 3), cell(2, 3), cell(1, 4), cell(2, 4)], NewWorld),
  evolve(NewWorld, world(LiveCells, DeadCells)),
  length(LiveCells, 4),
  length(DeadCells, 12).

test(evolve_tree_inline_will_rotate) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 1), cell(4, 2), cell(4, 3)], NewWorld),
  evolve(NewWorld, world(LiveCells, DeadCells)),
  length(LiveCells, 3),
  length(DeadCells, 12).

test(prints_world_one_char) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 1), cell(4, 2), cell(4, 3)], NewWorld),
  world_to_string(NewWorld, world_window(3, 1, 1, 1), S), !, S = " \n".

test(prints_world_two_chars) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 1), cell(4, 2), cell(4, 3)], NewWorld),
  world_to_string(NewWorld, world_window(3, 1, 1, 2), S), !, S = " 0\n".

test(prints_world_three_chars) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 1), cell(4, 2), cell(4, 3)], NewWorld),
  evolve(NewWorld, EvolveWorld),
  world_to_string(EvolveWorld, world_window(3, 2, 1, 3), S), !, S = "000\n".

test(prints_9x9_window) :-
  empty_world(Empty),
  world_add_cells(Empty, [cell(4, 1), cell(4, 2), cell(4, 3)], NewWorld),
  world_to_string(NewWorld, world_window(3, 1, 3, 3), S), !, S = " 0 \n 0 \n 0 \n".

:- end_tests(gof_tests).
