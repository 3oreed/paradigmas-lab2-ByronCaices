% a) base de conocimientos
producto(cuaderno,1,500).
producto(lapiz,1,200).
producto(piedra,4,800).
producto(zelda_tears_of_kingdom,1,70000).
producto(computador,9,800000).
producto(cuadro,2,900000).
producto(yunque,70,50000).

% max peso = 15
% max dinero = 900000

getPeso(Producto,Peso):-
    producto(Producto,Peso,_).

getPrecio(Producto,Precio):-
    producto(Producto,_,Precio).

/* listaCumpleRestricciones(ListaCandidatos,RestriccionPeso,RestriccionDinero):-
    listaCumplePeso(ListaCandidatos),
    listaCumpleDinero(ListaCandidatos). */


listaCumplePeso([],0).

listaCumplePeso([Producto|ListaCandidatos],SumaPesos):-
    getPeso(Producto,Peso),
    %SumaPesos is Peso + SumaPesos1,
    listaCumplePeso(ListaCandidatos,SumaPesos1),
    SumaPesos is Peso + SumaPesos1.

listaCumpleDinero([],0).

listaCumpleDinero([Producto|ListaCandidatos],SumaPrecios):-
    getPrecio(Producto,Precio),
    %SumaPesos is Peso + SumaPesos1,
    listaCumpleDinero(ListaCandidatos,SumaPrecios1),
    SumaPrecios is Precio + SumaPrecios1.

%Filtra productos mayores a precio minimo.
filterByPrecioMin(PrecioMin,Producto):-
    producto(Producto,_,_),
    getPrecio(Producto,Precio),
    Precio >= PrecioMin.

filterByPrecioMax(PrecioMin,Producto):-
    producto(Producto,_,_),
    getPrecio(Producto,Precio),
    Precio =< PrecioMin.


listaFilter(Producto,[Producto]).

listaFilter([Producto|_],[P]):-
    P is filterByPrecioMin(1000,Producto).

listaFilter([_|ListaProductos],L):-
    listaFilter(ListaProductos,L1),
    L is append(L,L1).

%07-Ejercicio Grafo

% a) Base de conocimientos

%viaje(Origen,Destino,Distancia,Tiempo,Costo).

viaje(santiago,buenos_aires,1137,2,150).
viaje(buenos_aires,santiago,1137,2,150).
viaje(santiago,mendoza,363,1,150).
viaje(mendoza,santiago,363,1,150).
viaje(mendoza,sao_paulo,2445,4,280).
viaje(sao_paulo,buenos_aires,1650,3,290).


% b) Determina si existe o no ruta entre un origen y destino


% verifica si hay camino directo o no
ruta(Origen,Destino):-
    viaje(Origen,Destino,_,_,_).

% verifica si hay camino intermedio
ruta(Origen,Destino):-
    ruta(Intermedio,Destino),
    viaje(Origen,Intermedio,_,_,_).
    

% c)

%tour(Origen,Destinos,Presupuesto).

%ej
%tour(santiago,[buenos_aires,sao_paulo,mendoza],1000).

%sumaCostos de cada destino

getCosto(Origen,Destino,P):-
    viaje(Origen,Destino,_,_,P).


sumaCostos(Origen,[Destino],P):-
    getCosto(Origen,Destino,P).

sumaCostos(Origen,[Destino|Destinos],P):-
    sumaCostos(Destino,Destinos,P1),
    getCosto(Origen,Destino,H),
    P is H+P1.

tour(Origen,[Destino],Presupuesto):-
    viaje(Origen,Destino,_,_,Costo),
    Costo =< Presupuesto.

tour(Origen,[Destino|Destinos],Presupuesto):-
    getCosto(Origen,Destino,C),
    tour(Destino,Destinos,P1),
    Presupuesto is P1+C.

    






