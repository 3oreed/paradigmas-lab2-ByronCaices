:- use_module(library(system)).
:- use_module(tda_drive_20915795_CaicesLima).
:- use_module(tda_user_20915795_CaicesLima).
:- use_module(tda_folder_20915795_CaicesLima).




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
- contenido (list:path) 8
*/

% TDA System
makesystem(SystemName,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content]):-
    fecha_y_hora_actual(SystemDate).

makesystem(SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content]).
%makesystem(SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content,[SystemName2,SystemDate,LogedUser,CurrentPath2,Users,Drives,Trashcan,Paths,Content]):-
%    string_lower(SystemName,SystemName2),
%    string_lower(CurrentPath,CurrentPath2).

system(NombreSystem,System):-
    %makesystem/10
    string_lower(NombreSystem,NombreSystem2),
    makesystem(NombreSystem2,[],[],[],[],[],[],[],System).

getDate(System,Date):-
    makesystem(_,Date,_,_,_,_,_,_,_,System).

getDrives(System, Drives) :-
    %makesystem/10
    makesystem(_,_,_,_,_,Drives,_,_,_,System).

getUsers(System, Users):-
    makesystem(_,_,_,_,Users,_,_,_,_,System).

getLogedUser(System, LogedUser):-
    makesystem(_,_,LogedUser,_,_,_,_,_,_,System).

getCurrentPath(System, CurrentPath):-
    makesystem(_,_,_,CurrentPath,_,_,_,_,_,System).

getContent(System,Content):-
    makesystem(_,_,_,_,_,_,_,_,Content,System).



setDrives(System, Drives, NewSystem) :-
%/9
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, _, Trashcan, Paths, Content, System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths, Content, NewSystem).

setUsers(System, Users, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, _, Drives, Trashcan, Paths, Content, System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths, Content, NewSystem).

setLogin(System, User, NewSystem) :-
    makesystem(SystemName,SystemDate, _, CurrentPath, Users, Drives, Trashcan, Paths, Content, System),
    makesystem(SystemName,SystemDate, User, CurrentPath, Users, Drives, Trashcan, Paths, Content, NewSystem).

setCurrentPath(System, NewPath, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, _, Users, Drives, Trashcan, Paths,  Content,System),
    makesystem(SystemName,SystemDate, LogedUser, NewPath, Users, Drives, Trashcan, Paths,  Content,NewSystem).

setContent(System, NewContent, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths,  _,System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths,  NewContent,NewSystem).






%[["D","drive1",100],["C","drive2",500]]
   
%%%%%%%%%%%%%%%%%%

% TDA Folder

/* 
DOMINIO:
- folder-name (string)
- create-date (date)
- mod-date (date)
- location (string)
- creator (user)
- password (string)
 */








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
    not(member(UserName,Users)),
    append(Users,NewUser,NewUsers),
    setUsers(System,NewUsers,NewSystem).

%RF5
systemLogin(System,UserName,NewSystem):-
    getLogedUser(System,[]),
    user(UserName,LogedUser),
    setLogin(System,LogedUser,NewSystem).

%RF6
systemLogout(System,NewSystem):-
    setLogin(System,[],NewSystem).

%RF7
systemSwitchDrive(System,Letter,NewSystem):-
    string_lower(Letter,LetterMin),
    getDrives(System,Drives),
    existingLetter(LetterMin,Drives),
    string_concat(LetterMin,":/",NewPath),
    setCurrentPath(System,NewPath,NewSystem).

%RF8 mkdir

% Creamos un folder desde system
sysFolder(System,FolderName,[FolderNameMin,CreateDate,ModDate,Location,Creator]):-
    not(getLogedUser(System, [])),
    string_lower(FolderName,FolderNameMin),
    getDate(System,CreateDate),
    getDate(System,ModDate),
    getCurrentPath(System,Location),
    getLogedUser(System,Creator).

systemMkdir(System,FolderName,NewSystem):-
    sysFolder(System,FolderName,Folder),
    getContent(System,Content),
    append(Content,[Folder],NewContent),
    setContent(System,NewContent,NewSystem).




