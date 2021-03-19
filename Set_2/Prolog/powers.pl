read_and_do(0, _Stream, Answers, Answers).

read_and_do(M, Steam, CurrentAnswers, Answers):-
    read_line(Steam, [N, K]),
    dotheactualjob(N, K, ResultR),
    append(CurrentAnswers, [ResultR], NewCurrentAnswers),
    NewM is M - 1,
    read_and_do(NewM, Steam, NewCurrentAnswers, Answers).


powers2(File, Answers) :-
    open(File, read, Stream),
    read_line(Stream, M),
    [H | _] = M,
    read_and_do(H, Stream, [], Answers).



read_line(Stream, L):-
    not(at_end_of_stream(Stream)),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms,' ', Atom),
    maplist(atom_number, Atoms, L).



dotheactualjob(N, K, ResultR):-
    dotheJob(N, K, _, ResultR).


dotheJob(N, K, R, ResultR):-
    recursiveFoo(N, K, 0, [], R),
    CheckNum is (N - K + 1),
    Delta is msb(CheckNum) + 1,
    length(R, ResultLength),
    fixzeros(ResultLength, Delta, R, ResultR).

fixzeros(_,_, [], []).

fixzeros(A, A, R, R).

fixzeros(ResultLength, Delta, R, ResultR):-
    ResultLength < Delta,
    NewLength is ResultLength + 1,
    append([0], R, NewR), 
    fixzeros(NewLength, Delta, NewR, ResultR).

recursiveFoo(N, K, _, _, ResultList):-
    K > N,
    N > 0,
    ResultList = [].

recursiveFoo(N, K , _, _, ResultList):-
    K =:= 0,
    N > 0,
    ResultList = [].

recursiveFoo(N, K, _, CurrentList, ResultList):-
    K = 0,
    N = 0,
    ResultList = CurrentList.

recursiveFoo(N, K, LastElem, CurrentList, ResultList):-
    N > 0,
    K > 0,
    CheckNum is (N - K + 1),
    Delta is msb(CheckNum), 
    PowDelta is 1 << Delta,
    NewN is N - PowDelta,
    NewK is K - 1,
    foo(NewN, NewK, Delta, CurrentList, ResultList, LastElem).


foo(NewN, NewK, Delta, CurrentList, ResultList, LastElem):-
    Delta > LastElem,
    append([1], CurrentList, NewCurrentList),
    recursiveFoo(NewN, NewK, Delta, NewCurrentList, ResultList).

foo(NewN, NewK, Delta, CurrentList, ResultList, LastElem):-
    Delta < LastElem,
    addZeros(CurrentList, LastElem, Delta, NewTail),
    append([1], NewTail, ReNewCurrentList),
    recursiveFoo(NewN, NewK, Delta, ReNewCurrentList, ResultList).

foo(NewN, NewK, Delta, CurrentList, ResultList, LastElem):-
    Delta =:= LastElem,
    CurrentList = [H|T],
    NewHead is H+1,
    append([NewHead],T, Re2NewCurrentList),
    recursiveFoo(NewN, NewK, Delta, Re2NewCurrentList, ResultList).
    
/* LastElem must be greater than Delta */
addZeros(MyList, LastElem, Delta, Result) :-
    NewLast is LastElem - 1,
    (   /* FIXME This have be deactivated*/
        (Delta > LastElem) -> Result = ["E","R","R","O","R"]
        ; (Delta =:= NewLast) -> Result = MyList
        ; NewDelta is Delta + 1,
        append([0],MyList,NewMyList),
        addZeros(NewMyList, LastElem, NewDelta, Result)
    ).

        