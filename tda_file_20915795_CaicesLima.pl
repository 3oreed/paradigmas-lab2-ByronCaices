
:- module(tda_file_20915795_CaicesLima, [file/7,file/3,getFileLocation/2,getFileName/2,getText/2]).

% TDA File
%File/6
/* File(FileName,CreateDate,ModDate,Location,Creator,[FileNameMin,CreateDate,ModDate,LocationMin,Creator]):-
    string_lower(FileName,FileNameMin),
    string_lower(Location,LocationMin). */


file(FileName,CreateDate,ModDate,Location,Creator,Text,[FileName,CreateDate,ModDate,Location,Creator,Text]).

file(FileName,Text,File):-
    string_lower(FileName,FileNameMin),
    file(FileNameMin,"","","",[],Text,File).


getFileLocation(File,Location):-
    file(_,_,_,Location,_,_,File).

getFileName(File,Name):-
    file(Name,_,_,_,_,_,File).

getText(File,Text):-
    file(_,_,_,_,_,Text,File).