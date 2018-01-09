:- use_module(library(clpfd)).
:- use_module(library(lists)).

:- include('generate.pl').
:- include('print.pl').
:- include('test.pl').

getLine(Line, Number) :-
  %all_distinct(Line),
  getLineSimpleReification(Line, Number, 0).
  %reverse(Line, LineReversed),
  %getLineReification(LineReversed, Number).

getLineSimpleReification([], 0, _).
getLineSimpleReification([H | T], Number, Max) :-
  H #> Max #<=> S,
  NewNumber #= Number - S,
  maximum(NewMax, [H, Max]),
  getLineSimpleReification(T, NewNumber, NewMax).

getLineDisjunction([], 0, _).
getLineDisjunction([H | T], Number, Max) :-
  (H #> Max #/\
  NewMax #= H #/\
  NewNumber #= Number - 1) #\/
  (H #< Max #/\
  NewMax #= Max #/\
  NewNumber #= Number),
  getLineDisjunction(T, NewNumber, NewMax).

getLineReification([], 0).

getLineReification([H | T], Value) :-
  getLineReification(T, NewValue),
  maximum(A, [H | T]),
  H #= A #<=> S,
  Value #= NewValue + S.

getLines([], [], []).

getLines([Line | TL], [NumberFront | TF], [NumberBack | TB]) :-
  getLine(Line, NumberFront),
  reverse(Line, LineReversed),
  getLine(LineReversed, NumberBack),
  getLines(TL, TF, TB).

skyscraper([Left, Right, Up, Down], Solution) :-
  statistics(walltime, [T0 | _]),
  length(Left, Length),
  length(Right, Length),
  length(Up, Length),
  length(Down, Length),
  length(Solution, Length),
  maplist(same_length(Solution), Solution),
  maplist(all_distinct, Solution),
  append(Solution, FlatSolution),  
  domain(FlatSolution, 1, Length),
  getLines(Solution, Left, Right),
  transpose(Solution, TransposedSolution),
  maplist(all_distinct, TransposedSolution),
  getLines(TransposedSolution, Up, Down),
  statistics(walltime, [T1 | _]),
  labeling([max, bisect, up], FlatSolution),
  statistics(walltime, [T2 | _]),
  Time1 is T1 - T0,
  Time2 is T2 - T1,
  write('C: '), write(Time1), nl,
  write('L: '), write(Time2), nl.