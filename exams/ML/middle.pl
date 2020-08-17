middle([], []).
middle(Mylist, Resultlist) :-
    auxmiddle(Mylist, _, _, Resultlist).
