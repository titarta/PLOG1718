:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

generateBoard(Size, ViewList) :-
  length(ViewList, Size),
  maplist(same_length(ViewList), ViewList),
  append(ViewList, Vs), domain(Vs, 1, Size),
  maplist(all_distinct, ViewList),
  transpose(ViewList, Columns),
  maplist(all_distinct, Columns),
  labeling([value(mySelValores)], Vs).

mySelValores(Var, _Rest, BB, BB1) :-
  fd_set(Var, Set),
  select_best_value(Set, Value),
  (   
    first_bound(BB, BB1), Var #= Value
    ;   
    later_bound(BB, BB1), Var #\= Value
  ).

select_best_value(Set, BestValue):-
  fdset_to_list(Set, Lista),
  length(Lista, Len),
  random(0, Len, RandomIndex),
  nth0(RandomIndex, Lista, BestValue).

seesRight([], 0, _).

seesRight([Elem | Array], Value, BiggestValue) :- 
  Elem > BiggestValue,
  seesRight(Array, NewValue, Elem),
  Value is NewValue + 1.

seesRight([_|Array], Value, BiggestValue) :-
  seesRight(Array, Value, BiggestValue).

getnvalues(Size, Values) :-
  NewSize is Size / 2,
  Size2 is round(NewSize),
  length(Values, Size2),
  domain(Values, 1, Size),
  all_distinct(Values),
  labeling([value(mySelValores)], Values).

getArray(Size, Game, Array) :-
  getnvalues(Size, Positions),
  getArrayAux(Positions, Game, Array, 1).

getArrayAux(_, [], [], _).

getArrayAux(Positions, [Hgame | Tgame], Array, Position) :-
  member(Position, Positions),
  seesRight(Hgame, Value, 0),
  NewPosition is Position + 1,
  getArrayAux(Positions, Tgame, NewArray, NewPosition),
  append([Value], NewArray, Array).

getArrayAux(Positions, [_ | Tgame], Array, Position) :-
  NewPosition is Position + 1,
  getArrayAux(Positions, Tgame, NewArray, NewPosition),
  append([_], NewArray, Array).

boardGeneration(Size, ViewList) :-
  generateBoard(Size, Game),
  getArray(Size, Game, Left),
  transpose(Game, Game3),
  getArray(Size, Game3, Up),
  reverse(Game3, Game2aux),
  transpose(Game2aux, Game2),
  getArray(Size, Game2, Right),
  reverse(Game2, Game4aux1),
  transpose(Game4aux1, Game4aux2),
  reverse(Game4aux2, Game4),
  getArray(Size, Game4, Down),
  ViewList = [Left, Right, Up, Down].




  
