% This program defines a movie query system that prompts the user for a movie title
% and returns a list of matching movies using the TMDB API.

:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

% API key
api_key("4c5db61eb94257bed061e37f5f9945f9").

% Landing page prompt
landing_page :-
    writeln('Welcome to the Movie Query System!'),
    writeln('Enter "exit" to quit the program, or press Enter to continue.'),
    read_line_to_string(user_input, Response),
    (Response = 'exit' ->
        halt % Terminate the program if the user enters 'exit'
    ;
        true % Continue with the program if the user enters anything else
    ).

% HTTP request and JSON parsing
%search_movies(Title, Movies) :-
%    api_key(APIKey),
%    format(atom(EncodedTitle), '~s', [Title]),
%    www_form_encode(EncodedTitle, Encoded),
%    format(atom(URL), 'https://api.themoviedb.org/3/search/movie?api_key=~s&query=~s', [APIKey, Encoded]),
%    setup_call_cleanup(
%        http_open(URL, In, []),
%        json_read_dict(In, Dict),
%        close(In)
%    ),
%    Movies = Dict.get('results').

search_movies(Title, Year, Movies) :-
    api_key(APIKey),
    format(atom(EncodedTitle), '~s', [Title]),
    format(atom(EncodedYear), '~s', [Year]),
    www_form_encode(EncodedTitle, WWW_EncodedTitle),
    www_form_encode(EncodedYear, WWW_EncodedYear),
    format(atom(URL), 'https://api.themoviedb.org/3/search/movie?api_key=~s&query=~s&primary_release_year=~s', [APIKey, WWW_EncodedTitle, WWW_EncodedYear]),
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Dict),
        close(In)
    ),
    Movies = Dict.get('results').

% Print movie list with year of release
print_movies([]) :-
    writeln('No more movies found matching the search criteria.').
print_movies([Movie | Rest]) :-
    format('~w (~w)', [Movie.get('title'), Movie.get('release_date')]),
    nl,
    print_movies(Rest).

% Entry point
main :-
    landing_page, % Show the landing page prompt first
    movie_query.

% Movie query loop
movie_query :-
    write('Enter the title of a movie: '),
    read_line_to_string(user_input, Title),
    write('Enter the year of a movie: '),
    read_line_to_string(user_input, Year),
    (Title = '' ->
        true
    ;
%        search_movies(Title, Movies),
        search_movies(Title, Year, Movies),
        print_movies(Movies),
        movie_query % Recursive call to continue the loop
    ).