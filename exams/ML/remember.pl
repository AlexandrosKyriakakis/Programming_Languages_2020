/*btree(Price,LBtree,RBtree):- LBtree = btree(_,_,_), RBtree = btree.
*/
btree(_, empty, empty).
btree(_, btree(_, _, _), btree(_, _, _)).

floor(empty, _, 0).

floor(btree(N, empty, empty), K, F) :-
    (   K>=N
    ->  F=N
    ;   F=0
    ).

floor(T, K, F) :-
    T=btree(N, Lbtree, Rbtree),
    floor(Lbtree, K, L),
    floor(Rbtree, K, R),
    F is max(max(L, R), max(N, L)).

/*floor(T,3,F),T = btree(10,btree(1,btree(2,btree(4,empty,empty),empty),btree(3,empty,empty)),btree(5,empty,empty)).
*/