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
  ite(getWinningPlay(Plays, WinningPlay), NewGame = WinningPlay, minmax(1, Game, NewGame)).

minmax(Depth, Game, NewGame) :-
  write('entrou'), nl,
  write(Depth), nl,
  write(Game), nl,
  minmaxAux(Depth, max, _, Game, NewGame).

minmaxAux(0, _, Value, Game, Game) :-
  write('Leaf'), nl,
  write(Game), nl,
  noOfNonLosingGames(Game, Value),
  write('value: '), write(Value), nl, !.

minmaxAux(Depth, min, Value, Game, NewGame) :-
  NewDepth is Depth - 1,
  setof(ValueAux-GameAux, (P^X^Y^movePiece(P, X, Y, Game, Play), minmaxAux(NewDepth, max, ValueAux, Play, GameAux)), Plays),
  write(Plays), nl,
  minPlay(Plays, Value, NewGame),
  write(Value), nl,
  write(NewGame), nl.

minmaxAux(Depth, max, Value, Game, NewGame) :-
  NewDepth is Depth - 1,
  write('depth: '), write(NewDepth), nl,
  setof(ValueAux-GameAux, (P^X^Y^movePiece(P, X, Y, Game, Play), minmaxAux(NewDepth, min, ValueAux, Play, GameAux)), Plays),
  write(Plays), nl,
  maxPlay(Plays, Value, NewGame).

minPlay(Plays, Value, Play) :-
  minPlayAux(Plays, 999999, [], Value, Play).

minPlayAux([], Value, Play, Value, Play).

minPlayAux([V-G | T], MinVal, MinGame, Value, Play) :-
  V < MinVal,
  minPlayAux(T, V, G, Value, Play).

minPlayAux([V-G | T], MinVal, MinGame, Value, Play) :-
  minPlayAux(T, MinVal, MinGame, Value, Play).

maxPlay(Plays, Value, Play) :-
  maxPlayAux(Plays, -999999, [], Value, Play).

maxPlayAux([], Value, Play, Value, Play).

maxPlayAux([V-G | T], MaxVal, MaxGame, Value, Play) :-
  V < MaxVal,
  maxPlayAux(T, V, G, Value, Play).

maxPlayAux([V-G | T], MaxVal, MaxGame, Value, Play) :-
  maxPlayAux(T, MaxVal, MaxGame, Value, Play).

getWinningPlay([], _) :- !, fail.
getWinningPlay([[H|T]|NextPlays], Game) :-
  ite(gameWin(H), Game = [H|T], getWinningPlay(NextPlays, Game)).

nonLosingGame(Game) :-
  getPossiblePlays(Game, Plays),
  not(getWinningPlay(Plays, _)).

restrictToNonLosingGame(Plays, NewPlays) :-
  filter(nonLosingGame, Plays, NewPlays).

noOfNonLosingGames(Game, Number) :-
  getPossiblePlays(Game, PlaysAll),
  restrictToNonLosingGame(PlaysAll, NonLosingPlays),
  len(NonLosingPlays, Number).
