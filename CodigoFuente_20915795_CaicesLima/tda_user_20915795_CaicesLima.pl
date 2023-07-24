:- module(tda_user_20915795_CaicesLima, [user/2]).
% TDA User
% Descripcion: Predicado que define un folder. 
% Dominio: UserName
% Metas Primarias: folder

user(UserName,[UserNameMin]):-
 string_lower(UserName,UserNameMin).
