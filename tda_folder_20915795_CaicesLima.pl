:- module(tda_folder_20915795_CaicesLima, [folder/6]).

% TDA Folder
%folder/5
folder(FolderName,CreateDate,ModDate,Location,Creator,[FolderNameMin,CreateDate,ModDate,LocationMin,Creator]):-
    string_lower(FolderName,FolderNameMin),
    string_lower(Location,LocationMin).
