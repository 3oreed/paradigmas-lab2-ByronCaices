estudiante(amalia).

profesor(gonzalo, paradigmas).

%crear una clausula para verificar si un elemeno pertenece a una lista

% Case Base: Si elemento es el primer elemento de la lista entonces es true
pertenece(Elemento,[Elemento|_]):-!.

%
pertenece(Elemento,[_|Resto]):-
    pertenece(Elemento,Resto).


%agregarAlPrincipio/3

agregarAlPrincipio(Elemento,ListaIn,[Elemento|ListaIn]).



agregarAlFinal(Elemento,[],[Elemento]).

agregarAlFinal(Elemento,[_,Resto],ListaOut):-
    agregarAlFinal(Elemento,Resto,ListaOut).


% 8. Insertar un elemento al final de la lista (insertar por cola)

% Caso base: insertar un elemento a una lista vacia
insertarAlFinal( Elemento, [], [Elemento] ).
insertarAlFinal( Elemento, [Cabeza|Resto], [Cabeza|Lista] ) :-
        insertarAlFinal( Elemento, Resto, Lista ).

% Consultas
%insertarAlFinal(Elemento, LInicial, LFinal).
%insertarAlFinal(2, [1,3], LFinal).
% LFinal = [1, 3, 2]

gana(P1,P2):-
    personaje(P1,Ki1,_,_),
    personaje(P2,Ki2,_,_),
    Ki1 > Ki2.
