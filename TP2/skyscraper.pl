:- use_module(library(clpfd)).
:- use_module(library(lists)).

:- include('generate.pl').
:- include('print.pl').

getLine(Line, Number) :-
  all_distinct(Line),
  getLineDisjunctionNew(Line, Number, 0).
  %reverse(Line, LineReversed),
  %getLineReification(LineReversed, Number).

getLineDisjunctionNew([], 0, _).
getLineDisjunctionNew([H | T], Number, Max) :-
  H #> Max #<=> S,
  NewNumber #= Number - S,
  maximum(NewMax, [H, Max]),
  getLineDisjunctionNew(T, NewNumber, NewMax).

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
  ViewList = [
    [_, 2, 3, 4, _, _], 
    [_, _, 4, 3, 2, _], 
    [5, _, _, 2, 2, _], 
    [_, 3, 4, _, _, 4]
  ],
  skyscraper(ViewList, Solution),
  printBoard(ViewList, Solution).

test2 :-
  ViewList = [
    [3, 3, _, 3, _, 3, _, _], 
    [_, _, 2, _, 4, 4, _, 1],
    [_, _, 5, 3, _, 2, _, 4],
    [2, 4, _, _, 4, _, _, _]
  ],
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
  skyscraper(ViewList, Solution),
  printBoard(ViewList, Solution).

generate1(Size) :-
  boardGeneration(Size, ViewList),
  maplist(portray_clause, ViewList), nl,
  skyscraper(ViewList, Solution),
  printBoard(ViewList, Solution).