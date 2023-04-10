% api.pl - Retrieve movie data from external API

:- use_module(library(http/http_open)).
:- use_module(library(http/http_ssl_plugin)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).

% TMDB API Key
api_key_tmdb("4c5db61eb94257bed061e37f5f9945f9").

% Query on TMDB API
query_tmdb_api(Path, Params, Data) :-
    api_key_tmdb(ApiKey),
    format(string(BaseURL), "https://api.themoviedb.org/3", []),
    format(string(Url), "~s~s?api_key=~s", [BaseURL, Path, ApiKey]),
    http_open([url(Url), search(Params), cert_verify_hook(cert_accept_any)], In, []),
    json_read_dict(In, Data),
    close(In).

% Search for movies by actor
search_movies_by_actor(Actor, Results) :-
    query_tmdb_api("/search/person", [query=Actor], Data),
    Results = Data.results.

% Get movie details by ID
get_movie_details(MovieID, Details) :-
    format(string(Path), "/movie/~w", [MovieID]),
    query_tmdb_api(Path, [], Details).