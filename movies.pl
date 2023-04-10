% movies.pl - Predicates for working with movie data
% to test search_movies, ?- consult('movies.pl').
% then type these example queries:
% search_movies("Daniel Radcliffe", _(year), _(genre)) returns movie played by Daniel Radcliffe
% search_movies(_, 2012, _) returns movies released in 2012
% search_movies(_, _, "action") returns movies'genre includes action
% search_movies(_,_,_) returns all movies, no filter

% Import API
:- consult('api.pl').

% movie(Title, Year, Genres, Actors).
% movie("Mr Bean", 1997, ["comedy"], ["Rowan Atkinson", "Peter MacNicol", "Pamela Reed"]).
% movie("Harry Potter and the Sorcerer's Stone", 2001, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("The Lord of the Rings: The Fellowship of the Ring", 2001, ["adventure", "fantasy"], ["Elijah Wood", "Ian McKellen", "Viggo Mortensen"]).
% movie("Harry Potter and the Chamber of Secrets", 2002, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Prisoner of Azkaban", 2004, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Goblet of Fire", 2005, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Order of Phoenix", 2007, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Half-Blood Prince", 2009, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Deathly Hallows: Part 1", 2010, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("Harry Potter and the Deathly Hallows: Part 2", 2011, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
% movie("The Dark Knight Rises", 2012, ["action"], ["Christian Bale", "Tom Hardy", "Anne Hathaway"]).
% movie("The Avengers", 2012, ["action"], ["Robert Downey Jr.", "Chris Evans", "Scarlett Johansson", "Jeremy Renner", "Mark Ruffalo"]).
% movie("Skyfall", 2012, ["action"], ["Daniel Craig"]).
% movie("Your Name", 2016, ["animation", "drama", "fantasy"], ["Ryunosuke Kamiki", "Mone Kamishiraishi", "Ryo Narita"]).
% movie("Avengers: Endgame", 2019, ["action"], ["Robert Downey Jr", "Scarlett Johansson", "Chris Evans", "Chris Hemsworth"]).
% movie("Space Jam 2", 2021, ["animation", "comedy", "sci-fi"], ["LeBron James", "Don Cheadle", "Cedric Joe"]).
% movie("Cocaine bear", 2022, ["comedy", "thriller"], ["Keri Russell", "O'Shea Jackson Jr.", "Alden Ehrenreich"]).


% % print list of movies
% print_lists([]).
% print_lists([H|T]) :-
%     write(H), nl,
%     print_lists(T).

% search movies
% search_movies(Actor, Year, Genre) :-
%     % has Actor
%     findall(Title ,(movie(Title, Year, MovieGenre, MovieActors), member(Genre, MovieGenre), member(Actor, MovieActors)), Movie_list),
%     % if cant find, any return a line telling user cannot find movies with those criteria
%     (length(Movie_list, 0) -> write('Sorry, we could not find any movies with that criteria.\n') ;
%     list_to_set(Movie_list, Movie_List_No_Duplicate),
%     format('Actor: ~w, Year: ~w, Genre: ~w\n', [Actor, Year, Genre]),
%     write('Here is the list of movies that fit your criteria:\n'),
%     print_lists(Movie_List_No_Duplicate)).

search_movies(Year, Genre, Results) :-
    % Use API.pl to get all popular movies
    get_all_movies(AllMovies),
    % Filter by year and genre
    (Year == wildcard -> FilteredByYear = AllMovies ; filter_movies_by_year(AllMovies, Year, FilteredByYear)),
    (Genre == wildcard -> Results = FilteredByYear ; filter_movies_by_genre(FilteredByYear, Genre, Results)).

% Get all movies
get_all_movies(Results) :-
    query_tmdb_api("/movie/popular", [], Data),
    Results = Data.results.

% Filter movies by Year
filter_movies_by_year([], _, []).
filter_movies_by_year([Movie|Tail], Year, [Movie|Filtered]) :-
    % Check if movie's release is given year
    (Year == wildcard -> true ; atom_concat(Year, "-", Movie.release_date)),
    filter_movies_by_year(Tail, Year, Filtered).
filter_movies_by_year([_|Tail], Year, Filtered) :-
    % Go to next movie
    filter_movies_by_year(Tail, Year, Filtered).

% Filter movies by genre
filter_movies_by_genre([], _, []).
filter_movies_by_genre([Movie|Tail], Genre, [Movie|Filtered]) :-
    % Check movie's genre against given genre
    (Genre == wildcard -> true ; member(Genre, Movie.genres)),
    filter_movies_by_genre(Tail, Genre, Filtered).
filter_movies_by_genre([_|Tail], Genre, Filtered) :-
    % Go to next movie
    filter_movies_by_genre(Tail, Genre, Filtered).

%Display Filtered
display_filtered_movies(Movies) :- 
    writeln('Filtered Movies: '),
    display_movies(Movies).

%Display
display_movies([]).
display_movies([Movie | Tail]) :-
    writeln(Movie.title),
    display_movies(Tail).
