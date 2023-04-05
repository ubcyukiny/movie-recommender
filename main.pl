% main.pl - Interact with user

% Import necessary files
:- consult('movies.pl').
:- consult('utils.pl').
:- consult('api.pl').

% interact with user
main :-
    % prompt user for name to load their preference
    write('This is a movie recommender!\n'),
    write('To get started, try typing "search_movies_by_genre("action")"')
    %.. other queries
    % search by genre, actors, director, year, rating,


    % read query and execute, execute-query in utils.pl
    read_line_to_string(user_input, Query),
    execute_query(Query),


    % exit
    write('Thankyou for using this program!').

