:- use_module(library(clpfd)).



getLine([A,B,C,D,E,F], Value1, Value2) :-
domain([A,B,C,D,E,F], 1, 6),
all_different([A,B,C,D,E,F]),

labeling([], [A,B,C,D,E,F]),
it(Value1 \= 0, seesRight([A,B,C,D,E,F], Value1, 0)),
it(Value2 \= 0, seesRight([F,E,D,C,B,A], Value2, 0)).



seesRight([], Value, _) :-!,
  Value == 0.

seesRight([Elem|Array], Value, BiggestValue) :- 
  once(Elem > BiggestValue),
  NewValue is Value - 1,!,
  seesRight(Array, NewValue, Elem).

seesRight([Elem|Array], Value, BiggestValue) :-
  seesRight(Array, Value, BiggestValue).




obtainSolution([_, Array1, Array2, Array3, Array4], Solution) :-
  length(Solution, 6),
  getLines(Solution, Array1, Array2),
  getLines(Solution, Array3, Array4).

getLines([],[],[]).
getLines([H|T], [Elem1|T1], [Elem2|T2]) :-
  getLine(H, Elem1, Elem2),
  getLines(T, T1, T2).



it(If, Then):- If, !, Then.
it(_,_).
