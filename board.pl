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


printBoard :- initialBoard(Board), printMatrix(Board, '  ').


















% Board preset

initialBoard([
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty],
			[empty, empty, empty, empty]]).
			