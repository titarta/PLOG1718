:- use_module(library(clpfd)).
:- use_module(library(lists)).

getLine(Line, Number) :-
  length(Line, Length),
  domain(Line, 1, Length),
  all_distinct(Line),
  visualize_signature(Line, Number).

getLineAux([H | T], Length, Number, Max) :-
  (H #> Max #/\
  NewMax #= H #/\
  NewNumber #= Number - 1) #\/
  (H #< Max #/\
  NewMax #= Max #/\
  NewNumber #= Number),
  getLineAux(T, Length, NewNumber, NewMax).

getLineAux([], Length, 0, Length).


getLines([], [], []).
getLines([Line | TL], [NumberFront | TF], [NumberBack | TB]) :-
  getLine(Line, NumberBack),
  reverse(Line, LineReversed),
  getLine(LineReversed, NumberFront),
  getLines(TL, TF, TB).


skyscraper([Left, Right, Up, Down], Solution) :-
  statistics(walltime, [T0 | _]),
  same_length(Solution, Left),
  maplist(same_length(Up), Solution),
  append(Solution, SolutionNumbers),  
  getLines(Solution, Left, Right),
  transpose(Solution, TransposedSolution),
  getLines(TransposedSolution, Up, Down),
  statistics(walltime, [T1 | _]),
  labeling([leftmost, bisect, up], SolutionNumbers),
  statistics(walltime, [T2 | _]),
  Time1 is T1 - T0,
  Time2 is T2 - T1,
  write('C: '), write(Time1), nl,
  write('L: '), write(Time2), nl.
  
test1 :-
  skyscraper(
    [
      [_, 2, 3, 4, _, _], 
      [_, _, 4, 3, 2, _], 
      [5, _, _, 2, 2, _], 
      [_, 3, 4, _, _, 4]
    ], 
  Solution),
  maplist(portray_clause, Solution).


visualize_signature([],0).
visualize_signature([H | T], Value) :-
S in 0..1,
maximum(A,[H | T]),
H #= A #<=> S,
visualize_signature(T, NewValue),
Value #= NewValue + S.