% main.pl - Interact with user
% to start, ?- consult('main.pl').
% then, ?- start.

% Import necessary files
:- consult('movies.pl').
:- consult('api.pl').

% example queries:
% search_movies("Daniel Radcliffe", _(year), _(genre)) returns movie played by Daniel Radcliffe
% search_movies(_, 2012, _) returns movies released in 2012
% search_movies(_, _, "action") returns movies genre includes action
% search_movies(_,_,_) returns all movies, no filter

% interact with user
start :-
    %Welecome messages and instructions
    write('This is a movie recommender!\n'),
    write('It filters movies by the actor, released year, and genre.\n'),
    write('To skip a filter, simply type `_`\n'),

    % Get user inputs
    % other queries? search by genre/ actor/ year only?
    % or could get users input actor, year, genre one by one?
    write('Enter ONE actor name here (eg. Daniel Radcliffe):\n'),
    read_line_to_string(user_input, Actor),
    write('Enter the movie released year here (eg. 2012):\n'),
    read_line_to_string(user_input, Year),
    write('Enter 1 Genre here (eg. animation/action/adventure):\n'),
    read_line_to_string(user_input, Genre),

    % Check for wildcards and convert
    convert_wildcard(Actor, NewActor),
    convert_wildcard(Genre, NewGenre),
    (Year == "_" -> convert_wildcard(Year, NewYear) ; atom_number(Year, NewYear)),

     % Search using TMDB API
    (NewActor == wildcard -> search_movies(NewYear, NewGenre, Results) ; search_movies_by_actor(NewActor, Results)),
    %Filter by Year and Genre
    filter_movies_by_year(Results, NewYear, FilteredByYear),
    filter_movies_by_genre(FilteredByYear, NewGenre, FilteredByGenre),

    % Exit Message
    write('Thankyou for using this program!').

% convert user input to wildcard if they enter "_"
convert_wildcard(Input, Output) :-
    (Input == "_" -> Output = wildcard ; Output = Input).