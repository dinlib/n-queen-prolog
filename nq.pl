:- use_module(library(clpfd)).

rainhas(N, L) :-
  length(L, N),
   L ins 1..N, %domain(L, 1, N),
  salvo(L),
  labeling([], L),
  nl,
  tabuleiro(L, N, S, N).

salvo([]).
salvo([X|Xs]) :-
  salvo_entre(X, Xs, 1),
  salvo(Xs).

salvo_entre(X, [], M).
salvo_entre(X, [Y|Ys], M) :-
  teste_ataque(X, Y, M),
  M1 is M+1,
  salvo_entre(X, Ys, M1).


teste_ataque(X, Y, N) :-
  X #\= Y,
  X+N #\= Y,
  X-N #\= Y.

rainhas([]).
rainhas(S) :-
  % rainhas(10, S), rainhas(10, Q).
  salvo(S) ->
  (
    write('Posições Válidas!'),
    nl,
    tabuleiro(S, 10, S, 1)
  );
  (
    write('Posições Inválidas!'),
    nl,
    tabuleiro(S, 10, S, 1)
  ).

tabuleiro([], _, [], _).
tabuleiro([L|List], Number, Bcp, Count):-
   append(R, List, Bcp),
   reverse(R, Reverse, []),
   [H|T] = Reverse,
  salvo_entre(L, List, 1), salvo_entre(H, T, 1) -> ( %Verifica Conflitos da coluna pra cima e da coluna pra baixo
    imprime_comeco(L, Number, 0),
    nl,
    M is Count + 1,
    tabuleiro(List, Number, Bcp, M)
  );
  (
    imprime_comeco(L, Number, 1),
    nl,
    M is Count + 1,
    tabuleiro(List, Number, Bcp, M)
  ).


imprime_comeco(Num, Control, Type):-
  decx(Var, Num),
  foreach(between(1, Var, _), write(' - ')),
  Type =:= 0 ->
  (
    write(' R '),
    imprime_fim(Num, Control)
  );
  (
    write(' C '),
    imprime_fim(Num, Control)
  ).

imprime_fim(Num, Control):-
  incx(Var, Num),
  foreach(between(Var, Control, _), write(' - ')).


incx(X1, X):-
  X1 is X+1.

decx(X1, X):-
  X1 is X-1.

reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).

/*
TESTES:
?- rainhas(1, Rainhas).
?- rainhas(2, Rainhas).
?- rainhas(3, Rainhas).
?- rainhas(4, Rainhas).
?- rainhas(5, Rainhas).
?- rainhas(6, Rainhas).
?- rainhas(7, Rainhas).
?- rainhas(8, Rainhas).
?- rainhas(9, Rainhas).
?- rainhas(10, Rainhas).

?- rainhas([5,7,10,6,3,1,8,4,2,9]).
?- rainhas([5,7,10,6,3,1,8,4,2,8]).
?- rainhas([5,7,10,6,10,1,8,4,2,9]).
?- rainhas([1,2,3,4,5,6,7,8,9,10]).
?- rainhas([10,9,8,7,6,5,4,3,2,1]).
?- rainhas([5,5,5,5,5,5,5,5,5,5]).

*/
