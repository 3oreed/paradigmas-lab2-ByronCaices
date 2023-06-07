:- use_module(library(system)).
:- use_module(tda_drive_20915795_CaicesLima).


% unifica fecha y hora del sistema en un solo string
fecha_y_hora_actual(FechaYHora) :-
    get_time(Timestamp),
    stamp_date_time(Timestamp, DateTime, local),
    format_time(atom(FechaYHora), '%Y-%m-%d %H:%M:%S', DateTime).


% si es mayúscula la convierte a minúscula
to_minuscula(Caracter, CaracterMinuscula) :-
    char_code(Caracter, Codigo),
    Codigo >= 65, Codigo =< 90,
    CodigoMinuscula is Codigo + 32,
    char_code(CaracterMinuscula, CodigoMinuscula).

% si no es mayúscula, responde con el mismo caracter
to_minuscula(Caracter, Caracter) :-
    char_code(Caracter, Codigo),
    (Codigo < 65 ; Codigo > 90).

% convierte todos los caracteres de un string a minúsculas y responde el string resultante
/*
el atom_chars de mas arriba recibe la palabra y la transforma en una lista de caracteres
maplist aplica to_minuscula a cada elemento de la lista de caracteres y se retorna la lista minuscula 
luego con la condicion de atom_chars podemos regresar a convertir la lista minuscula a palabra minuscula
*/
string_downcase(Palabra, PalabraString) :-
    atom_chars(Palabra, ListaCaracteres),
    maplist(to_minuscula, ListaCaracteres, ListaMinuscula),
    atom_chars(PalabraMinuscula, ListaMinuscula),
    atom_string(PalabraMinuscula,PalabraString).

char_to_lower(Caracter, CaracterMinuscula) :-
    char_code(Caracter, Codigo),
    Codigo >= 65, Codigo =< 90,
    CodigoMinuscula is Codigo + 32,
    char_code(CaracterMinuscula, CodigoMinuscula).

char_to_lower(Caracter, Caracter) :-
    char_code(Caracter, Codigo),
    (Codigo < 65 ; Codigo > 90).

/*
DOMINIO:
- system-name (string) 0
- system-date (date) 1
- loged-user (string) 2
- current-path (string) 3
- users (list:user) 4
- drives (list:drive) 5 
- trashcan (list:path) 6
- paths (list:path) 7
*/

% TDA System
makesystem(SystemName,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths]):-
    fecha_y_hora_actual(SystemDate).

makesystem(SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths]).

system(NombreSystem,System):-
    %makesystem/8
    makesystem(NombreSystem,[],[],[],[],[],[],System).


getDrives(System, Drives) :-
    %makesystem/9
    makesystem(_,_,_,_,_,Drives,_,_,System).

getUsers(System, Users):-
    makesystem(_,_,_,_,Users,_,_,_,System).


setDrives(System, Drives, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, _, Trashcan, Paths, System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths, NewSystem).

setUsers(System, Users, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, _, Drives, Trashcan, Paths, System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths, NewSystem).



%[["D","drive1",100],["C","drive2",500]]
   
%%%%%%%%%%%%%%%%%%

% TDA USER


%RF3
systemAddDrive(System,Letter,DriveName,Cap,NewSystem):-
    drive(Letter,DriveName,Cap,NewDrive),
    getDrives(System,Drives),
    not(member(NewDrive,Drives)),
    not(existingLetter(Letter,Drives)),
    addDriveToDrives(Drives,NewDrive,NewDrives),
    setDrives(System,NewDrives,NewSystem).

%RF4
systemRegister(System,UserName,NewSystem):-
    user(UserName,NewUser),
    getUsers(System,Users),
    not(member(NewUser,Users)),
    append(Users,[NewUser],NewUsers),
    setUsers(System,NewUsers,NewSystem).
