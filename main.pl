:- load_files(gof).

main(_) :- 
  game_of_life([cell(4, 1), cell(4, 2), cell(4, 3)], world_window(3, 1, 3, 3)).
