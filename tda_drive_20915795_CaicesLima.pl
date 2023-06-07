:- module(tda_drive_209157950_CaicesLima, [drive/4, getLetter/2, addDriveToDrives/3]).

% TDA Drive
drive(Letter, Name, Cap,[Letter, Name, Cap]).

/*
drive(Letter, Name, Cap,[LetterMin, NameMin, Cap]):-
    string_downcase(Letter,LetterMin),
    string_downcase(Name,NameMin).
*/
getLetter(Drive,Letter):-
    drive(Letter,_,_,Drive).

addDriveToDrives(Drives,NewDrive,[NewDrive|Drives]).