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




testBoardStairs7([
		[empty, empty, empty, empty],
		[empty, empty, empty, empty],
		[empty, empty, empty, empty],
		[empty, empty, empty, empty]]).



testBoardStairs8([
		[empty, empty, empty, empty],
		[empty, empty, empty, empty],
		[empty, empty, empty, empty],
		[empty, empty, empty, empty]]).




unitTests :-
	testBoardStairs6(Board1),
	gameWin(Board1).
