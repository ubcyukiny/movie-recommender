% movies.pl - Predicates for working with movie data

movie(Title, Actors, Year, Genres).

% some examples
movie('Harry Potter and the Sorcerer\'s Stone', ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'], 2001, ['adventure']).
movie('Skyfall', ['Daniel Craig'], 2012, ['action']).
movie('Avengers: Endgame', ['Robert Downey Jr', 'Scarlett Johansson', 'Chris Evans', 'Chris Hemsworth'], 2019, ['action']).



% search movies
search_movies(Actor, Year, Genre, Movies) :-
    true.