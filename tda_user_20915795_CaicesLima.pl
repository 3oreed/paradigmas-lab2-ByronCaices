:- module(tda_user_20915795_CaicesLima, [user/2]).

user(UserName,[UserNameMin]):-
 string_lower(UserName,UserNameMin).
