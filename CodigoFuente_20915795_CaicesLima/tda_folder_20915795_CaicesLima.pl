
:- module(tda_folder_20915795_CaicesLima, [folder/6,getFolderLocation/2,getFolderName/2,setFolderLocation/3,setFolderName/3]).

% TDA Folder
% Descripcion: Predicado que define un folder. 
% Dominio: FolderName,CreateDate,ModDate,Location,Creator
% Metas Primarias: folder

folder(FolderName,CreateDate,ModDate,Location,Creator,[FolderName,CreateDate,ModDate,Location,Creator]).


makefolder(FolderName,CreateDate,ModDate,Location,Creator,[FolderName,CreateDate,ModDate,Location,Creator]).

% Getter para FolderName
getFolderName(Folder, FolderName) :-
    makefolder(FolderName, _, _, _, _, Folder).

% Setter para FolderName
setFolderName(Folder, NewFolderName, NewFolder) :-
    makefolder(_, CreateDate, ModDate, Location, Creator, Folder),
    makefolder(NewFolderName, CreateDate, ModDate, Location, Creator, NewFolder).

% Getter para CreateDate
getCreateDate(Folder, CreateDate) :-
    makefolder(_, CreateDate, _, _, _, Folder).

% Setter para CreateDate
setCreateDate(Folder, NewCreateDate, NewFolder) :-
    makefolder(FolderName, _, ModDate, Location, Creator, Folder),
    makefolder(FolderName, NewCreateDate, ModDate, Location, Creator, NewFolder).

% Getter para ModDate
getModDate(Folder, ModDate) :-
    makefolder(_, _, ModDate, _, _, Folder).

% Setter para ModDate
setModDate(Folder, NewModDate, NewFolder) :-
    makefolder(FolderName, CreateDate, _, Location, Creator, Folder),
    makefolder(FolderName, CreateDate, NewModDate, Location, Creator, NewFolder).

% Getter para Location
getFolderLocation(Folder, Location) :-
    makefolder(_, _, _, Location, _, Folder).

% Setter para Location
setFolderLocation(Folder, NewLocation, NewFolder) :-
    makefolder(FolderName, CreateDate, ModDate, _, Creator, Folder),
    makefolder(FolderName, CreateDate, ModDate, NewLocation, Creator, NewFolder).

% Getter para Creator
getCreator(Folder, Creator) :-
    makefolder(_, _, _, _, Creator, Folder).

% Setter para Creator
setCreator(Folder, NewCreator, NewFolder) :-
    makefolder(FolderName, CreateDate, ModDate, Location, _, Folder),
    makefolder(FolderName, CreateDate, ModDate, Location, NewCreator, NewFolder).
