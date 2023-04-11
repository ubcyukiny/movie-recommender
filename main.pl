% This program defines a movie query system that prompts the user for a movie title
% and returns a list of matching movies using the TMDB API.
% After compiling, write "main." to start app.

:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

% API key
api_key("4c5db61eb94257bed061e37f5f9945f9").

% Continue prompt
continue_prompt :-
    writeln('Press Enter to continue.'),
    read_line_to_string(user_input, _).

% HTTP request and JSON parsing
% Parse movie query
search_movies(Title, Movies, Year) :-
    api_key(APIKey),
    format(atom(EncodedTitle), '~s', [Title]),
    www_form_encode(EncodedTitle, Encoded),
    format(atom(URL), 'https://api.themoviedb.org/3/search/movie?api_key=~s&query=~s', [APIKey, Encoded]),
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Dict),
        close(In)
    ),
    AllMovies = Dict.get('results'),
    (var(Year) ->
        Movies = AllMovies % If no year is specified, return all movies
    ;
        include(movie_has_year(Year), AllMovies, Movies) % Filter movies by year
    ).

% HTTP request and JSON parsing for director search
search_director(Director, Movies, Year) :-
    api_key(APIKey),
    format(atom(EncodedDirector), '~s', [Director]),
    www_form_encode(EncodedDirector, Encoded),
    format(atom(URL), 'https://api.themoviedb.org/3/search/person?api_key=~s&query=~s', [APIKey, Encoded]),
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Dict),
        close(In)
    ),
    AllDirectors = Dict.get('results'),
    (AllDirectors = [] ->
        Movies = [] % If no directors are found, return an empty list
    ;
        nth1(1, AllDirectors, FirstDirector), % Use the first director found
        DirectorID = FirstDirector.get('id'),
        format(atom(DirectorMoviesURL), 'https://api.themoviedb.org/3/person/~w/movie_credits?api_key=~s', [DirectorID, APIKey]),
        setup_call_cleanup(
            http_open(DirectorMoviesURL, In2, []),
            json_read_dict(In2, DirectorMoviesDict),
            close(In2)
        ),
        AllCrew = DirectorMoviesDict.get('crew'),
        include(crew_is_director, AllCrew, AllDirectorsMovies), % Filter only the director position
        (var(Year) ->
            Movies = AllDirectorsMovies % If no year is specified, return all movies
        ;
            include(movie_has_year(Year), AllDirectorsMovies, Movies) % Filter movies by year
        )
    ).

% Predicate to check if a crew member is a director
crew_is_director(CrewMember) :-
    CrewMember.get('job') = "Director".

% Predicate to check if a movie has a certain year of release
movie_has_year(Year, Movie) :-
    atom_string(Year, YearStr),
    sub_string(Movie.get('release_date'), _, _, _, YearStr).

% Print movie list with optional year of release
print_movies([], _) :-
    writeln('No more movies found matching the search criteria.'),
    writeln('Type "y" to search for another movie, or "n" to exit.'),
    read_line_to_string(user_input, Continue),
    (Continue = "y" ->
        movie_query % Show the movie query prompt again
    ;
        halt % Exit the program
    ).
print_movies([Movie | Rest], Year) :-
    format('~w', [Movie.get('title')]),
    (   var(Year) ->
        format(' (~w)', [Movie.get('release_date')]), % Display the year if it's a variable
        true
    ;
        movie_has_year(Year, Movie) ->
        format(' (~w)', [Movie.get('release_date')]), % Display the year if it matches
        true
    ;
        true
    ),
    nl,
    print_movies(Rest, Year).
    
% App Start
main :-
    movie_query.

% Movie query loop
movie_query :-
    write('Enter "1" to search by title or "2" to search by director: '),
    read_line_to_string(user_input, Option),
    (Option = "1" ->
        write('Enter the title of a movie: '),
        read_line_to_string(user_input, Title),
        process_query(Title, search_movies)
    ;
        write('Enter the full name of a director: '),
        read_line_to_string(user_input, Director),
        process_query(Director, search_director)
    ).

% Process movie or director query
process_query(Query, SearchPredicate) :-
    (Query = '' ->
        true % Exit the loop if the user enters an empty string
    ;
        write('Enter a year (optional): '),
        read_line_to_string(user_input, YearStr),
        (YearStr = '' ->
            call(SearchPredicate, Query, Movies, _) % If no year is specified, use a variable
        ;
            atom_string(Year, YearStr),
            call(SearchPredicate, Query, Movies, Year) % Otherwise, filter by the specified year
        ),
        print_movies(Movies, Year),
        continue_prompt, % Show the continue prompt after each query
        movie_query % Show the movie query prompt again
    ).