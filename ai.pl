botTurn(Game, Num, NewGame, Difficulty) :- it(Difficulty == 0, botTurnLv0(Game, Num, NewGame)),
  it(Difficulty == 1, botTurnLv1(Game, Num, NewGame)),
  it(Difficulty == 2, botTurnLv2(Game, Num, NewGame)),
  it(Difficulty == 3, botTurnLv3(Game, Num, NewGame)).

getPossiblePlays(Game, Plays) :-
  setof(Play, P^X^Y^movePiece(P,X,Y,Game,Play), PlaysAux),
  random_permutation(PlaysAux, Plays).

botTurnLv0(Game, Num, NewGame) :-
  nl, write('Player '), write(Num),write(' turn:'),nl,
  getPossiblePlays(Game, [NewGame|_]).

botTurnLv1(Game, Num, NewGame) :-
  nl, write('Player '), write(Num),write(' turn:'),nl,
  getPossiblePlays(Game, [PossiblePlay|NextPlays]),
  ite(getWinningPlay([PossiblePlay|NextPlays], WinningPlay), NewGame = WinningPlay, NewGame = PossiblePlay).

botTurnLv2(Game, Num, NewGame) :-
  nl, write('Player '), write(Num),write(' turn:'),nl,
  getPossiblePlays(Game, Plays),
  ite(getWinningPlay(Plays, WinningPlay), NewGame = WinningPlay, botTurnLv2Aux(Plays, NewGame)).

botTurnLv2Aux([Play], GoodPlay) :- GoodPlay = Play.
botTurnLv2Aux([CurrPlay|Plays], GoodPlay) :-
  ite(nonLosingGame(CurrPlay), GoodPlay = CurrPlay, botTurnLv2Aux(Plays,GoodPlay)).

botTurnLv3(Game, Num, NewGame) :-
  noOfNonLosingGames(Game, Number),
  ite(Number =< 12, botTurnLv3aux1(Game, Num, NewGame), botTurnLv2(Game, Num, NewGame)).

botTurnLv3aux1(Game, Num, NewGame) :-
  nl, write('Player '), write(Num),write(' turn:'),nl,
  getPossiblePlays(Game, Plays),
  ite(getWinningPlay(Plays, WinningPlay), NewGame = WinningPlay, botTurnLv3Aux2(Plays, NewGame)).

botTurnLv3Aux2(Plays, GoodPlay) :-
  restrictToNonLosingGame(Plays, NonLosingPlays),
  nl, nl, write(NonLosingPlays), nl, nl, write(Plays), nl, nl,
  ite(getBest(NonLosingPlays, GoodPlay, Value), ! , getListElemAt(0, Plays, GoodPlay)).

getBest([], _, _) :- !, fail.

getBest([Test], Test, Value) :-
  evaluate(Test, Value).

getBest([CurrTest|NextTests], BestPlay, Value) :-
  getBest(NextTests, NewPlay, NewValue),
  evaluate(CurrTest, EvaluateValue),
  write(EvaluateValue), nl, write(NewValue), nl,
  ite(EvaluateValue > NewValue, write('bigger'), write('smaller')), nl,
  ite(EvaluateValue > NewValue, BestPlay = CurrTest, BestPlay = NewPlay),
  ite(EvaluateValue > NewValue, Value is EvaluateValue, Value is NewValue).

getBest([CurrTest|NextTests], BestPlay, Value) :-
  getBest(NextTests, BestPlay, Value).

getWinningPlay([], _) :- !, fail.
getWinningPlay([[H|T]|NextPlays], Game) :-
  ite(gameWin(H), Game = [H|T], getWinningPlay(NextPlays, Game)).

nonLosingGame(Game) :-
  getPossiblePlays(Game, Plays),
  not(getWinningPlay(Plays, _)).

restrictToNonLosingGame(Plays, NewPlays) :-
  filter(nonLosingGame, Plays, NewPlays).

evaluate(Game, Value) :-
  write('Start evaluate'), nl,
  once(getPossiblePlays(Game, EnemyPlaysAll)),
  once(restrictToNonLosingGame(EnemyPlaysAll, EnemyPlays)),
  once(getEnemyPlaysValue(EnemyPlays, EnemyPlaysValue)),

  len(EnemyPlaysValue, NumberEnemyPlays),
  sum_list(EnemyPlaysValue, SumEnemyPlays),
  write('SumEnemyPlays: '), write(SumEnemyPlays), write('   NumberEnemyPlays: '), write(NumberEnemyPlays), nl,
  ite(NumberEnemyPlays == 0, Value is 1000, ite(SumEnemyPlays == 0, Value is -1, Value is SumEnemyPlays / NumberEnemyPlays - NumberEnemyPlays / 2)),
  write('Value: '), write(Value), nl,
  write('End evaluate'), nl.

evaluate(_, -1) :- write('Failed, -1'), nl.

getEnemyPlaysValue([EnemyPlay],[ValueOfPlay]) :-
  noOfNonLosingGames(EnemyPlay, ValueOfPlay).
getEnemyPlaysValue([EnemyPlay|EnemyPlays], [ValueOfPlay|ValueOfOtherPlays]) :-
  noOfNonLosingGames(EnemyPlay, ValueOfPlay),
  getEnemyPlaysValue(EnemyPlays, ValueOfOtherPlays).

noOfNonLosingGames(Game, Number) :-
  getPossiblePlays(Game, PlaysAll),
  restrictToNonLosingGame(PlaysAll, NonLosingPlays),
  len(NonLosingPlays, Number).
