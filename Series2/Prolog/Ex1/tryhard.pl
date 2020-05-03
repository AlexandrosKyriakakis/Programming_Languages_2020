recursiveFoo(N, K, LastElem, CurrentList, ResultList) :- 
    (   
        /*IF(  EXP   OR    EXP    AND   EXP) "->" = THEN    ()        */
        ((K > N) ; ((K =:= 0) , (N =\= 0))) -> ResultList = [] 
        /* ";" -> other branch of same if-then-else */
        ; ((K =:= 0) ; (N =:= 0)) -> ResultList = CurrentList
        ; (
            CheckNum is (N - K + 1), Delta is msb(CheckNum), 
            PowDelta is 1 << Delta,
            NewN is N - PowDelta, NewK is K - 1,
            (Delta > LastElem) -> append([1], CurrentList, NewCurrentList),
                recursiveFoo(NewN, NewK, Delta, NewCurrentList, ResultList)
            ;
            CheckNum is (N - K + 1), Delta is msb(CheckNum), 
            PowDelta is 1 << Delta,
            NewN is N - PowDelta, NewK is K - 1,
            (Delta < LastElem) -> addZeros(CurrentList, LastElem, Delta, NewTail),
                append([1], NewTail, ReNewCurrentList),
                recursiveFoo(NewN, NewK, Delta, ReNewCurrentList, ResultList)
            ;
            CheckNum is (N - K + 1), Delta is msb(CheckNum), 
            PowDelta is 1 << Delta,
            NewN is N - PowDelta, NewK is K - 1,
            CurrentList = [H|T], NewHead is H+1, append([NewHead],T, Re2NewCurrentList),
            recursiveFoo(NewN, NewK, Delta, Re2NewCurrentList, ResultList)
        )
    ).
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

