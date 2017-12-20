
printBoard([Left, Right, Up, Down], Board) :-
  length(Board, Size),

  nl,

  printBlank(5),
  printArrayLine(Up),
  nl,

  printBlank(4),
  put_code(9556),
  printTopDivision(Size),

  printLines(Board, Size, Left, Right),
  
  printBlank(5),
  printArrayLine(Down),
  nl.

printLines([LastLine], Size, [Last1], [Last2]) :-
  printLeftElem(Last1),
  printLine(LastLine),
  printRightElem(Last2),
  nl,
  printBlank(4),
  put_code(9562),
  printBottomDivision(Size).

printLines([Line | Board], Size, [H1 | T1], [H2 | T2]):-
  printLeftElem(H1),
  printLine(Line),
  printRightElem(H2),
  nl,

  printBlank(4),
  put_code(9568),
  
  printDivision(Size),
  printLines(Board, Size, T1, T2).

printLine([]).
printLine([Elem | Line]) :-
  nonvar(Elem),
  printBlank(1),
  write(Elem),
  printBlank(1),
  put_code(9553),
  printLine(Line).

printLine([_ | Line]) :-
  printBlank(1),
  write('_'),
  printBlank(1),
  put_code(9553),
  printLine(Line).

printTopDivision(1):-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9559),
  nl.

printTopDivision(Size) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9574),
  NewSize is Size - 1,
  printTopDivision(NewSize).

printDivision(1):-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9571),
  nl.

printDivision(Size) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9580),
  NewSize is Size - 1,
  printDivision(NewSize).

printBottomDivision(1):-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9565),
  nl.

printBottomDivision(Size) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9577),
  NewSize is Size - 1,
  printBottomDivision(NewSize).

printBlank(0):- !.

printBlank(Num) :-
  write(' '),
  NewNum is Num - 1,
  printBlank(NewNum).

printLeftElem(Elem):-
  nonvar(Elem),
  printBlank(2),
  write(Elem),
  printBlank(1),
  put_code(9553).

printLeftElem(_):-
  printBlank(2),
  write('_'),
  printBlank(1),
  put_code(9553).

printRightElem(Elem):-
  nonvar(Elem),
  printBlank(1),
  write(Elem),
  printBlank(2).

printRightElem(_):-
  printBlank(1),
  write('_'),
  printBlank(2).

printSecTopDivision(-1) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9559),
  nl.

printSecTopDivision(Size) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9580),
  NewSize is Size - 1,
  printSecTopDivision(NewSize).

printSecBotDivision(-1) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9565),
  nl.

printSecBotDivision(Size) :-
  put_code(9552),
  put_code(9552),
  put_code(9552),
  put_code(9580),
  NewSize is Size - 1,
  printSecBotDivision(NewSize).

printArrayLine([]).

printArrayLine([Elem | Line]) :-
  nonvar(Elem),
  printBlank(1),
  write(Elem),
  printBlank(2),
  printArrayLine(Line).

printArrayLine([_ | Line]) :-
  printBlank(1),
  write('_'),
  printBlank(2),
  printArrayLine(Line).