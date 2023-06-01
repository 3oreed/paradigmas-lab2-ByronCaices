%%Hechos

%B elevado a 0 es 1
potencia(B,0,1):- number(B).
%B elevado a 1 es B
potencia(B,1,B).
%0 elevado a x es 0
potencia(0,Exp,0):- number(Exp).

%%Predicado

%potencia(base,exponente,resultado).
potencia(B,Exp,Res):-
    Exp1 is Exp-1,
    potencia(B,Exp1,Res1),
    Res is Res1*B.

%% Dominios
%   base(num), exponente(num)

%% Meta Principal
%   potencia

% Meta Secundaria
%   no aplica

%#############################

factorial(0,1).
factorial(1,1).
factorial(2,2).

factorial(A,R):-
    A1 is A-1,
    factorial(A1,R1),
    R is R1*A.

% suma los elementos de una lista

%sumalista([],0).

sumalista([x],x).

sumalista([H|T],R):-
    sumalista(T,R1),
    R is H+R1. 


largolista([],0).

largolista([_|T],R):-
    largolista(T,R1),
    R is 1+R1.




%sumalista([2|3,4,5],R). R=R1+2
%sumalista([3|4,5],R1). R1=R2+3
%sumalista([4|5],R2]. R2=R3+4
%sumalista([5|_],R3). R3=R4+5
agregarInicio(X,Lista,[X|Lista]).

agregarFinal(X,[],[X]).

agregarFinal(X,[H|T],[H|L]):-
    agregarFinal(X,T,L).

%agregarFinal(2,[2,4],L1). L1=[2,4,2]
%agregarFinal(2,[4],L2). L2=[4,2]
%agregarFinal(2,[],L3). L3=[2]



gana(P1,P2):-
    personaje(P1,K1,_,_),
    personaje(P2,K2,_,_),
    K1>K2.

%transforma(P,T)
%Personaje P se puede transformar en T ?
%Persona P posee en su lista de transformaciones a T?

%% Dominios

% NombrePersonaje,Ki

%% Hechos
personaje(goku,150000000,[kamehameha,kaioken,genkidama],[normal,ssj1]).
personaje(krilin,75000,[kamehameha,taioken,kienzan],[normal]).
personaje(freezer,12000000,[blaster],[normal,cicuenta,cien]).
personaje(vegeta,250000,[bigbangattack,finalflash],[normal]).


%%Dominios

%%Predicados
% gana(personaje1,personaje2) 
% transforma(personaje,transformacion)
% tecnica(personaje,tecnica)

%% Meta principal
% gana
% transforma
% tecnica

%% Metas Secundarias
% pertenece


pertenece(X,[X|_]).

pertenece(X,[_|T]):-
    pertenece(X,T).

gana(P1,P2):-
    personaje(P1,K1,_,_),
    personaje(P2,K2,_,_),
    K1>K2.

transforma(P,T):-
    personaje(P,_,_,Transformaciones),
    pertenece(T,Transformaciones).


tecnica(P,T):-
    personaje(P,_,Powers,_),
    pertenece(T,Powers).





