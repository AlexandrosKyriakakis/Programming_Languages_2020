next_to(a, b).
next_to(a, c).
next_to(a, f).
next_to(b, c).
next_to(b, d).
next_to(b, e).
next_to(e, f).
next_to(g, h).
next_to(f, h).

joint_with(X, Y) :-
    (   next_to(X, Y)
    ;   next_to(Y, X)
    ).

show_path(Node, FinishNode, [Node, FinishNode], _) :-
    joint_with(Node, FinishNode, ).

show_path(Node, FinishNode, [Node|Restroute], Counter) :-
    joint_with(Node, ANode),
    show_path(ANode, FinishNode, Restroute, _),
    length([Node|Restroute], Counter).