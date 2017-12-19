:- use_module(library(clpfd)).
:- use_module(library(lists)).

:- include('boardGeneration.pl').

getLine(Line, Number) :-
  all_distinct(Line),
  getLineDisjunction(Line, Number, 0).
  % reverse(Line, LineReversed),
  % getLineReification(LineReversed, Number).

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

waitUntilMax(_, [], _).

waitUntilMax(Size, [H | T], Number) :-
  H #= Size #<=> (T #= [], getLineReification([H | T], Number)),
  waitUntilMax(Size, T, Number).

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
  append(Solution, FlatSolution),  
  domain(FlatSolution, 1, Length),
  getLines(Solution, Left, Right),
  transpose(Solution, TransposedSolution),
  getLines(TransposedSolution, Up, Down),
  statistics(walltime, [T1 | _]),
  labeling([max, bisect, up], FlatSolution),
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

test2 :-
  Solution = [
    [_, _, _, 3, _, _, _, _],
    [_, _, _, _, _, _, 8, 2],
    [_, _, _, 5, _, _, _, _],
    [2, _, _, _, _, _, _, _],
    [_, _, 3, _, _, _, _, _],
    [1, _, 5, _, _, _, _, _],
    [_, _, _, 6, _, 2, _, _],
    [_, _, _, _, _, _, _, _]
  ],
  skyscraper(
  [
    [3, 3, _, 3, _, 3, _, _], 
    [_, _, 2, _, 4, 4, _, 1],
    [_, _, 5, 3, _, 2, _, 4],
    [2, 4, _, _, 4, _, _, _]
  ], 
  Solution),
  maplist(portray_clause, Solution).

generate1(Size) :-
  boardGeneration(Size, Board),
  maplist(portray_clause, Board), nl,
  skyscraper(Board, Solution),
  maplist(portray_clause, Solution).