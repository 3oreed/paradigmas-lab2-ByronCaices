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


/*
TDA SYSTEM

DESCRIPCION: Predicado que define un System

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

METAS PRIMARIAS: makesystem

*/

% -----------------------Constructor Y Pertenencia---------------------------

% TDA System
makesystem(SystemName,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content]):-
    fecha_y_hora_actual(SystemDate).

makesystem(SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content,[SystemName,SystemDate,LogedUser,CurrentPath,Users,Drives,Trashcan,Paths,Content]).

% -----------------------Requerimientos Funcionales----------------------------

%RF2
% Descripcion: Predicado que crea un sistema vacío con un nombre específico.
% Dominio: NombreSystem X System
% Metas Primarias: system
% Metas Secundarias: string_lower, makesystem

system(NombreSystem,System):-
    %makesystem/10
    string(NombreSystem),
    string_lower(NombreSystem,NombreSystem2),
    makesystem(NombreSystem2,[],"",[],[],[],[],[],System).


%RF3
% Descripcion: Predicado que permite añadir una unidad a un sistema. La letra de la unidad debe ser única.
% Dominio: System X Letter X DriveName X Cap X NewSystem
% Metas Primarias: systemAddDrive
% Metas Secundarias: drive, getDrives, not, member, existingLetter, addDriveToDrives, setDrives, getPaths, string_concat, string_lower, append, setPaths
systemAddDrive(System,Letter,DriveName,Cap,NewSystem):-
    string(DriveName),
    string_lower(Letter,LetterMin),
    drive(LetterMin,DriveName,Cap,NewDrive),
    getDrives(System,Drives),
    not(member(NewDrive,Drives)),
    not(existingLetter(LetterMin,Drives)),
    addDriveToDrives(Drives,NewDrive,NewDrives),
    setDrives(System,NewDrives,NewSystem0),
    
    getPaths(System,Paths), %obtiene paths del system
    string_concat(Letter,":/",NewPath0),
    string_lower(NewPath0,NewPath),
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system

%RF4
% Descripcion: Predicado que registra un usuario en un sistema existente.
% Dominio: System X UserName X NewSystem
% Metas Primarias: systemRegister
% Metas Secundarias: user, getUsers, not, member, append, setUsers
systemRegister(System,UserName,NewSystem):-
    string_lower(UserName,UserNameMin),
    string(UserName),
    user(UserNameMin,NewUser),
    getUsers(System,Users),
    not(member(UserNameMin,Users)),
    append(Users,NewUser,NewUsers),
    setUsers(System,NewUsers,NewSystem).

systemRegister(System,UserName,System):-
    string_lower(UserName,UserNameMin),
    getUsers(System,Users),
    member(UserNameMin,Users).

%RF5
% Descripcion: Predicado que realiza el inicio de sesión de un usuario en un sistema.
% Dominio: System X UserName X NewSystem
% Metas Primarias: systemLogin
% Metas Secundarias: getUsers, member, getLogedUser, user, setLogin
systemLogin(System,UserName,NewSystem):-
    string_lower(UserName,UserNameMin),
    getUsers(System,Users),
    member(UserNameMin,Users),
    getLogedUser(System,[]),
    user(UserNameMin,LogedUser),
    setLogin(System,LogedUser,NewSystem).

systemLogin(System,UserName,System):-
    string_lower(UserName,UserNameMin),
    getLogedUser(System,LogedUser),
    user(UserNameMin,LogedUser).

%RF6
% Descripcion: Predicado que realiza el cierre de sesión en un sistema.
% Dominio: System X NewSystem
% Metas Primarias: systemLogout
% Metas Secundarias: setLogin, getLogedUser, not
systemLogout(System,NewSystem):-
    not(getLogedUser(System,[])),
    setLogin(System,[],NewSystem).

%RF7
% Descripcion: Predicado que cambia el drive actual en un sistema.
% Dominio: System X Letter X NewSystem
% Metas Primarias: systemSwitchDrive
% Metas Secundarias: not, getLogedUser, string_lower, getDrives, existingLetter, string_concat, setCurrentPath
systemSwitchDrive(System,Letter,NewSystem):-
    not(getLogedUser(System, [])),
    string_lower(Letter,LetterMin),
    getDrives(System,Drives),
    existingLetter(LetterMin,Drives),
    string_concat(LetterMin,":/",NewPath),
    setCurrentPath(System,NewPath,NewSystem).

%RF8 mkdir
% Descripcion: Predicado que crea un nuevo directorio en el sistema actual.
% Dominio: System X FolderName X NewSystem
% Metas Primarias: systemMkdir
% Metas Secundarias: sysFolder, getFolderName, getFolderLocation, string_concat, getContent, append, setContent, getPaths, setPaths
systemMkdir(System,FolderName,NewSystem):-
    %Crea nuevo path
    string(FolderName),
    string_lower(FolderName,FolderNameMin),
    sysFolder(System,FolderNameMin,Folder), %crea folder
    %getFolderName(Folder,FolderNameMin),
    getFolderLocation(Folder,Location),
    string_concat(Location,FolderNameMin,NewPath0), %crea NewPath
    string_concat(NewPath0,"/",NewPath),

    %Agrega folder a contenido del sistema
    getContent(System,Content), %obtiene el contenido del system
    append(Content,[Folder],NewContent),  %agrega folder al contenido
    setContent(System,NewContent,NewSystem0), %setea new content

    %Del system resultando ahora debe agregar la nueva ruta a los paths del sistema
    getPaths(System,Paths), %obtiene paths del system
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system


%RF9 Cd
% Descripcion: Predicado que permite cambiar la ruta (path) donde se realizarán las próximas operaciones.
% Dominio: System X Input X NewSystem
% Metas Primarias: systemCd
% Metas Secundarias: ==, getCurrentPath, ruta_padre, setCurrentPath, string_length, ruta_raiz, sub_string, string_contains, string_concat, string_lower, not

% currentpath: "c:/folder1/folder11/"
% input: ".." 
% resultado: "c:/folder1/"
systemCd(System,Input,NewSystem):-
    %string_contains(Input,".."),
    Input == "..",
    getCurrentPath(System,CurrentPath),
    ruta_padre(CurrentPath,ParentPath),
    setCurrentPath(System,ParentPath,NewSystem).


% currentpath: "c:/folder1/"
% input: "/" 
% resultado: "c:/"
systemCd(System,Input,NewSystem):-
    %string_contains(Input,"/"),
    Input == "/",
    string_length(Input,1),
    getCurrentPath(System,CurrentPath),
    ruta_raiz(CurrentPath,Root),
    setCurrentPath(System,Root,NewSystem).


% currentpath: "c:/folder1/"
% input: "/folder2" 
% resultado: "c:/folder1/folder2/"
systemCd(System,FolderPath,NewSystem):-
    string_lower(FolderPath,FolderPathMin),
    sub_string(FolderPathMin, 0, 1, _, PrimerElemento),
    string_contains(PrimerElemento,"/"),
    sub_string(FolderPathMin, 1, _, 0, FormatPath),
    getCurrentPath(System,CurrentPath),
    ruta_raiz(CurrentPath,Root),
    string_concat(Root,FormatPath,NewPath00),
    string_concat(NewPath00,"/",NewPath0),
    %string_concat(NewPath0,"/",NewPath),
    setCurrentPath(System,NewPath0,NewSystem).


% currentpath: "c:/"
% input: "d:/folder1" (Si contiene : entonces uso este)
% resultado: "d:/folder1/"
systemCd(System,NewPath,NewSystem):-
    string_lower(NewPath,NewPath0),
    string_contains(NewPath,":"),
    setCurrentPath(System,NewPath0,NewSystem).


% currentpath: "c:/"
% folderpath: "Folder1/Folder11"
% resultado: "c:/folder1/folder11"
systemCd(System,FolderPath,NewSystem):-
    getPaths(System,Paths),
    not(string_length(FolderPath,1)),
    %string_contains(FolderPath,"/"),
    string_concat(FolderPath,"/",FolderPath0),
    getCurrentPath(System,CurrentPath),
    string_lower(FolderPath0,FolderPathMin),
    string_concat(CurrentPath,FolderPathMin,NewPath),
    member(NewPath,Paths),
    setCurrentPath(System,NewPath,NewSystem).

%RF10 ADDFILE
% Descripcion: Predicado que agrega un archivo al sistema.
% Dominio: System X File X NewSystem
% Metas Primarias: systemAddFile
% Metas Secundarias: sysFile, existingFile, getContent, findItem, removeItem, append, setContent, getFileName, getFileLocation, string_concat, getPaths, \+ member, setPaths
systemAddFile(System,File,NewSystem):-
    %Si ya existe un archivo con el mismo nombre, debe ser reemplazado su tipo y contenido 
    sysFile(System,File,SysFile),
    existingFile(System,SysFile), %como ya existe buscamos el old file en el contenido
    getContent(System,Content),
    findItem(SysFile,Content,OldItem),
    removeItem(OldItem,Content,NewContent0), %quitamos el old item
    append(NewContent0,[SysFile],NewContent),
    setContent(System,NewContent,NewSystem).

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
    \+ member(NewPath,Paths),
    append(Paths,[NewPath],NewPaths), %agrega NewPath a los paths
    setPaths(NewSystem0,NewPaths,NewSystem). %setea newpaths del system


%RF11 Del
% Descripcion: Predicado que elimina un archivo o carpeta del sistema tambien puede eliminar varios archivos con los comodines *
% Dominio: System X FileName X NewSystem
% Metas Primarias: systemDel
% Metas Secundarias: string_lower, string_contains, getContent, getCurrentPath, string_concat, getFolderContent, searchFolder, 
%     append, list_difference, getTrashcan, setTrashcan, setContent, primer_caracter, segundo_caracter, tercer_caracter, quitar_primer_caracter,
%     getFilesByExtFromFolder, stringEqual, getFilesFromFolder, searchItem, existingFile, select
 
% ELimina un FOLDER y su contenido
systemDel(System,FileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    \+ string_contains(FileNameMin,"."),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    string_concat(CurrentPath,FileNameMin,CurrentPath1),
    string_concat(CurrentPath1,"/",CurrentPath2),
    getFolderContent(CurrentPath2,Content,FilesToDelete),

    % Busco folder padre y lo agrego a files to delete
    searchFolder(Content,FileNameMin,Folder),
    append(FilesToDelete,[Folder],NewFilesToDelete),

    list_difference(Content,NewFilesToDelete,NewContent), %content sin los items a borrar

    getTrashcan(System,Trashcan),
    append(Trashcan,NewFilesToDelete,NewTrashcan),
    setTrashcan(System,NewTrashcan,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).

% "*.txt"
systemDel(System,FileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    primer_caracter(FileNameMin,"*"),
    segundo_caracter(FileNameMin,"."),
    \+ tercer_caracter(FileNameMin,"*"),
    quitar_primer_caracter(FileNameMin,NewFileName),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getFilesByExtFromFolder(CurrentPath,NewFileName,Content,FilesToDelete),
    list_difference(Content,FilesToDelete,NewContent),
    getTrashcan(System,Trashcan),
    append(Trashcan,FilesToDelete,NewTrashcan),
    setTrashcan(System,NewTrashcan,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).

% "*" || "*.*"
systemDel(System,FileName,NewSystem):-
    (stringEqual(FileName,"*") ; stringEqual(FileName,"*.*")),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getFilesFromFolder(CurrentPath,Content,FilesToDelete),
    list_difference(Content,FilesToDelete,NewContent),
    getTrashcan(System,Trashcan),
    append(Trashcan,FilesToDelete,NewTrashcan),
    setTrashcan(System,NewTrashcan,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).

% Elimina UN archivo
systemDel(System,FileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    getContent(System,Content),
    searchItem(Content,FileNameMin,File), %busca el file por el nombre pero falta:
    existingFile(System,File), %verificar si el file existe en la ruta actual del sistema
    %Si existe, asi que lo añado a la papelera
    getTrashcan(System,Trashcan),
    append(Trashcan,[File],NewTrashcan),
    setTrashcan(System,NewTrashcan,NewSystem0),
    % y lo quito del content del sistema
    select(File,Content,NewContent),
    setContent(NewSystem0,NewContent,NewSystem).



%RF12
% Descripcion: Predicado que realiza la copia de un archivo o carpeta en el sistema (permite uso de *)
% Dominio: System X FileName X TargetPath X NewSystem
% Metas Primarias: systemCopy
% Metas Secundarias: string_lower, \+ string_contains, getContent, getCurrentPath, getPaths, string_concat, 
%          getFolderContent, searchItem, setFolderLocation, maplist, getItemLocation, movePaths, mergeLists, 
%          append, setContent, setPaths, primer_caracter, segundo_caracter, tercer_caracter, quitar_primer_caracter,
%          getFilesByExtFromFolder, blankList, string_concat, setItemLocation, copyPaths, string_contains,
%          quitarAsterisco, copyPathsByPrefix, getFileByName, getFirst, existingFile, setFileLocation

% Copia un Folder y su CONTENIDO
systemCopy(System,FileName,TargetPath,NewSystem):-
    string_lower(TargetPath,TargetPathMin),
    string_lower(FileName,FileNameMin),
    \+ string_contains(FileNameMin,"."),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),

    string_concat(CurrentPath,FileNameMin,CurrentPath1),
    string_concat(CurrentPath1,"/",CurrentPath2),
    getFolderContent(CurrentPath2,Content,FilesToCopy),
    %CONTENT
    % Busco folder padre
    searchItem(Content,FileNameMin,Folder),
    % cambio ruta del folder padre por TargetPath
    setFolderLocation(Folder,TargetPathMin,NewFolder),
    % obtengo cada ruta de cada elemento de FilesToCopy
    maplist(getItemLocation,FilesToCopy,FilesLocations),
    % creo las nuevas rutas de los files copiados
    movePaths(CurrentPath,TargetPathMin,FileNameMin,FilesLocations,NewFileLocations),
    % seteo nuevas rutas
    (maplist(setItemLocation,FilesToCopy,NewFileLocations,NewFilesToCopy0)),
    % agrego New Folder a files to copy
    append(NewFilesToCopy0,[NewFolder],NewFilesToCopy), %ya tengo mis items copiados y con sus rutas cambiadas
    % ahora tengo que cambiar las rutas
    movePaths(CurrentPath,TargetPathMin,FileNameMin,Paths,NewPaths0),
    mergeLists(Paths,NewPaths0,NewPaths),
    % agregar mi nuevo contenido y rutas al sistema
    append(Content,NewFilesToCopy,NewContent),
    % seteo 
    setContent(System,NewContent,NewSystem0),
    setPaths(NewSystem0,NewPaths,NewSystem).


% Copia varios archivos por Extension "*.txt"
systemCopy(System,FileName,TargetPath,NewSystem):-
    string_lower(TargetPath,TargetPathMin),
    string_lower(FileName,FileNameMin),
    primer_caracter(FileNameMin,"*"),
    segundo_caracter(FileNameMin,"."),
    \+ tercer_caracter(FileNameMin,"*"),
    quitar_primer_caracter(FileNameMin,NewFileName),

    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),
    getFilesByExtFromFolder(CurrentPath,NewFileName,Content,FilesToCopy),

    %CONTENT
    % seteo ruta de destino a cada elemento
    blankList(FilesToCopy,FilesNames),
    maplist(string_concat(TargetPathMin),FilesNames,NewLocations),
    maplist(setItemLocation,FilesToCopy,NewLocations,NewFilesToCopy),

    % ahora tengo que cambiar las rutas
    copyPaths(CurrentPath,TargetPathMin,NewFileName,Paths,NewPaths),
    %mergeLists(Paths,NewPaths0,NewPaths),
    
    % agregar mi nuevo contenido y rutas al sistema
    append(Content,NewFilesToCopy,NewContent),
    % seteo 
    setContent(System,NewContent,NewSystem0),
    setPaths(NewSystem0,NewPaths,NewSystem).


% Copia varios archivos que empiecen por prefijo
systemCopy(System,FileName,TargetPath,NewSystem):-
    string_lower(TargetPath,TargetPathMin),
    string_lower(FileName,FileNameMin),
    string_contains(FileNameMin,"*"),
    quitarAsterisco(FileNameMin,NewFileName),

    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),
    getFilesByExtFromFolder(CurrentPath,NewFileName,Content,FilesToCopy),
    %CONTENT
    % seteo ruta de destino a cada elemento
    blankList(FilesToCopy,FilesNames),
    maplist(string_concat(TargetPathMin),FilesNames,NewLocations),
    maplist(setItemLocation,FilesToCopy,NewLocations,NewFilesToCopy),
    % ahora tengo que cambiar las rutas
    copyPathsByPrefix(CurrentPath,TargetPathMin,NewFileName,Paths,NewPaths),
    % agregar mi nuevo contenido y rutas al sistema
    append(Content,NewFilesToCopy,NewContent),
    % seteo 
    setContent(System,NewContent,NewSystem0),
    setPaths(NewSystem0,NewPaths,NewSystem).

% Copia UN Archivo
systemCopy(System,FileName,TargetPath,NewSystem):-
    string_lower(TargetPath,TargetPathMin),
    string_lower(FileName,FileNameMin),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),

    getFileByName(CurrentPath,FileNameMin,Content,CopiedFileList), %obtiene item
    getFirst(CopiedFileList,CopiedFile),

    existingFile(System,CopiedFile), %verifica que ese item exista en la ruta actual
    setFileLocation(CopiedFile,TargetPathMin,NewFile), %cambia ruta del item

    string_concat(TargetPathMin,FileNameMin,NewPath),

    append(Content,[NewFile],NewContent),
    append(Paths,[NewPath],NewPaths),

    setContent(System,NewContent,NewSystem0),
    setPaths(NewSystem0,NewPaths,NewSystem).

%RF13 MOVE
% Descripcion: Predicado que mueve un archivo o carpeta a una nueva ruta en el sistema (Permite uso de comodin *)
% Dominio: System X FileName X TargetPath X NewSystem
% Metas Primarias: systemMove
% Metas Secundarias: string_lower, \+ string_contains, getContent, searchItem, existingItem, systemCopy,
%               systemSupr, string_contains, getCurrentPath, existingFile, setCurrentPath, systemAddFile

% MUEVE UN FOLDER Y SU CONTENIDO A NUEVA RUTA (incluye subdirectorios y contenidos de estos)
systemMove(System,FileName,TargetPath,NewSystem):-
    string_lower(FileName,FileNameMin),
    \+ string_contains(FileNameMin,"."),
    getContent(System,Content),
    searchItem(Content,FileNameMin,Item),
    existingItem(System,Item),
    systemCopy(System,FileNameMin,TargetPath,NewSystem0),
    systemSupr(NewSystem0,FileNameMin,NewSystem).

% MUEVE UN FILE A NUEVA RUTA (SI YA EXISTE EN NUEVA RUTA ES SOBREESCRITO)
systemMove(System,FileName,TargetPath,NewSystem):-
    string_lower(FileName,FileNameMin),
    string_contains(FileNameMin,"."),
    getCurrentPath(System,CurrentPath),
    getContent(System,Content),

    searchItem(Content,FileNameMin,Item),
    existingFile(System,Item),

    systemSupr(System,FileNameMin,TempSystem0),
    setCurrentPath(TempSystem0,TargetPath,TempSystem1),

    systemAddFile(TempSystem1,Item,TempSystem2),
    setCurrentPath(TempSystem2,CurrentPath,NewSystem).

% RF14 RENAME
% Descripcion: Predicado que realiza renombre un archivo o carpeta en el sistema.
% Dominio: System X FileName X NewFileName X NewSystem
% Metas Primarias: systemRen
% Metas Secundarias: string_lower, \+ string_contains, getContent, getPaths, searchItem, 
%        existingItem, maplist, replace_string, getItemName, setItemName, getItemLocation,
%        setItemLocation, setPaths, setContent, string_contains, getCurrentPath, setFileName,
%        searchItem, select, append, string_concat

% RENOMBRA UN FOLDER
systemRen(System,FileName,NewFileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    string_lower(NewFileName,NewFileNameMin),
    \+ string_contains(FileNameMin,"."),
    \+ string_contains(NewFileNameMin,"."),
    getContent(System,Content),
    getPaths(System,Paths),

    searchItem(Content,FileNameMin,Item),
    existingItem(System,Item),

    maplist(replace_string(FileNameMin,NewFileNameMin),Paths,NewPaths),
    maplist(getItemName,Content,ItemsNames),
    maplist(replace_string(FileNameMin,NewFileNameMin),ItemsNames,NewItemsNames),
    maplist(setItemName,Content,NewItemsNames,NewContent0),

    maplist(getItemLocation,Content,ItemsLocations),
    maplist(replace_string(FileNameMin,NewFileNameMin),ItemsLocations,NewItemsLocations),
    maplist(setItemLocation,NewContent0,NewItemsLocations,NewContent),

    setPaths(System,NewPaths,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).

% renombra UN archivo
systemRen(System,FileName,NewFileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    string_lower(NewFileName,NewFileNameMin),
    string_contains(FileNameMin,"."),
    string_contains(NewFileNameMin,"."),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),
    % busca file en el contenido
    searchItem(Content,FileNameMin,Item),
    existingFile(System,Item),
    % crea nuevo file renombrado
    setFileName(Item,NewFileNameMin,NewItem),
    % verifica que nuevo file NO exista en current path
    \+ searchItem(Content,NewFileNameMin,_),
    % elimina item original del content
    select(Item,Content,NewContent0),
    % agrega item renombrado al content sin item original
    append(NewContent0,[NewItem],NewContent),
    % crea ruta del antiguo item
    string_concat(CurrentPath,FileNameMin,OldPath),
    % crea ruta del nuevo item
    string_concat(CurrentPath,NewFileNameMin,NewPath),
    % elimina ruta de los paths antiguos
    select(OldPath,Paths,NewPaths0),
    % agrega nueva ruta  a los paths sin el path antiguo
    append(NewPaths0,[NewPath],NewPaths),
    % setea paths y content
    setContent(System,NewContent,NewSystem0),
    setPaths(NewSystem0,NewPaths,NewSystem).


%RF15 
% Descripcion: Predicado para listar el contenido de un directorio específico o de toda una ruta, lo que se determina mediante parámetros.
% Dominio: System X Parametro X Output
% Metas Primarias: systemDir
% Metas Secundarias: getContent, getCurrentPath, getFilesFromFolder, maplist, getItemName, join_strings, getFolderContent, msort.

%Lista el contenido del directorio actual
systemDir(System,[],Output):-
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getFilesFromFolder(CurrentPath,Content,ItemsToShow),

    maplist(getItemName,ItemsToShow,NamesToShow),
    join_strings(NamesToShow,Output).

%lista el contenido del directorio actual y todos los subdirectorios
systemDir(System,["/s"],Output):-
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getFolderContent(CurrentPath,Content,ItemsToShow),

    maplist(getItemName,ItemsToShow,NamesToShow),
    join_strings(NamesToShow,Output).

%lista el contenido del directorio actual en orden alfabético ascendente
systemDir(System, ["/o N"], Output):-
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getFilesFromFolder(CurrentPath,Content,ItemsToShow),
    maplist(getItemName,ItemsToShow,NamesToShow),
    msort(NamesToShow,SortedNames),
    join_strings(SortedNames,Output).

% ofrece ayuda sobre los posibles parámetros que se pueden usar
systemDir(_, ["/?"], "\n\t### SYSTEMDIR PARAMETERS ###\n\nParametros que puedes usar:\n1. [] : Lista el contenido del directorio actual\n2. ['/s'] : Lista el contenido del directorio actual y todos los subdirectorios\n3. ['/o N'] : lista el contenido del directorio actual en orden alfabetico ascendente\n4. [\"/?\"] : ofrece ayuda sobre los posibles parámetros que se pueden usar\n").


% -----------------------FIN REQUERIMIENTOS FUNCIONALES---------------------------


% --------------------------Selectores y Modificadores----------------------------

% creador de un Folder con metadata del sistema
sysFolder(System,FolderName,NewFolder):-
    not(getLogedUser(System, [])),
    string_lower(FolderName,FolderNameMin),
    getDate(System,CreateDate),
    getDate(System,ModDate),
    getCurrentPath(System,Location),
    getLogedUser(System,Creator),
    folder(FolderNameMin,CreateDate,ModDate,Location,Creator,NewFolder).

sysFile(System,File,NewFile):-
    not(getLogedUser(System, [])),
    getFileName(File,FileName),
    getFileText(File,Text),
    getDate(System,CreateDate),
    getDate(System,ModDate),
    getCurrentPath(System,Location),
    getLogedUser(System,Creator),
    file(FileName,CreateDate,ModDate,Location,Creator,Text,NewFile).

getItemName(Item,ItemName):-
    getFileName(Item,ItemName).

getItemName(Item,ItemName):-
    getFolderName(Item,ItemName).

setItemName(Item,ItemName,NewItem):-
    setFileName(Item,ItemName,NewItem).

setItemName(Item,ItemName,NewItem):-
    setFolderName(Item,ItemName,NewItem).

searchItem([Item|_],ItemName,Item):-
    getItemName(Item,ItemName),!.

searchItem([_|Items],ItemName,Item):-
    searchItem(Items,ItemName,Item).

% Caso base: el primer elemento de la primera sublista es el elemento que estamos buscando.
findItem([Element|_], [[Element|Rest]|_], [Element|Rest]).

% Caso recursivo: el primer elemento de la primera sublista no es el que estamos buscando, por lo que buscamos en las sublistas restantes.
findItem(Element, [_|T], Result) :-
    findItem(Element, T, Result).

removeItem(Item,List,NewList):-
    select(Item,List,NewList).

% Caso base: la lista de listas está vacía, por lo que la lista de primeros elementos también está vacía.
getItemsNames([], []).
% Caso recursivo: tomar el primer elemento (H1) de la primera sublista (H) y recursivamente obtener
% los primeros elementos de las sublistas restantes (T).
getItemsNames([[H1|_]|T], [H1|Rest]) :-
    getItemsNames(T, Rest).

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

getTrashcan(System,Trashcan):-
    makesystem(_,_,_,_,_,_,Trashcan,_,_,System).

getPaths(System,Paths):-
    makesystem(_,_,_,_,_,_,_,Paths,_,System).

getContent(System,Content):-
    makesystem(_,_,_,_,_,_,_,_,Content,System).

setDrives(System, Drives, NewSystem) :-

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

setTrashcan(System, NewTrashcan, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, _, Paths,  Content,System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, NewTrashcan, Paths,  Content,NewSystem).

setPaths(System, NewPaths, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, _,  Content,System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, NewPaths,  Content,NewSystem).

setContent(System, NewContent, NewSystem) :-
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths,  _,System),
    makesystem(SystemName,SystemDate, LogedUser, CurrentPath, Users, Drives, Trashcan, Paths,  NewContent,NewSystem).

% -----------------------Predicados Auxiliares---------------------------

string_contains(String, SubString):-
    sub_string(String, _, _, _, SubString).

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
    eliminar_vacio_y_primero(ReversedPathList, NewReversedPathList),
    reverse(NewReversedPathList, NewPathList),
    string_join(NewPathList, "/", PartialParentPath),
    string_concat(PartialParentPath, "/", ParentPath).

eliminar_vacio_y_primero([""|T], T2) :-
    eliminar_primero(T, T2).
eliminar_vacio_y_primero(T, T2) :-
    eliminar_primero(T, T2).

ruta_raiz(Path, Root):-
    split_string(Path, "/", "", PathList),
    getFirst(PathList,Root0),
    string_concat(Root0,"/",Root).

stringEqual(String1, String2):-
    String1 == String2.

existingFile(System,Item):-
    getFileLocation(Item,Location),
    getCurrentPath(System,CurrentPath),
    stringEqual(Location,CurrentPath).

existingItem(System,Item):-
    getFolderLocation(Item,Location),
    getCurrentPath(System,CurrentPath),
    stringEqual(Location,CurrentPath).

% FUNCIONES PARA SELECCIONAR VARIOS ITEMS

% Tipos de selecciones %

% "c/:folder1/folder2/"

% T1: Selecciona todo los archivos que tiene UN folder dado un path ; Selecciona todos los archivos del folder2
% T2: Selecciona todos los items que tienen como padre a cierto folder dado un path ; Selecciona todos los items cuya location contiene a "c/:folder1/folder2/"
% T3: Selecciona un archivo dado su nombre ; Selecciona archivo dentro de folder2

% para eliminar UN archivo searchItem+removeItem
% para eliminar archivos "*" "*.*" estoy en UN folder y los borro desde ahi TODOS, solo archivos ---> Seleccion T1
% para eliminar un folder yo borro toda su rama inclusive

% para copiar un folder yo copio toda su rama inclusive y borro 
% para copiar un file lo añado en nueva ruta y luego lo borro (addfile + del)

% para mover un folder yo muevo toda su rama inclusive
% para mover un file lo añado en nueva ruta y luego lo borro (addfile + del)

% DIFFERENCE BEETWEN LISTS

% Caso base: Si la primera lista está vacía, entonces no hay nada que eliminar, y el resultado es una lista vacía.
list_difference([], _, []).

% Caso recursivo: Si la cabeza de la primera lista (H) también está en la segunda lista (FilesToDelete), entonces la eliminamos y continuamos con la cola (T) de la primera lista.
list_difference([H|T], FilesToDelete, NewContent) :-
    member(H, FilesToDelete), !,
    list_difference(T, FilesToDelete, NewContent).

% Caso recursivo: Si la cabeza de la primera lista (H) no está en la segunda lista (FilesToDelete), entonces la mantenemos y continuamos con la cola (T) de la primera lista.
list_difference([H|T], FilesToDelete, [H|NewContent]) :-
    list_difference(T, FilesToDelete, NewContent).


% GET FILES BY NAME
getFileByName(_,_, [], []).

getFileByName(CurrentPath,FileName, [Item|Items], [Item|PathItems]):-
    getFileLocation(Item,CurrentPath),
    getFileName(Item,FileName),
    getFileByName(CurrentPath,FileName,Items,PathItems).

getFileByName(CurrentPath,FileName, [_|Items], PathItems):-
    getFileByName(CurrentPath,FileName, Items, PathItems).


% GET ALL FILES FROM FOLDER
getFilesFromFolder(_, [], []).

getFilesFromFolder(CurrentPath, [Item|Items], [Item|PathItems]):-
    getFileLocation(Item,CurrentPath),
    getFilesFromFolder(CurrentPath,Items,PathItems).

getFilesFromFolder(CurrentPath, [_|Items], PathItems):-
    getFilesFromFolder(CurrentPath, Items, PathItems).


% GET ALL CONTENT FROM FOLDER (Subfolders and files inside them)
searchFolder([Item|_],ItemName,Item):-
    getFolderName(Item,ItemName),!.

searchFolder([_|Items],ItemName,Item):-
    searchFolder(Items,ItemName,Item).
%%
getItemLocation(Item,Location):-
    getFileLocation(Item,Location).

getItemLocation(Item,Location):-
    getFolderLocation(Item,Location).
%%
getFolderContent(_, [], []).

getFolderContent(CurrentPath, [Item|Items], [Item|PathItems]):-
    getItemLocation(Item,ItemLocation),
    string_contains(ItemLocation,CurrentPath),
    getFolderContent(CurrentPath,Items,PathItems).

getFolderContent(CurrentPath, [_|Items], PathItems):-
    getFolderContent(CurrentPath, Items, PathItems).

setItemLocation(File, NewLocation, NewFile):-
    setFileLocation(File, NewLocation, NewFile). 

setItemLocation(File, NewLocation, NewFile):-
    setFolderLocation(File, NewLocation, NewFile). 

formatItemName(String, Result) :-
    string_contains(String, "."),
    Result = String.

formatItemName(String, Result) :-
    \+ string_contains(String, "."),
    string_concat(String, "/", Result).

% GET ALL FILES BY EXTENSION FROM FOLDER
primer_caracter(String, PrimerCaracter):-
    sub_string(String, 0, 1, _, PrimerCaracter).

segundo_caracter(String, SegundoCaracter) :-
    sub_string(String, 1, 1, _, SegundoCaracter).


tercer_caracter(String, TercerCaracter):-
    sub_string(String, 2, 1, _, TercerCaracter).

quitar_primer_caracter(String, Subcadena) :-
    sub_string(String, 1, _, 0, Subcadena).

getFilesByExtFromFolder(_,_, [], []).

getFilesByExtFromFolder(CurrentPath,Ext, [Item|Items], [Item|PathItems]):-
    getFileLocation(Item,CurrentPath),
    getFileName(Item,FileName),
    string_contains(FileName,Ext),
    getFilesByExtFromFolder(CurrentPath,Ext,Items,PathItems).

getFilesByExtFromFolder(CurrentPath,Ext, [_|Items], PathItems):-
    getFilesByExtFromFolder(CurrentPath,Ext, Items, PathItems).


% mueve LAS RUTAS DE UN FOLDER y sus subdirectorios (Modifica. NO agrega nuevas rutas)
% predicado auxiliar para copiar un path individual
movePath(PathToCopy, CurrentPath, TargetPath, Path, NewPath) :-
    string_contains(Path, PathToCopy),
    string_concat(CurrentPath, Suffix, Path),
    string_concat(TargetPath, Suffix, NewPath).
    
movePath(_, _, _, Path, Path).
% predicado principal para copiar todos los paths
movePaths(CurrentPath, TargetPath, ItemName, Paths, NewPaths) :-
    string_concat(CurrentPath, ItemName, Path),
    string_concat(Path, "/", PathToCopy),
    maplist(movePath(PathToCopy, CurrentPath, TargetPath), Paths, NewPaths).

% COPYPATHS
copyItem(CurrentPath, TargetPath, ItemName, Path, NewPath) :-
    string_contains(Path, ItemName),
    isFilePath(CurrentPath,Path),
    string_concat(CurrentPath, Suffix, Path),
    string_concat(TargetPath, Suffix, NewPath).
   
copyItem(_, _, _, Path, Path).

copyPaths(CurrentPath, TargetPath, ItemName, Paths, NewPaths) :-
    maplist(copyItem(CurrentPath, TargetPath, ItemName), Paths, TempNewPaths),
    mergeLists(Paths, TempNewPaths, NewPaths).

% dividir una cadena en dos partes basándonos en un prefijo
splitOnPrefix(String, Prefix, Before, After) :-
    sub_string(String, 0, Length, _, Prefix),
    sub_string(String, Length, _, 0, After),
    Before = Prefix.

% comprobar si B es un archivo en la ruta A
isFilePath(A, B) :-
    splitOnPrefix(B, A, _, After),
    \+ sub_string(After, _, _, _, "/").


% COPYPATHS
copyItemByPrefix(CurrentPath, TargetPath, ItemName, Path, NewPath) :-
    %string_contains(Path, ItemName),
    %isFilePath(CurrentPath,Path),
    containsName(CurrentPath,ItemName,Path),
    string_concat(CurrentPath, Suffix, Path),
    string_concat(TargetPath, Suffix, NewPath).
   
copyItemByPrefix(_, _, _, Path, Path).

copyPathsByPrefix(CurrentPath, TargetPath, ItemName, Paths, NewPaths) :-
    maplist(copyItemByPrefix(CurrentPath, TargetPath, ItemName), Paths, TempNewPaths),
    mergeLists(Paths, TempNewPaths, NewPaths).

containsName(X, A, B) :-
    % Divide B en dos partes: antes de la última "/" (B1) y después de la última "/" (B2)
    split_string(B, "/", "", L),
    reverse(L, [Last|Rest]),
    reverse(Rest, RevRest),
    atomics_to_string(RevRest, "/", B1),
    atomics_to_string([B1, ""], "/", B1Final),

    % Verifica que B1 sea igual a X y que B2 contenga a A
    X = B1Final,
    sub_string(Last, _, _, _, A).

quitarAsterisco(String, SubString) :-
    sub_string(String, 0, _, 1, SubString),
    string_concat(SubString, "*", String).

% Caso base: para una lista vacía, la lista de salida también es vacía
blankList([], []).

% Caso recursivo: por cada elemento de la lista de entrada, añadimos un "" a la lista de salida
blankList([_|T], [""|T2]) :-
    blankList(T, T2).

remove_duplicates([], []).
remove_duplicates([Cabeza | Cola], ListaSinDuplicados) :- 
    member(Cabeza, Cola), 
    remove_duplicates(Cola, ListaSinDuplicados).
remove_duplicates([Cabeza | Cola], [Cabeza | ListaSinDuplicados]) :- 
    \+ member(Cabeza, Cola), 
    remove_duplicates(Cola, ListaSinDuplicados).

mergeLists(Lista1, Lista2, ResultadoFinal) :-
    append(Lista1, Lista2, ResultadoAppend),
    remove_duplicates(ResultadoAppend, ResultadoFinal).

/* writeList(List) :-
    forall(member(Item, List), writeln(Item)). */

% ELimina un FOLDER y su contenido y no agrega a Trashcan
systemSupr(System,FileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    \+ string_contains(FileNameMin,"."),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),
    string_concat(CurrentPath,FileNameMin,CurrentPath1),
    string_concat(CurrentPath1,"/",CurrentPath2),
    getFolderContent(CurrentPath2,Content,FilesToDelete),

    % Busco folder padre y lo agrego a files to delete
    searchFolder(Content,FileNameMin,Folder),
    append(FilesToDelete,[Folder],NewFilesToDelete),
    list_difference(Content,NewFilesToDelete,NewContent), %content sin los items a borrar

    % Construyo rutas a borrar FilesToDeleteLocation+ItemName
    maplist(getItemName,NewFilesToDelete,FilesToDeleteNames0),
    maplist(formatItemName,FilesToDeleteNames0,FilesToDeleteNames),
    maplist(getItemLocation,NewFilesToDelete,FilesToDeleteLocation),
    maplist(string_concat,FilesToDeleteLocation,FilesToDeleteNames,FilesToDeletePaths),
    % elimino rutas de los paths
    list_difference(Paths,FilesToDeletePaths,NewPaths),
    % seteo contenido sin los archivos eliminados y rutas sin rutas eliminadas
    setPaths(System,NewPaths,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).

% ELIMINA UN ARCHIVO SIN ENVIARLO A PAPELERA
systemSupr(System,FileName,NewSystem):-
    string_lower(FileName,FileNameMin),
    getContent(System,Content),
    getCurrentPath(System,CurrentPath),
    getPaths(System,Paths),
    searchItem(Content,FileNameMin,File), %busca el file por el nombre pero falta:
    existingFile(System,File), %verificar si el file existe en la ruta actual del sistema
    % lo quito del content del sistema
    select(File,Content,NewContent),
    % quito su ruta del path del sistema
    string_concat(CurrentPath,FileNameMin,PathToDelete),
    select(PathToDelete,Paths,NewPaths),
    setPaths(System,NewPaths,NewSystem0),
    setContent(NewSystem0,NewContent,NewSystem).


replace_string(A, B, C, Result) :-
    sub_string(C, _, _, _, "."),
    split_string(C, "/", "/", Parts),
    maplist(replace_part(A, B), Parts, NewParts),
    atomic_list_concat(NewParts, "/", Result).

replace_string(A, B, C, Result) :-
    \+ sub_string(C, _, _, _, "."),
    split_string(C, "/", "/", Parts),
    maplist(replace_part(A, B), Parts, NewParts),
    atomic_list_concat(NewParts, "/", TempResult),
    string_concat(TempResult, "/", Result).


replace_part(A, B, A, B) :- !.
replace_part(_, _, X, X).

join_strings(List, String) :-
    atomic_list_concat(List, "\n", String).

/* %systemFormat(S, “C”, “newOS”, S2)
systemFormat(System,Letter,NewDriveName,NewSystem):-
    getDrives(System,Drives),
    searchDrive(Drives,Letter,Drive),
    setDriveName(Drive,NewDriveName,NewDrive),
    select(Drive,Drives,NewDrives0),
    append(NewDrives0,[NewDrive],NewDrives),
    string_concat(Letter,":",Aux),
    string_concat(Aux,"/",DrivePath),
    setPaths(System,[DrivePath],NewSystem0),
    setCurrentPath(NewSystem0,DrivePath,NewSystem1),
    setDrives(NewSystem1,NewDrives,NewSystem2),
    setContent(NewSystem2,[],NewSystem).

searchDrive([],_,[]).

searchDrive([Item|_],ItemName,Item):-
    getLetter(Item,ItemName),!.

searchDrive([_|Items],ItemName,Item):-
    searchDrive(Items,ItemName,Item).

ultimos_cinco(_, Ultimos) :-
    length(Ultimos, 5).

ultimos_cinco(Lista, UltimosCinco) :-
    append(_, Ultimos, Lista),
    ultimos_cinco(Ultimos, UltimosCinco).

string_concat_reverse(A, B, R) :-
    string_concat(B, A, R).
 */

%[["folder1", '2023-06-11 01:51:33', '2023-06-11 01:51:33', "c:/", ["user1"]], ["folder2", '2023-06-11 01:51:33', '2023-06-11 01:51:33', "c:/", ["user1"]],["folder11", '2023-06-11 01:51:33', '2023-06-11 01:51:33', "c:/folder1/", ["user1"]]