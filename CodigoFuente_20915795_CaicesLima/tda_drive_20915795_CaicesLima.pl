:- module(tda_drive_20915795_CaicesLima, [drive/4, getLetter/2, addDriveToDrives/3, existingLetter/2]).

% TDA Drive
%drive(Letter, Name, Cap,[Letter, Name, Cap]).


drive(Letter, Name, Cap,[LetterMin, NameMin, Cap]):-
    string_length(Letter,1),
    string_lower(Letter,LetterMin),
    string_lower(Name,NameMin).

getLetter(Drive,Letter):-
    drive(Letter,_,_,Drive).

addDriveToDrives(Drives,NewDrive,[NewDrive|Drives]).

existingLetter(Letter,[Drive|_]):-
    member(Letter,Drive).

existingLetter(Letter,[_|Drives]):-
    existingLetter(Letter,Drives).

%ttt