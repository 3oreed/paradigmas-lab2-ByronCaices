
:- module(tda_folder_20915795_CaicesLima, [folder/6,getLocation/2,getFolderName/2]).

% TDA Folder
%folder/6
/* folder(FolderName,CreateDate,ModDate,Location,Creator,[FolderNameMin,CreateDate,ModDate,LocationMin,Creator]):-
    string_lower(FolderName,FolderNameMin),
    string_lower(Location,LocationMin). */

folder(FolderName,CreateDate,ModDate,Location,Creator,[FolderName,CreateDate,ModDate,Location,Creator]).

getLocation(Folder,Location):-
    folder(_,_,_,Location,_,Folder).

getFolderName(Folder,Name):-
    folder(Name,_,_,_,_,Folder).