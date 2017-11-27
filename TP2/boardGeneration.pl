:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).


generateArrayNumbers(Array) :-
  NewArray = [0, 0, 0, 0, 0, 0],
  add3(NewArray, Array, 0).

add3(Array, Array2, 3) :- Array2 = Array.
add3(Array, Array2, Value) :-
  repeat,
  random(0, 5, Rpos),
  PosAux is Rpos + 1,
  nth1(PosAux, Array, 0),
  random(1, 6, Rvalue),
  setListElemAtWith(Rpos, Rvalue, Array, NewArray),
  NewValue is Value + 1,
  once(add3(NewArray, Array2, NewValue)).


setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
  I > 0,
  I1 is I-1,
  setListElemAtWith(I1, Elem, L, ResL).


test2Arrays([],[]).
test2Arrays([Array1Elem|Array1], [Array2Elem|Array2]) :-
  Sum is Array1Elem + Array2Elem,
  Sum =< 7,
  it(Sum =< 2, (Array1Elem == 0; Array2Elem == 0)),
  test2Arrays(Array1, Array2), !.

create2Arrays(Array1, Array2) :-
  generateArrayNumbers(ArrayAux1),
  generateArrayNumbers(ArrayAux2),
  test2Arrays(ArrayAux1, ArrayAux2),
  Array1 = ArrayAux1,
  Array2 = ArrayAux2.

generateBoard(Board) :-
  initialBoard(EmptyBoard),
  create2Arrays(Array1, Array2),
  append([EmptyBoard], [Array1, Array2], BoardWth2Lines),
  create2Arrays(Array3, Array4),
  append(BoardWth2Lines, [Array3, Array4], Board).


initialBoard([[e,e,e,e,e,e],
              [e,e,e,e,e,e],
              [e,e,e,e,e,e],
              [e,e,e,e,e,e],
              [e,e,e,e,e,e],
              [e,e,e,e,e,e]]).




it(If, Then):- If, !, Then.
it(_,_).