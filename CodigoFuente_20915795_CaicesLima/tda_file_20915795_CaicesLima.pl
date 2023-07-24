
:- module(tda_file_20915795_CaicesLima, [file/7,file/3,getFileLocation/2,getFileName/2,getFileText/2,setFileLocation/3,setFileName/3]).

% TDA File
%File/6
/* File(FileName,CreateDate,ModDate,Location,Creator,[FileNameMin,CreateDate,ModDate,LocationMin,Creator]):-
    string_lower(FileName,FileNameMin),
    string_lower(Location,LocationMin). */


file(FileName,CreateDate,ModDate,Location,Creator,Text,[FileName,CreateDate,ModDate,Location,Creator,Text]).

file(FileName,Text,File):-
    string(FileName),
    string_lower(FileName,FileNameMin),
    file(FileNameMin,"","","",[],Text,File).


/* getFileLocation(File,Location):-
    file(_,_,_,Location,_,_,File).

getFileName(File,Name):-
    file(Name,_,_,_,_,_,File).

getText(File,Text):-
    file(_,_,_,_,_,Text,File). */

    % Getter para FileName
getFileName(File, FileName) :-
    file(FileName, _, _, _, _, _, File).

% Setter para FileName
setFileName(File, NewFileName, NewFile) :-
    file(_, CreateDate, ModDate, Location, Creator, Text, File),
    file(NewFileName, CreateDate, ModDate, Location, Creator, Text, NewFile).

% Getter para CreateDate
getFileCreateDate(File, CreateDate) :-
    file(_, CreateDate, _, _, _, _, File).

% Setter para CreateDate
setFileCreateDate(File, NewCreateDate, NewFile) :-
    file(FileName, _, ModDate, Location, Creator, Text, File),
    file(FileName, NewCreateDate, ModDate, Location, Creator, Text, NewFile).

% Getter para ModDate
getFileModDate(File, ModDate) :-
    file(_, _, ModDate, _, _, _, File).

% Setter para ModDate
setFileModDate(File, NewModDate, NewFile) :-
    file(FileName, CreateDate, _, Location, Creator, Text, File),
    file(FileName, CreateDate, NewModDate, Location, Creator, Text, NewFile).

% Getter para Location
getFileLocation(File, Location) :-
    file(_, _, _, Location, _, _, File).

% Setter para Location
setFileLocation(File, NewLocation, NewFile) :-
    file(FileName, CreateDate, ModDate, _, Creator, Text, File),
    file(FileName, CreateDate, ModDate, NewLocation, Creator, Text, NewFile).

% Getter para Creator
getFileCreator(File, Creator) :-
    file(_, _, _, _, Creator, _, File).

% Setter para Creator
setFileCreator(File, NewCreator, NewFile) :-
    file(FileName, CreateDate, ModDate, Location, _, Text, File),
    file(FileName, CreateDate, ModDate, Location, NewCreator, Text, NewFile).

% Getter para Text
getFileText(File, Text) :-
    file(_, _, _, _, _, Text, File).

% Setter para Text
setFileText(File, NewText, NewFile) :-
    file(FileName, CreateDate, ModDate, Location, Creator, _, File),
    file(FileName, CreateDate, ModDate, Location, Creator, NewText, NewFile).
