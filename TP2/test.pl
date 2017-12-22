test1 :-
  ViewLists = [
    [_, 2, 3, 4, _, _], 
    [_, _, 4, 3, 2, _], 
    [5, _, _, 2, 2, _], 
    [_, 3, 4, _, _, 4]
  ],
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).

test2 :-
  ViewLists = [
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
  printBoard(ViewLists, Solution),nl,
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).

test3 :-
 ViewLists = [
    [3, 3, _, 3, _, 3, _], 
    [_, _, 2, _, 4, 4, _],
    [_, _, 5, 3, _, 2, 5],
    [2, 5, _, _, 4, _, 4]
  ],
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).

test4 :-
  ViewLists = [
    [4, 1, _, _, 4, _, 2], 
    [1, _, _, 3, 3, _, 2],
    [2, 3, 2, _, _, _, 1],
    [3, _, 4, 3, 2, _, _]
  ],
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).

test5 :-
  ViewLists = [
    [_, 1, 2, _, 4, _, _, 2], 
    [_, _, 1, _, 3, _, 4, 3],
    [_, _, 3, _, 1, 4, 3, _],
    [_, 1, _, 3, 4, _, _, 3]
  ],
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).
  
 test6 :-
	ViewList = [
	[2, _, _, 2, 5, _, 3, _],
	[_, 2, 2, 3, _, _, _, 3],
	[2, 2, _, _, _, _, 2, 1],
	[2, _, 3, _, 2, 3, _, _]],
	skyscraper(ViewList, Solution),
	printBoard(ViewList, Solution).

test7 :-
  ViewLists = [
    [2, 4, 3, 2, 2,1,3,4,3],
    [2,2,3,4,3,4,1,2,4],
    [2,3,2,2,5,3,1,5,3],
    [3,3,3,4,1,4,2,2,2]
  ],
  Solution = [
    [_,5,_,_,_,_,_,2,3],
    [_,3,_,_,_,_,_,5,_],
    [_,_,_,_,4,_,_,_,_],
    [4,_,_,1,8,_,7,_,5],
    [_,1,_,5,_,_,_,6,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,1,_,_,5,_,_,_],
    [3,_,_,4,_,_,2,_,1],
    [_,_,_,_,_,_,_,_,_]
  ],
  skyscraper(ViewLists, Solution),
	printBoard(ViewLists, Solution).


generate(Size) :-
  problemGeneration(Size, ViewLists),
  length(Solution, Size),
  maplist(same_length(Solution), Solution),
  printBoard(ViewLists, Solution),nl,
  skyscraper(ViewLists, Solution),
  printBoard(ViewLists, Solution).