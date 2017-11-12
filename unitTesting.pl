testBoardStairs1([
  [empty, n3h, n2p, n1h],
  [empty, empty, empty, empty],
  [empty, empty, empty, empty],
  [empty, empty, empty, empty]]).

testBoardStairs2([
  [empty, empty, empty, empty],
  [n3h, n2p, n1h, empty],
  [empty, empty, empty, empty],
  [empty, empty, empty, empty]]).

testBoardStairs3([
  [empty, n3h, empty, empty],
  [empty, n2p, empty, empty],
  [empty, n1h, empty, empty],
  [empty, empty, empty, empty]]).

testBoardStairs4([
  [empty, n3h, empty, empty],
  [empty, empty, n2h, empty],
  [empty, empty, empty, n1h],
  [empty, empty, empty, empty]]).

testBoardStairs5([
  [empty, empty, empty, empty],
  [n1h, empty, empty, empty],
  [n2p, empty, empty, empty],
  [n3h, empty, empty, empty]]).

testBoardStairs6([
  [empty, empty, empty, empty],
  [empty, empty, empty, empty],
  [empty, empty, empty, empty],
  [empty, n3h, n2p, n1h]]).

testGame2([[
  [empty, n1h, n3h, empty],
  [n1h, n2p, empty, n2h],
  [n2h, n2p, empty, n1p],
  [n2p, n3h, n2p, n2h]], 0, 7, 1]).

testGame1([[
  [empty, empty, n1h, n2h],
  [empty, n2p, n1p, n2h],
  [n3p, empty, empty, n3p],
  [n1h, n3p, n2h, n2p]], 0, 4, 3]).

unitTests :-
	testBoardStairs6(Board1),
	gameWin(Board1).

testEvaluate :-
  testGame1(Game),
  evaluate(Game, Value, 0),
  write(Value).
