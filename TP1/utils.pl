printMatrix([], _).
printMatrix([Line | Tail], Separator):-
  printList(Line, Separator), nl, nl,
  printMatrix(Tail, Separator).

printList([], _).
printList([Head | Tail], Separator):-
  write(Head), write(Separator),
  printList(Tail, Separator).

printMatrix([]).
printMatrix([Line | Tail]):-
  printList(Line), nl,
  printMatrix(Tail).

printList([]).
printList([Head | Tail]):-
  write(Head),
  printList(Tail).

%%% 1. element row; 2. element column; 3. matrix; 4. query element.
getMatrixElemAt(0, ElemCol, [ListAtTheHead|_], Elem):-
  getListElemAt(ElemCol, ListAtTheHead, Elem).
getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
  ElemRow > 0,
  ElemRow1 is ElemRow-1,
  getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).

%%% 1. element position; 2. list; 3. query element.
getListElemAt(0, [ElemAtTheHead|_], ElemAtTheHead).
getListElemAt(Pos, [_|RemainingElems], Elem):-
  Pos > 0,
  Pos1 is Pos-1,
  getListElemAt(Pos1, RemainingElems, Elem).

setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
  ElemRow > 0,
  ElemRow1 is ElemRow-1,
  setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

%%% 1. position; 2. element to use on replacement; 3. current list; 4. resultant list.

setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
  I > 0,
  I1 is I-1,
  setListElemAtWith(I1, Elem, L, ResL).

not(X) :- X, !, fail.
not(_).

ite(If, Then, _):- If, !, Then.
ite(_, _, Else):- Else.

it(If, Then):- If, !, Then.
it(_,_).

ie(If, _):- If.
ie(_, Else) :- Else.

askInteger(Prompt, Min, Max, Option) :-
  write(Prompt),
  read(Value),
  integer(Value),
  Value >= Min,
  Value =< Max,
  Option = Value.

askInteger(Prompt, Min, Max, Option) :-
  nl, write('Wrong input. Try again.'), nl, nl,
  askInteger(Prompt, Min, Max, Option).

filter(Pred, [], []) :- !.

filter(Pred, [ListElem|List], [ListElem|Elems]) :-
  aplica(Pred, [ListElem]),
  filter(Pred, List, Elems).

filter(Pred, [L|H] , NewL) :-
  filter(Pred, H, NewL).

aplica(P, LArgs) :- G =.. [P|LArgs], G.


len([], LenResult):-
  LenResult is 0.

len([X|Y], LenResult):-
  len(Y, L),
  LenResult is L + 1.


sum_list([], 0).
sum_list([H|T], Sum) :-
  sum_list(T, Rest),
  Sum is H + Rest.
  
toInt(Value, IntValue) :-
  IntValue is round(Value).
