:- use_module(library(system)).
:- use_module(tda_drive_20915795_CaicesLima).
:- use_module(tda_user_20915795_CaicesLima).
:- use_module(tda_folder_20915795_CaicesLima).
:- use_module(tda_file_20915795_CaicesLima).




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
    makesystem(NombreSystem2,[],"",[],[],[],[],[],System).

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

getPaths(System,Paths):-
    makesystem(_,_,_,_,_,_,_,Paths,_,System).

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

setPaths(System, NewPaths, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, _,  Content,System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, NewPaths,  Content,NewSystem).

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
    setDrives(System,NewDrives,NewSystem0),
    
    getPaths(System,Paths), %obtiene paths del system
    string_concat(Letter,":/",NewPath0),
    string_lower(NewPath0,NewPath),
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system

%RF4
systemRegister(System,UserName,NewSystem):-
    user(UserName,NewUser),
    getUsers(System,Users),
    not(member(UserName,Users)),
    append(Users,NewUser,NewUsers),
    setUsers(System,NewUsers,NewSystem).

systemRegister(System,UserName,System):-
    getUsers(System,Users),
    member(UserName,Users).

%RF5
systemLogin(System,UserName,NewSystem):-
    getLogedUser(System,[]),
    user(UserName,LogedUser),
    setLogin(System,LogedUser,NewSystem).

systemLogin(System,UserName,System):-
    getLogedUser(System,LogedUser),
    user(UserName,LogedUser).

%RF6
systemLogout(System,NewSystem):-
    not(getLogedUser(System,[])),
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

    %Crea nuevo path
    sysFolder(System,FolderName,Folder), %crea folder
    getFolderName(Folder,FolderNameMin),
    getLocation(Folder,Location),
    string_concat(Location,FolderNameMin,NewPath), %crea NewPath

    %Agrega folder a contenido del sistema
    getContent(System,Content), %obtiene el contenido del system
    append(Content,[Folder],NewContent),  %agrega folder al contenido
    setContent(System,NewContent,NewSystem0), %setea new content

    %Del system resultando ahora debe agregar la nueva ruta a los paths del sistema
    getPaths(System,Paths), %obtiene paths del system
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system


%RF9 Cd

string_contains(String, SubString):-
    sub_string(String, _, _, _, SubString).

split_path(Path, Parts):-
    split_string(Path, "/", "", Parts).

eliminar_primero([_|T], T).

getFirst([X|_],X).

string_join([], _, '').

string_join([X], _, X):- !.

string_join([X|Xs], Delimiter, Result):-
    string_join(Xs, Delimiter, Rest),
    string_concat(X, Delimiter, Concatenated),
    string_concat(Concatenated, Rest, Result).

ruta_padre(Path, ParentPath):-
    split_string(Path, "/", "", PathList),
    reverse(PathList, ReversedPathList),
    eliminar_primero(ReversedPathList,NewReversedPathList),
    reverse(NewReversedPathList,NewPathList),
    string_join(NewPathList,"/",ParentPath).

ruta_raiz(Path, Root):-
    split_string(Path, "/", "", PathList),
    getFirst(PathList,Root0),
    string_concat(Root0,"/",Root).
    

% currentpath: "c:/folder1/"
% input: "/folder2" 
% resultado: "c:/folder1/folder2/"
systemCd(System,FolderPath,NewSystem):-
    sub_string(FolderPath, 0, 1, _, PrimerElemento),
    string_contains(PrimerElemento,"/"),
    sub_string(FolderPath, 1, _, 0, FormatPath),
    getCurrentPath(System,CurrentPath),
    string_concat(CurrentPath,FormatPath,NewPath0),
    string_concat(NewPath0,"/",NewPath),
    setCurrentPath(System,NewPath,NewSystem).

% currentpath: "c:/"
% folderpath: "Folder1/Folder11"
% resultado: "c:/folder1/folder11"
systemCd(System,FolderPath,NewSystem):-
    not(string_length(FolderPath,1)),
    %string_contains(FolderPath,"/"),
    string_concat(FolderPath,"/",FolderPath0),
    getCurrentPath(System,CurrentPath),
    string_lower(FolderPath0,FolderPathMin),
    string_concat(CurrentPath,FolderPathMin,NewPath),
    setCurrentPath(System,NewPath,NewSystem).

% currentpath: "c:/"
% input: "d:/folder1" (Si contiene : entonces uso este)
% resultado: "d:/folder1/"
systemCd(System,NewPath,NewSystem):-
    string_contains(NewPath,":"),
    setCurrentPath(System,NewPath,NewSystem).

% currentpath: "c:/folder1/folder11/"
% input: ".." 
% resultado: "c:/folder1/"
systemCd(System,Input,NewSystem):-
    string_contains(Input,".."),
    getCurrentPath(System,CurrentPath),
    ruta_padre(CurrentPath,ParentPath),
    setCurrentPath(System,ParentPath,NewSystem).

% currentpath: "c:/folder1/"
% input: "/" 
% resultado: "c:/"
systemCd(System,Input,NewSystem):-
    string_contains(Input,"/"),
    string_length(Input,1),
    getCurrentPath(System,CurrentPath),
    ruta_raiz(CurrentPath,Root),
    setCurrentPath(System,Root,NewSystem).


    

%RF10

sysFile(System,File,[FileName,CreateDate,ModDate,Location,Creator,Text]):-
    not(getLogedUser(System, [])),
    getFileName(File,FileName),
    getText(File,Text),
    getDate(System,CreateDate),
    getDate(System,ModDate),
    getCurrentPath(System,Location),
    getLogedUser(System,Creator).


systemAddFile(System,File,NewSystem):-

    %Crea nuevo path
    sysFile(System,File,SysFile), %crea File
    getFileName(SysFile,FileNameMin),
    getFileLocation(SysFile,Location),
    string_concat(Location,FileNameMin,NewPath), %crea NewPath

    %Agrega File a contenido del sistema
    getContent(System,Content), %obtiene el contenido del system
    append(Content,[SysFile],NewContent),  %agrega File al contenido
    setContent(System,NewContent,NewSystem0), %setea new content

    %Del system resultando ahora debe agregar la nueva ruta a los paths del sistema
    getPaths(System,Paths), %obtiene paths del system
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system
