% main.pl - Interact with user
% to start, ?- consult('main.pl').
% then, ?- start.

% Import necessary files
:- consult('movies.pl').
:- consult('utils.pl').
:- consult('api.pl').

% interact with user
start :-
    % prompt user for name to load their preference
    write('This is a movie recommender!\n'),
    write('To get started, try typing "search_movies(Actor, Year, Genre))\n'),

    % other queries? search by genre/ actor/ year only?

    % or could get users input actor, year, genre one by one?


    % read query and execute, execute-query in utils.pl
    read_line_to_string(user_input, Query),
    execute_query(Query),

    % exit
    write('Thankyou for using this program!').

