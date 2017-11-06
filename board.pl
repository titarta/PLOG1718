:- use_module(library(lists)).
:- use_module(library(random)).
:- include('utils.pl').
:- include('ai.pl').
:- include('unitTesting.pl').


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


movePiece(Piece, Row, Col, [Board|PiecesStock], [NewBoard|NewPiecesStock]) :-
				playablePiece(Piece),
				coord(Row),
				coord(Col),
				getMatrixElemAt(Row, Col, Board, CurrentPiece),
				level(CurrentPiece, CurPieceHeight),
				CurPieceHeight < 2,
				checkStock(Piece, PiecesStock),
				updateStock(Piece, PiecesStock, NewPiecesStock),
				combine(CurrentPiece, Piece, NewPiece),
				setMatrixElemAtWith(Row, Col, NewPiece, Board, NewBoard).

movePiece(_, _, _, Board, Board) :- fail.






% Board preset

initialBoard([
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty]]).

initialGame(Game) :- initialBoard(Board),
					Game = [Board, 8, 8, 8].









%%%%%%% Test Winning the game %%%%%%%%

gameWin(Board) :- checkWinWthRows(Board).
gameWin(Board) :- transpose(Board, Tboard), checkWinWthRows(Tboard).
gameWin(Board) :- checkWinWthDiagonal(Board).
gameWin(Board) :- reverse(Board, Rboard), checkWinWthDiagonal(Rboard).
gameWin(Board) :- checkWinWthStairs(Board, Board, 0).


checkWinWthRows([]) :- fail.
checkWinWthRows([H|T]) :- testLine(H); checkWinWthRows(T).

testLine(List) :- testLevel(List); testType(List).
testLevel([_]).
testLevel([A,B|T]) :- level(A, ElemLv),
					   level(B, ElemLv),
					   ElemLv \= 0,
					   testLevel([B|T]).
testType([_]).
testType([A,B|T]) :- type(A, ElemType),
					   type(B, ElemType),
					   ElemType \= none,
					   testType([B|T]).



checkWinWthDiagonal(Board) :- getBoardDiagonal(Board, 0, Diagonal),
															testLine(Diagonal).

getBoardDiagonal([],_,[]).
getBoardDiagonal([F|T],Num, [E|Diagonal]) :- getListElemAt(Num, F, Elem),
											E = Elem,
											getBoardDiagonal(T, Num + 1, Diagonal).


checkWinWthStairs(_,[],_) :-!, fail.
checkWinWthStairs(Board, [H|T], Y) :-
							checkLineForStairs(Board, H, Y, 0);
							NewY is Y + 1,
							checkWinWthStairs(Board, T, NewY).

checkLineForStairs(_, [], _, _) :- fail.
checkLineForStairs(Board, [H|_], Y, X) :-
										level(H, LvH),
										LvH == 3,
										checkStairs(Board, Y, X, -1, -1).

checkLineForStairs(Board, [_|T], Y, X) :-
																			NewX is X + 1,
																			checkLineForStairs(Board, T, Y, NewX).

checkStairs(Board, Y, X, VarY, VarX) :-
									VarY == 0,
									VarX == 0,
									update(VarY, VarX, NewVarY, NewVarX),
									checkStairs(Board, Y, X, NewVarY, NewVarX).

checkStairs(Board, Y, X, VarY, VarX) :-
									NewY is Y + VarY,
									NewX is X + VarX,
									\+ checkGoodPos(NewY, NewX),
									update(VarY, VarX, NewVarY, NewVarX),
									checkStairs(Board, Y, X, NewVarY, NewVarX).


checkStairs(Board, Y, X, VarY, VarX) :-
									NewY is Y + VarY,
									NewX is X + VarX,
									getMatrixElemAt(NewY, NewX, Board, Elem),
									level(Elem, ElemLv),
									ElemLv == 2,
								 checkForLv1(Board, Y, X, VarY, VarX).


checkStairs(Board, Y, X, VarY, VarX) :-
																		update(VarY, VarX, NewVarY, NewVarX),
								 									  checkStairs(Board, Y, X, NewVarY, NewVarX).


checkForLv1(Board, Y, X, VarY, VarX) :-
									NewY is Y + VarY + VarY,
									NewX is X + VarX + VarX,
									checkGoodPos(NewY, NewX),
									getMatrixElemAt(NewY, NewX, Board, Elem),
									level(Elem, ElemLv),
									ElemLv == 1 .


checkGoodPos(Y, X) :- X =< 3, X >= 0, Y =< 3, Y >= 0.

update(1, 1, _, _) :- !, fail.
update(X, Y, NewX, NewY) :- (Y == 1 -> NewY is -1, NewX is X + 1;
							NewY is Y + 1, NewX is X).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




startGame(List) :- initialGame(Game),
									 gameLoop(Game, List, List, 1).


gameLoop([Board|GamePieces], [CurrPlayer|NextPlayers], Players, PlayerNum) :-
					printBoard([Board|GamePieces]),
					checkEmptyStock(GamePieces),
					once(ite(CurrPlayer == p, playerTurn([Board|GamePieces], PlayerNum, [NewBoard|NewStock]), botTurnLv1([Board|GamePieces], PlayerNum, [NewBoard|NewStock]))),
					it(gameWin(NewBoard),gameEnd([NewBoard|NewStock], PlayerNum)),
					ite(NextPlayers == [], NewPlayerNum is 1, NewPlayerNum is PlayerNum + 1),
					ite(NextPlayers == [],
					gameLoop([NewBoard|NewStock], Players, Players, NewPlayerNum),
					gameLoop([NewBoard|NewStock], NextPlayers, Players, NewPlayerNum)).

gameLoop([_|GamePieces], _, _, _) :-
					\+ checkEmptyStock(GamePieces),
					nl, nl,
					write('No more available plays. It is a Draw!').

gameEnd(Game, Num) :-
					printBoard(Game),
					nl, nl,
					write('Congratulations Player '), write(Num), write('. You won the game!'),
					!,fail.








playerTurn(Game, Num, NewGame) :-
																		nl, write('Player '), write(Num),write(' turn:'),nl,
																		once(askPiece(Piece)),
																		once(askCoords(Y, X)),
																		movePiece(Piece, Y, X, Game, NewGame).


playerTurn(Game, Num, NewGame) :-
																		nl, write('Unable to place piece, try again.'), nl,
																		playerTurn(Game, Num, NewGame).



askPiece(Piece) :-
									nl,
									write('   '), printCelTop(n1h), write('   '), printCelTop(n1p), write('   '), printCelTop(n2h), write('   '), printCelTop(n2p), nl,
									write(' 1-'), printCelInt(n1h), write(' 2-'), printCelInt(n1p), write(' 3-'), printCelInt(n2h), write(' 4-'), printCelInt(n2p), nl,
									write('   '), printCelBot(n1h), write('   '), printCelBot(n1p), write('   '), printCelBot(n2h), write('   '), printCelBot(n2p), nl,
									write('     1             1             2             2'),nl,nl,
									askInteger('Choose your piece: ', 1, 4, Option),
									getPiece(Option, Piece).


askPiece(Piece, PiecesStock) :-
						nl, write('Piece out of stock, choose another one.'), nl,
						askPiece(Piece, PiecesStock).


askCoords(Y, X) :-
								nl, write('Choose the coordinates:'), nl, nl,
								askInteger('X= ', 0, 3, X),
								askInteger('Y= ', 0, 3, Y).


getPiece(1, n1h).
getPiece(2, n1p).
getPiece(3, n2h).
getPiece(4, n2p).

playablePiece(n1h).
playablePiece(n1p).
playablePiece(n2h).
playablePiece(n2p).

coord(0).
coord(1).
coord(2).
coord(3).


checkStock(n1h, [0,_,_]) :- !,fail.
checkStock(n1p, [_,0,_]) :- !,fail.
checkStock(n2h, [_,_,0]) :- !,fail.
checkStock(n2p, [_,_,0]) :- !,fail.
checkStock(_,_).

checkEmptyStock([0,0,0]) :- !,fail.
checkEmptyStock(_).

updateStock(n1h, [K,A,B], [NewK,A,B]) :- NewK is K - 1.
updateStock(n1p, [A,K,B], [A,NewK,B]) :- NewK is K - 1.
updateStock(n2h, [A,B,K], [A,B,NewK]) :- NewK is K - 1.
updateStock(n2p, [A,B,K], [A,B,NewK]) :- NewK is K - 1.


t :- askPiece(_,_).

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



print :- initialBoard(B),
			movePiece(n1h, 1, 1, B, B0),
			movePiece(n2h, 1, 1, B0, B1),
			movePiece(n2h, 0, 2, B1, B2),
			movePiece(n2h, 2, 2, B2, B3),
			movePiece(n1p, 1, 3, B3, B4),
			movePiece(n1p, 3, 3, B4, B5),

			Game = [B5, 6, 5, 1],
			printBoard(Game),
			gameWin(B5).


%32
printBoard([Board, HoledPieces, PlainPieces, DualPieces]) :-
					write('            '), put_code(201),printLineDivision,put_code(203),printLineDivision,put_code(203),printLineDivision,put_code(203),printLineDivision,put_code(187), nl,
					write('            '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186),write('  Remaining holed single pieces: '), write(HoledPieces), nl,
					write('     y'), put_code(92), write('x    '), put_code(186), write('     0     '), put_code(186), write('     1     '), put_code(186), write('     2     '), put_code(186), write('     3     '), put_code(186), write('  Remaining plain single pieces: '), write(PlainPieces), nl,
					write('            '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('           '), put_code(186), write('  Remaining dual pieces: '), write(DualPieces), nl,
					put_code(201),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(185), nl,
					getListElemAt(0, Board, Array0),
					printLine(0, Array0, 0), nl,
					put_code(204),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(185), nl,
					getListElemAt(1, Board, Array1),
					printLine(0, Array1, 1), nl,
					put_code(204),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(185), nl,
					getListElemAt(2, Board, Array2),
					printLine(0, Array2, 2), nl,
					put_code(204),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(206),printLineDivision,put_code(185), nl,
					getListElemAt(3, Board, Array3),
					printLine(0, Array3, 3), nl,
					put_code(200),printLineDivision,put_code(202),printLineDivision,put_code(202),printLineDivision,put_code(202),printLineDivision,put_code(202),printLineDivision,put_code(188).


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

printLineDivision :- put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205),put_code(205).
