% movies.pl - Predicates for working with movie data
% to test search_movies, ?- consult('movies.pl').
% then type these example queries:
% search_movies("Daniel Radcliffe", _(year), _(genre)) returns movie played by Daniel Radcliffe
% search_movies(_, 2012, _) returns movies released in 2012
% search_movies(_, _, "action") returns movies'genre includes action
% search_movies(_,_,_) returns all movies, no filter


% movie(Title, Year, Genres, Actors).
movie("Mr Bean", 1997, ["comedy"], ["Rowan Atkinson", "Peter MacNicol", "Pamela Reed"]).
movie("Harry Potter and the Sorcerer's Stone", 2001, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("The Lord of the Rings: The Fellowship of the Ring", 2001, ["adventure", "fantasy"], ["Elijah Wood", "Ian McKellen", "Viggo Mortensen"]).
movie("Harry Potter and the Chamber of Secrets", 2002, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Prisoner of Azkaban", 2004, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Goblet of Fire", 2005, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Order of Phoenix", 2007, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Half-Blood Prince", 2009, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Deathly Hallows: Part 1", 2010, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("Harry Potter and the Deathly Hallows: Part 2", 2011, ["adventure"], ["Daniel Radcliffe", "Emma Watson", "Rupert Grint"]).
movie("The Dark Knight Rises", 2012, ["action"], ["Christian Bale", "Tom Hardy", "Anne Hathaway"]).
movie("The Avengers", 2012, ["action"], ["Robert Downey Jr.", "Chris Evans", "Scarlett Johansson", "Jeremy Renner", "Mark Ruffalo"]).
movie("Skyfall", 2012, ["action"], ["Daniel Craig"]).
movie("Your Name", 2016, ["animation", "drama", "fantasy"], ["Ryunosuke Kamiki", "Mone Kamishiraishi", "Ryo Narita"]).
movie("Avengers: Endgame", 2019, ["action"], ["Robert Downey Jr", "Scarlett Johansson", "Chris Evans", "Chris Hemsworth"]).
movie("Space Jam 2", 2021, ["animation", "comedy", "sci-fi"], ["LeBron James", "Don Cheadle", "Cedric Joe"]).
movie("Cocaine bear", 2022, ["comedy", "thriller"], ["Keri Russell", "O'Shea Jackson Jr.", "Alden Ehrenreich"]).


% print list of movies
print_lists([]).
print_lists([H|T]) :-
    write(H), nl,
    print_lists(T).


% search movies
search_movies(Actor, Year, Genre) :-
    % has Actor
    findall(Title ,(movie(Title, Year, MovieGenre, MovieActors), member(Genre, MovieGenre), member(Actor, MovieActors)), Movie_list),
    list_to_set(Movie_list, Movie_List_No_Duplicate),
    print_lists(Movie_List_No_Duplicate).