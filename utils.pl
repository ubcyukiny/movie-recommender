% utils.pl - Handle utility functions

% execute query depends on query
execute_query(Query) :-
    % pattern matching for queries
    % search by genre, actors, director, year, rating,
    format('You entered: ~s~n', [Query]).