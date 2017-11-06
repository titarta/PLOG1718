nonLossingGame(Game, [[H]]).


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


getWinningPlay([], _) :- !, fail.
getWinningPlay([[H|T]|NextPlays], Game) :-
            ite(gameWin(H), Game = [H|T], getWinningPlay(NextPlays, Game)).
