:- module(tda_drive_20915795_CaicesLima, [drive/4, getLetter/2, addDriveToDrives/3, existingLetter/2]).

% TDA Drive
% Descripcion: Predicado que define un drive. 
% Dominio: Letra X Nombre X Capacidad X Drive
% Metas Primarias: drive
drive(Letter, Name, Cap,[LetterMin, NameMin, Cap]):-
    string_length(Letter,1),
    string_lower(Letter,LetterMin),
    string_lower(Name,NameMin).

%drive(Letter, Name, Cap,[Letter, Name, Cap]).

getLetter(Drive,Letter):-
    drive(Letter,_,_,Drive).

setDriveName(Drive, NewDriveName, NewDrive) :-
    drive(Letter, _, Cap, Drive),
    string_lower(NewDriveName, NewNameMin),
    drive(Letter, NewNameMin, Cap, NewDrive).


getDriveName(Drive, DriveName) :-
    drive(_, DriveName, _, _, _, Drive).


addDriveToDrives(Drives,NewDrive,[NewDrive|Drives]).

existingLetter(Letter,[Drive|_]):-
    member(Letter,Drive).

existingLetter(Letter,[_|Drives]):-
    existingLetter(Letter,Drives).

%ttt