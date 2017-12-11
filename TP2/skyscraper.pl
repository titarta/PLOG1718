:- use_module(library(clpfd)).
:- use_module(library(lists)).

getLine(Line, Number) :-
  length(Line, Length),
  domain(Line, 1, Length),
  all_distinct(Line),
  getLineAux(Line, Number, 0).

getLineAux([H | T], Length, Number, Max) :-
  (H #> Max #/\
  NewMax #= H #/\
  NewNumber #= Number - 1) #\
  (H #< Max #/\
  NewMax #= Max #/\
  NewNumber #= Number),
  getLineAux(T, Length, NewNumber, NewMax).

getLineAux([], Length, 0, Length).


getLines([], [], []).
getLines([Line | TL], [NumberFront | TF], [NumberBack | TB]) :-
  getLine(Line, NumberFront),
  reverse(Line, LineReversed),
  getLine(LineReversed, NumberBack),
  getLines(TL, TF, TB).


skyscraper([Left, Right, Up, Down], Solution) :-
  same_length(Solution, Left),
  maplist(same_length(Up), Solution),
  append(Solution, SolutionNumbers),  
  getLines(Solution, Left, Right),
  transpose(Solution, TransposedSolution),
  getLines(TransposedSolution, Up, Down),
  labeling([], SolutionNumbers).
  