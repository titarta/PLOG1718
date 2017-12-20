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
  labeling([value(randomLabeling)], Vs).

randomLabeling(Var, _Rest, BB, BB1) :-
  fd_set(Var, Set),
  randomSelector(Set, Value),
  (   
    first_bound(BB, BB1), Var #= Value
    ;   
    later_bound(BB, BB1), Var #\= Value
  ).

randomSelector(Set, BestValue):-
  fdset_to_list(Set, List),
  length(List, Len),
  random(0, Len, RandomIndex),
  nth0(RandomIndex, List, BestValue).

seesRight([], 0, _).

seesRight([Elem | Array], Value, BiggestValue) :- 
  Elem > BiggestValue,
  seesRight(Array, NewValue, Elem),
  Value is NewValue + 1.

seesRight([_ | Array], Value, BiggestValue) :-
  seesRight(Array, Value, BiggestValue).

chooseLines(Size, Values) :-
  ExactHalf is Size / 2,
  Half is round(ExactHalf),
  length(Values, Half),
  domain(Values, 1, Size),
  all_distinct(Values),
  labeling([value(randomLabeling)], Values).

getArray(Size, Board, Array) :-
  chooseLines(Size, Positions),
  getArrayAux(Positions, Board, Array, 1).

getArrayAux(_, [], [], _).

getArrayAux(Positions, [HBoard | TBoard], Array, Position) :-
  member(Position, Positions),
  seesRight(HBoard, Value, 0),
  NewPosition is Position + 1,
  getArrayAux(Positions, TBoard, NewArray, NewPosition),
  append([Value], NewArray, Array).

getArrayAux(Positions, [_ | TBoard], Array, Position) :-
  NewPosition is Position + 1,
  getArrayAux(Positions, TBoard, NewArray, NewPosition),
  append([_], NewArray, Array).

problemGeneration(Size, ViewList) :-
  generateBoard(Size, BoardLeft),
  getArray(Size, BoardLeft, Left),
  transpose(BoardLeft, BoardUp),
  getArray(Size, BoardUp, Up),
  reverse(BoardUp, BoardRightAux),
  transpose(BoardRightAux, BoardRight),
  getArray(Size, BoardRight, Right),
  reverse(BoardRight, BoardDownAux1),
  transpose(BoardDownAux1, BoardDownAux2),
  reverse(BoardDownAux2, BoardDown),
  getArray(Size, BoardDown, Down),
  ViewList = [Left, Right, Up, Down].




  
