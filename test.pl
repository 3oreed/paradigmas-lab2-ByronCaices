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

systemAddFile(System,FileName,NewSystem):-

    %Crea nuevo path
    sysFile(System,FileName,File), %crea File
    getFileName(File,FileNameMin),
    getFileLocation(File,Location),
    string_concat(Location,FileNameMin,NewPath), %crea NewPath

    %Agrega File a contenido del sistema
    getContent(System,Content), %obtiene el contenido del system
    append(Content,[File],NewContent),  %agrega File al contenido
    setContent(System,NewContent,NewSystem0), %setea new content

    %Del system resultando ahora debe agregar la nueva ruta a los paths del sistema
    getPaths(System,Paths), %obtiene paths del system
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system
