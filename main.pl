% main.pl - Interact with user
% to start, ?- consult('main.pl').
% then, ?- start.

% Import necessary files
:- consult('movies.pl').
:- consult('api.pl').

% example queries:
% search_movies("Daniel Radcliffe", _(year), _(genre)) returns movie played by Daniel Radcliffe
% search_movies(_, 2012, _) returns movies released in 2012
% search_movies(_, _, "action") returns movies'genre includes action
% search_movies(_,_,_) returns all movies, no filter

% interact with user
start :-
    write('This is a movie recommender!\n'),
    write('It filters movies that by the actor, released year, and genre.\n'),
    write('To skip a filter, for example if you want to ignore released year, simply type `_`\n'),

    % other queries? search by genre/ actor/ year only?

    % or could get users input actor, year, genre one by one?
    write('Enter ONE actor name here (eg. Daniel Radcliffe):\n'),
    read_line_to_string(user_input, Actor),
    write('Enter the movie released year here (eg. 2012):\n'),
    read_line_to_string(user_input, Year),
    write('Enter 1 Genre here (eg. animation/action/adventure):\n'),
    read_line_to_string(user_input, Genre),

    % check for wildcards
    convert_wildcard(Actor, NewActor),
    convert_wildcard(Genre, NewGenre),

    % TODO: check year is int after converting to number

    % convert year to wildcard, or int
    (Year == "_" -> convert_wildcard(Year, NewYear) ; atom_number(Year, NewYear)),
    search_movies(NewActor, NewYear, NewGenre),

    % exit
    write('Thankyou for using this program!').

% convert user input to wildcard if they enter "_"
convert_wildcard(Input, Output) :-
    (Input == "_" -> Output = _ ; Output = Input).
