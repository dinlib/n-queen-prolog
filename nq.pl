:- use_module(library(clpfd)).

rainhas([], []). % Predicado para caso geral usando CLP(FD)
rainhas(A, B) :-
  append([], A, Bcp),
  salvo(Bcp) -> (
    length(A, X),
    write('Posições Válidas!'),
    nl,
    tabuleiro(A, X, A)
  ); (
    length(A, X),
    write('Posições Inválidas!'),
    nl, nl,
    tabuleiro(A, X, A)
  ) -> (
    write("Possíveis Soluções: "),
    procura_solucao(X, B, B)
  ).

rainhas([]). % Predicado para 10 rainhas
rainhas(S) :-
  % rainhas(10, S), rainhas(10, Q).
  salvo(S) ->
  (
    write('Posições Válidas!'),
    nl,
    tabuleiro(S, 10, S)
  );
  (
    write('Posições Inválidas!'),
    nl,
    tabuleiro(S, 10, S)
  ).

procura_solucao(N, L, [H|T]) :- % Procura solução para o predicado geral quando falha, utilizando a abordagem
  length(L, N),
   L ins 1..N, %domain(L, 1, N),
   salvo(L),
   labeling([], L).
  %  nl,
  %  tabuleiro(L, N, L).

salvo([]).
salvo([X|Xs]) :-
  salvo_entre(X, Xs, 1),
  salvo(Xs).

salvo_entre(X, [], M).
salvo_entre(X, [Y|Ys], M) :-
  teste_ataque(X, Y, M),
  M1 is M+1,
  salvo_entre(X, Ys, M1).

teste_ataque(X, Y, N) :- % Verifica o conflito entre as rainhas na mesma coluna e nas Diagonais
  X #\= Y, % Coluna
  X+N #\= Y, % Diagonal
  X-N #\= Y. % Diagonal

tabuleiro([], _, []).
tabuleiro([L|List], Number, Bcp):-
   append(R, List, Bcp),
   reverse(R, Reverse, []), % Reverse contém a lista Complemento de List de trás para frente
   [H|T] = Reverse, % H é o primeiro elemento de Reverse, e T é o resto da lista
   salvo_entre(L, List, 1), salvo_entre(H, T, 1) -> ( % Verifica Conflitos da coluna pra cima e da coluna pra baixo
      imprime_comeco(L, Number, 0),
      nl,
      tabuleiro(List, Number, Bcp)
  );
  (
    imprime_comeco(L, Number, 1),
    nl,
    tabuleiro(List, Number, Bcp)
  );
  true.

imprime_comeco(Num, Control, Type):- % Função que imprime uma fileira do tabuleiro de Xadrez até a posição da Rainha
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

imprime_fim(Num, Control):- % Função que imprime uma fileira do tabuleiro de Xadrez da posição da Rainha até a posição final
  incx(Var, Num),
  foreach(between(Var, Control, _), write(' - ')).

incx(X1, X):- % Predicado para incrementar uma variável
  X1 is X+1.

decx(X1, X):- % Predicado para decrementar uma variável
  X1 is X-1.

reverse([], R, R). % Predicado para inverter uma lista uma variável
reverse([H|T], R, Acc):-
  reverse(T, R, [H|Acc]).





/*
TESTES:

CASO GERAL:
?- rainhas([1,2,3,4], Rainhas).
?- rainhas([1,4,2,5,3], Rainhas).
?- rainhas([2,4,6,1,3,5], Rainhas).
?- rainhas([1,6,2,3,5,4], Rainhas).

10-Rainhas:
?- rainhas([5,7,10,6,3,1,8,4,2,9]).
?- rainhas([5,7,10,6,3,1,8,4,2,8]).
?- rainhas([5,7,10,6,10,1,8,4,2,9]).
?- rainhas([1,2,3,4,5,6,7,8,9,10]).
?- rainhas([10,9,8,7,6,5,4,3,2,1]).
?- rainhas([5,5,5,5,5,5,5,5,5,5]).

*/
