% This program defines a movie query system that prompts the user for a movie title
% and returns a list of matching movies using the TMDB API.

:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

% API key
api_key("4c5db61eb94257bed061e37f5f9945f9").

% Continue prompt
continue_prompt :-
    writeln('Press Enter to continue.'),
    read_line_to_string(user_input, _).

% HTTP request and JSON parsing
search_movies(Title, Movies) :-
    api_key(APIKey),
    format(atom(EncodedTitle), '~s', [Title]),
    www_form_encode(EncodedTitle, Encoded),
    format(atom(URL), 'https://api.themoviedb.org/3/search/movie?api_key=~s&query=~s', [APIKey, Encoded]),
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Dict),
        close(In)
    ),
    Movies = Dict.get('results').

% Print movie list with year of release
print_movies([]) :-
    writeln('No more movies found matching the search criteria.'),
    writeln('Type "y" to search for another movie, or "n" to exit.'),
    read_line_to_string(user_input, Continue),
    (Continue = "y" ->
        movie_query % Show the movie query prompt again
    ;
        halt % Exit the program
    ).
print_movies([Movie | Rest]) :-
    format('~w (~w)', [Movie.get('title'), Movie.get('release_date')]),
    nl,
    print_movies(Rest).
    
% Entry point
main :-
    movie_query.

% Movie query loop
movie_query :-
    write('Enter the title of a movie: '),
    read_line_to_string(user_input, Title),
    (Title = '' ->
        true % Exit the loop if the user enters an empty string
    ;
        search_movies(Title, Movies),
        print_movies(Movies),
        continue_prompt, % Show the continue prompt after each query
        movie_query % Show the movie query prompt again
    ).