
printBoard(Board) :-
  length(Board, Size),
  put_code(9556), 
  printTopDivision(Size),
  printLines(Board, Size).


printLines([LastLine], Size) :-
  put_code(9553),
  printLine(LastLine),
  put_code(9562),
  printBottomDivision(Size).
printLines([Line | Board], Size):-
  put_code(9553),
  printLine(Line),
  put_code(9568),
  printDivision(Size),
  printLines(Board, Size).

printLine([]):- nl.
printLine([Elem | Line]) :-
  write(' '),
  write(Elem),
  write(' '),
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