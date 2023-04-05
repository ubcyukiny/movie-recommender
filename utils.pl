% utils.pl - Handle utility functions

% execute query
execute_query(Query) :-
    % check format valid, return result
    format('You entered: ~s~n', [Query]).