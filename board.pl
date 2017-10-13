level(empty, 0).
level(n1h, 1).
level(n2h, 2).
level(n3h, 3).
level(n1p, 1).
level(n2p, 2).
level(n3p, 3).

type(empty, none).
type(n1h, hole).
type(n2h, hole).
type(n3h, hole).
type(n1p, plain).
type(n2p, plain).
type(n3p, plain).

combine(empty, Piece, Piece).
combine(n1h, n1h, n2h).
combine(n1h, n2h, n3h).
combine(n1h, n1p, n2p).
combine(n1h, n2p, n3p).
combine(n1p, n1h, n2h).
combine(n1p, n2h, n3h).
combine(n1p, n1p, n2p).
combine(n1p, n2p, n3p).


movePiece(Piece, Row, Col, Board, NewBoard) :-
				getMatrixElemAt(Row, Col, Board, CurrentPiece),
				level(CurrentPiece, CurPieceHeight),
				CurPieceHeight < 2,
				combine(CurrentPiece, Piece, NewPiece),
				setMatrixElemAtWith(Row, Col, NewPiece, Board, NewBoard).

movePiece(Piece, Row, Col, Board, Board) :-
				getMatrixElemAt(Row, Col, Board, CurrentPiece),
				level(CurrentPiece, CurPieceHeight),
				\+ CurPieceHeight < 2,
				write('nao da para jogar a peca').






% Board preset

initialBoard([
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty]]).












%%%%%%% Test Winning the game %%%%%%%%

gameWin(Board) :- getMatrixElemAt(0,0,Board, Elem1), getMatrixElemAt(0,1,Board, Elem2), getMatrixElemAt(0,2,Board, Elem3), getMatrixElemAt(0,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(1,0,Board, Elem1), getMatrixElemAt(1,1,Board, Elem2), getMatrixElemAt(1,2,Board, Elem3), getMatrixElemAt(1,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(2,0,Board, Elem1), getMatrixElemAt(0,1,Board, Elem2), getMatrixElemAt(2,2,Board, Elem3), getMatrixElemAt(2,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(3,0,Board, Elem1), getMatrixElemAt(3,1,Board, Elem2), getMatrixElemAt(3,2,Board, Elem3), getMatrixElemAt(3,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,0,Board, Elem1), getMatrixElemAt(1,0,Board, Elem2), getMatrixElemAt(2,0,Board, Elem3), getMatrixElemAt(3,0,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,1,Board, Elem1), getMatrixElemAt(1,1,Board, Elem2), getMatrixElemAt(2,1,Board, Elem3), getMatrixElemAt(3,1,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,2,Board, Elem1), getMatrixElemAt(1,2,Board, Elem2), getMatrixElemAt(2,2,Board, Elem3), getMatrixElemAt(3,2,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,3,Board, Elem1), getMatrixElemAt(1,3,Board, Elem2), getMatrixElemAt(2,3,Board, Elem3), getMatrixElemAt(3,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,0,Board, Elem1), getMatrixElemAt(1,1,Board, Elem2), getMatrixElemAt(2,2,Board, Elem3), getMatrixElemAt(3,3,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).

gameWin(Board) :- getMatrixElemAt(0,3,Board, Elem1), getMatrixElemAt(1,2,Board, Elem2), getMatrixElemAt(2,1,Board, Elem3), getMatrixElemAt(3,0,Board, Elem4),
									test4Line(Elem1, Elem2, Elem3, Elem4).




test4Line(Elem1, Elem2, Elem3, Elem4) :- level(Elem1, ElemLv),
										 level(Elem2, ElemLv),
										 level(Elem3, ElemLv),
										 level(Elem4, ElemLv),
										 ElemLv \== 0.

test4Line(Elem1, Elem2, Elem3, Elem4) :- type(Elem1, ElemType),
										 type(Elem2, ElemType),
										 type(Elem3, ElemType),
										 type(Elem4, ElemType),
										 ElemType \== none.

gameWin(Board) :- checkWinWthStairs(Board, Board, 0).

checkWinWthStairs(Board, [H|T], X) :-
							checkLineForStairs(Board, H, X, 0),
							NewX is X + 1,
							checkWinWthStairs(Board, T, NewX).
							
checkLineForStairs(Board, [H|T], X, Y) :-
										level(H, LvH),
										(LvH == 3 ->
										checkStairs(Board, X, Y, -1, -1)),
										NewY is Y + 1,
										checkLineForStairs(Board, T, X, Y).

checkStairs(Board, X, Y, VarX, VarY) :-
									VarX == 0,
									VarY == 0,
									checkStairs(Board, X, Y, 0, 1).
									
checkStairs(Board, X, Y, VarX, VarY) :-
									NewX is X + VarX,
									NewY is Y + VarY,
									\+ checkGoodPos(NewX, NewY),
									update(VarX, VarY, NewVarX, NewVarY),
									checkStairs(Board, X, Y, NewVarX, NewVarY).
									
									
checkStairs(Board, X, Y, VarX, VarY) :-
									NewX is X + VarX,
									NewY is Y + VarY,
									getMatrixElemAt(NewX, NewY, Board, Elem),
									level(Elem, ElemLv),
									(ElemLv == 2 ->
									checkForLv1(Board, X, Y, VarX, VarY)),
									update(VarX, VarY, NewVarX, NewVarY),
									checkStairs(Board, X, Y, NewVarX, NewVarY).
									
									
checkForLv1(Board, X, Y, VarX, VarY) :-
									NewX is X + VarX + VarX,
									NewY is Y + VarY + VarY,
									checkGoodPos(NewX, NewY),
									getMatrixElemAt(NewX, NewY, Board, Elem),
									level(Elem, ElemLv),
									Elem1Lv == 1 .


checkGoodPos(X, Y) :- X =< 3, X >= 0, Y =< 3, Y >= 0.	

update(1, 1, _, _) :- !, fail.
									
update(X, Y, NewX, NewY) :- (Y == 1 -> NewY is -1, NewX is X + 1;
							NewY is Y + 1, NewX is X).
									
									
									
									
									
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
									
									
									
									
startGame :- initialBoard(Board).



player1turn(Board) :-
					printBoard(Board),
					write('Player one: choose piece').




%%% Unit testing %%%


teste1 :- initialBoard(Board),
		movePiece(n2h, 0, 0, Board, Board1),
		movePiece(n2h, 0, 1, Board1, Board2),
		movePiece(n2h, 0, 2, Board2, Board3),
		movePiece(n1p, 0, 3, Board3, Board4),
		gameWin(Board4).
			
teste2 :- initialBoard(Board),
		movePiece(n2h, 0, 0, Board, Board1),
		movePiece(n2h, 0, 1, Board1, Board2),
		movePiece(n2h, 0, 2, Board2, Board3),
		gameWin(Board3).
		
teste3 :- initialBoard(Board),
		movePiece(n1h, 0, 0, Board, Board1),
		movePiece(n2h, 0, 0, Board1, Board2),
		movePiece(n2h, 0, 1, Board2, Board3),
		movePiece(n1h, 0, 2, Board3, Board4),
		gameWin(Board4).





%%%%%%%%% Print Board %%%%%%%%%%%



print :- initialBoard(Board), movePiece(n2h, 1, 1, Board, NewBoard),
			movePiece(n2p, 0, 1, NewBoard, NewBoard1),
			movePiece(n1h, 2, 2, NewBoard1, NewBoard2),
			movePiece(n1h, 3, 1, NewBoard2, NewBoard3),
			movePiece(n2p, 3, 1, NewBoard3, NewBoard4),
			movePiece(n1p, 3, 3, NewBoard4, NewBoard5),
			movePiece(n2h, 1, 2, NewBoard5, NewBoard6),printBoard(NewBoard6).



printBoard(Board) :- write('            '), put_code(201),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(203),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(203),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(203),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(187), nl,
					write('            '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), nl,
					write('     y'), put_code(92), write('x    '), put_code(186), write('     0     '), put_code(186), write('     1     '), put_code(186), write('     2     '), put_code(186), write('     3     '), put_code(186), nl,
					write('            '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), nl,
					put_code(201),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(185), nl,
					getListElemAt(0, Board, Array0),
					printLine(0, Array0, 0), nl,
					put_code(204),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(185), nl,
					getListElemAt(1, Board, Array1),
					printLine(0, Array1, 1), nl,
					put_code(204),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(185), nl,
					getListElemAt(2, Board, Array2),
					printLine(0, Array2, 2), nl,
					put_code(204),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(206),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(185), nl,
					getListElemAt(3, Board, Array3),
					printLine(0, Array3, 3), nl,
					put_code(200),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(202),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(202),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(202),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(202),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(188).


printLine(Line, Array, Value) :- Line == 0,
								printLine(1, Array, Value).

printLine(Line, Array, Value) :-
					Line == 1,
					put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), nl,
					printLine(2, Array, Value).

printLine(Line, Array, Value) :-
					Line == 2,
					getListElemAt(0, Array, Elem1),
					getListElemAt(1, Array, Elem2),
					getListElemAt(2, Array, Elem3),
					getListElemAt(3, Array, Elem4),
					put_code(186), write('           '),put_code(186), printCelTop(Elem1), put_code(186), printCelTop(Elem2), put_code(186), printCelTop(Elem3), put_code(186), printCelTop(Elem4), put_code(186), nl,
					printLine(3,Array, Value).

printLine(Line, Array, Value) :-
					Line == 3,
					getListElemAt(0, Array, Elem1),
					getListElemAt(1, Array, Elem2),
					getListElemAt(2, Array, Elem3),
					getListElemAt(3, Array, Elem4),
					put_code(186), write('     '), write(Value), write('     '),put_code(186), printCelInt(Elem1), put_code(186), printCelInt(Elem2), put_code(186), printCelInt(Elem3), put_code(186), printCelInt(Elem4), put_code(186), nl,
					printLine(4,Array).

printLine(Line, Array) :-
					Line == 4,
					getListElemAt(0, Array, Elem1),
					getListElemAt(1, Array, Elem2),
					getListElemAt(2, Array, Elem3),
					getListElemAt(3, Array, Elem4),
					put_code(186), write('           '),put_code(186), printCelBot(Elem1), put_code(186), printCelBot(Elem2), put_code(186), printCelBot(Elem3), put_code(186), printCelBot(Elem4), put_code(186), nl,
					printLine(5,Array).

printLine(Line, Array) :-
					Line == 5,
					getListElemAt(0, Array, Elem1),
					getListElemAt(1, Array, Elem2),
					getListElemAt(2, Array, Elem3),
					getListElemAt(3, Array, Elem4),
					put_code(186), write('           '),put_code(186), write(' '), level(Elem1, Elem1Lv), write(Elem1Lv), write('         '), put_code(186), write(' '), level(Elem2, Elem2Lv), write(Elem2Lv), write('         '), put_code(186), write(' '), level(Elem3, Elem3Lv), write(Elem3Lv), write('         '), put_code(186), write(' '), level(Elem4, Elem4Lv), write(Elem4Lv), write('         '), put_code(186).


printCelTop(Elem) :- Elem == empty,
					write('           ').

printCelTop(Elem) :- Elem \== empty,
					write('   '), put_code(218), put_code(196), put_code(196), put_code(196), put_code(191), write('   ').

printCelBot(Elem) :- Elem == empty,
					write('           ').

printCelBot(Elem) :- Elem \== empty,
					write('   '), put_code(192), put_code(196), put_code(196), put_code(196), put_code(217), write('   ').

printCelInt(Elem) :- Elem == empty,
					write('           ').

printCelInt(Elem) :- Elem \== empty,
					type(Elem, ElemType),
					ElemType == hole,
					write('   '), put_code(179), write(' O '), put_code(179), write('   ').

printCelInt(Elem) :- Elem \== empty,
					type(Elem, ElemType),
					ElemType == plain,
					write('   '), put_code(179), write('   '), put_code(179), write('   ').
