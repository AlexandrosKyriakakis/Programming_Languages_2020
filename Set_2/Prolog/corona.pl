abolish(counter/1).
use_module(library(lists)).
%use_module(library(statistics)).
set_prolog_stack(global, limit(100 000 000 000)).
set_prolog_stack(trail,  limit(20 000 000 000)).
set_prolog_stack(local,  limit(2 000 000 000)).


getAS(Value,Index,Tree):-
    arg(Index,Tree,Value),!.
insertAS(Value,Index,Tree,Tree):-
    nb_setarg(Index,Tree,Value),!.




recursiveFoo([], Node, Degree, NumOfChildren, LastFather_NumVisited_NumFinal, Node, Degree, NumOfChildren, LastFather_NumVisited_NumFinal, []):-!.
recursiveFoo([0,0],Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,[0,0]):-!.
recursiveFoo([Leaf|_], Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal, [0,0]):- getAS(LeafDegree, Leaf, Degree), LeafDegree =\= 1,!.

recursiveFoo([Leaf|_], Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal, Result) :- 
        getAS(AdjLeaf, Leaf, Node),
        AdjLeaf = [], Result = [0,0],!.
recursiveFoo([Leaf|Tail], Node, Degree, NumOfChildren, [_,NumVisited,NumFinal], NewNode, NewDegree, NewNumOfChildren, NewLastFather_NumVisited_NumFinal, Result) :- 
    (
            Leaf =\= 0,
            getAS(AdjLeaf, Leaf, Node),
            AdjLeaf = [Father|_],
            % Erase edge to leaf from fathers list 
            getAS(Temp,Father,Node),
            delete(Temp, Leaf, NewTemp),
            insertAS(NewTemp,Father,Node,ReNewNode),

            % Decrease fathers degree
            getAS(FathersDegree,Father,Degree),
            NewFathersDegree is FathersDegree - 1, 
            insertAS(NewFathersDegree,Father,Degree,ReNewDegree),
            % Add children
            getAS(LeafChildren, Leaf, NumOfChildren),
            getAS(FatherChildren, Father, NumOfChildren),
            NewFatherChildren is LeafChildren + FatherChildren + 1,
            insertAS(NewFatherChildren,Father,NumOfChildren,ReNewNumOfChildren),
            % Increase number of visited and update last father
            NewLastFather = Father,
            NewNumVisited is NumVisited + 1,
            ReNewLastFather_NumVisited_NumFinal = [NewLastFather,NewNumVisited,NumFinal],
            ((NewFathersDegree =:= 1)
            ->  append([Father],Tail,NewRecursion), 
                recursiveFoo(NewRecursion, ReNewNode, ReNewDegree, ReNewNumOfChildren, ReNewLastFather_NumVisited_NumFinal, NewNode, NewDegree, NewNumOfChildren, NewLastFather_NumVisited_NumFinal, Result)
            ;   recursiveFoo(Tail, ReNewNode, ReNewDegree, ReNewNumOfChildren, ReNewLastFather_NumVisited_NumFinal, NewNode, NewDegree, NewNumOfChildren, NewLastFather_NumVisited_NumFinal, Result)
                )
    ),!.

randomWalk(TempTemp,_,Acum,NumFinalRoots,N,_,_,[LastFather, NumVisited, _],_,ResultList, Result):-
    (   NewNumVisited is NumVisited + 1,
        NewN is N+1,
        TempTemp =:= LastFather, NewNumVisited =:= NewN, msort(Acum,ResultList), Result = NumFinalRoots),!.
randomWalk(TempTemp,_,_,_,N,_,_,[LastFather, NumVisited, _],_,ResultList, Result):-
        (   NewNumVisited is NumVisited + 1,
            NewN is N+1,
            TempTemp = LastFather, NewNumVisited =\= NewN, ResultList = [0,0], Result = 0),!.
randomWalk(_,RandomUnvisitedNode,Acum,NumFinalRoots,N,Node,Degree,[LastFather, NumVisited, NumFinal],NumOfChildren,ResultList, Result):-
    (   NewNumVisited is NumVisited + 1,
        getAS(ToAcum,RandomUnvisitedNode,NumOfChildren),
        AddToAcum is ToAcum + 1,
        getAS(Temp, RandomUnvisitedNode, Node),
        Temp = [TempFather|_],
        getAS(TempFatherAdj,TempFather,Node),
        delete(TempFatherAdj,RandomUnvisitedNode, NewTempFatherAdj),
        insertAS(NewTempFatherAdj,TempFather,Node,NewNode),  %Evala Renew
        append([AddToAcum],Acum,NewAccum), NewNumFinalRoots is NumFinalRoots + 1, 
        randomWalk(TempFather,TempFather,NewAccum,NewNumFinalRoots,N,NewNode,Degree,[LastFather,NewNumVisited,NumFinal],NumOfChildren, ResultList, Result)      
    ),!.

randomWalk(_,RandomUnvisitedNode,_,_,_,Node,_,[_, _, _],_,[0,0],0):- getAS(DegreeOfRdNode,RandomUnvisitedNode,Node), DegreeOfRdNode = [],!.

make_adj([], T, DT, RT, RDT) :-
    RT = T,
    RDT = DT,!.


make_adj([First,Second|Rest], T, DT, RT, RDT):-
    getAS(FirstL, First, T),
    (FirstL = nil
    -> insertAS([Second], First, T, NewerT)
    ;append([Second],FirstL, NewFirstL),
    insertAS(NewFirstL, First, T, NewerT)
    ),
    getAS(SecondL, Second, NewerT),
    (SecondL = nil
    -> insertAS([First], Second, NewerT, NewT)
    ;append([First], SecondL, NewSecondL),
    insertAS(NewSecondL, Second, NewerT, NewT)
    ),
    getAS(FirstD, First, DT),
    ( FirstD = nil
    -> NewFirstD = 1
    ; NewFirstD is FirstD + 1
    ),
    insertAS(NewFirstD, First, DT, NewerDT),
    getAS(SecondD, Second, NewerDT),
    ( SecondD = nil
    -> NewSecondD = 1 
    ; NewSecondD is SecondD + 1
    ),
    insertAS(NewSecondD, Second, NewerDT, NewDT),
    make_adj(Rest, NewT, NewDT, RT, RDT),!.

parseDegree(Index, Accum, Index, Accum, _DT):-!.

parseDegree(Index, Accum, N, Result, DT):-
    Index =\= N,
    NewIndex is Index + 1,
    getAS(DegreeofIndex, Index, DT),
    ( DegreeofIndex = nil
    -> Result = [0,0]
    ; ( DegreeofIndex = 1
      -> append([Index], Accum, NewAccum), parseDegree(NewIndex, NewAccum, N, Result, DT)
        ;parseDegree(NewIndex, Accum, N, Result, DT)      
      )
    ),!.

read_and_do(0, _Stream, CurrentAnswers, Answers):-
    reverse(CurrentAnswers, Answers),!.

read_and_do(T, Stream, CurrentAnswers, Answers):-
    read_line(Stream, [N, M]),
    read_edges(Stream, M, [], InputList),
    functor(PreNode, array1, N),
    functor(PreDegree, array2, N),
    make_adj(InputList, PreNode, PreDegree, Node, Degree ),
    dotheactualjob(N, M, Node, Degree, JobResult, JobResultList),
    (JobResult =\= 0 
    -> append([[JobResult,JobResultList ]],CurrentAnswers, NewCurrentAnswers)
    ; append(["'NO CORONA'"], CurrentAnswers, NewCurrentAnswers)
    ),
    NewT is T - 1,
    read_and_do(NewT, Stream, NewCurrentAnswers, Answers),!.
coronograph(File, Answers) :-
    open(File, read, Stream),
    read_line(Stream, T),
    [H | _] = T,
    read_and_do(H, Stream, [], Answers),!.

read_edges(_Stream, 0, CurrList, InputList):-
    reverse(CurrList,InputList),!.

read_edges(Stream, M, CurrList, InputList):-
    read_line(Stream, Pair),
    append(Pair, CurrList, NewList),
    NewM is M - 1,
    read_edges(Stream, NewM, NewList, InputList),!.

read_line(Stream, L):-
    not(at_end_of_stream(Stream)),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms,' ', Atom),
    maplist(atom_number, Atoms, L),!.

init(Array,I,N,NewArray):-
    (
        N =:= I -> NewArray = Array
        ; insertAS(0,I,Array,ReNewArray), NewI is I +1,
         init(ReNewArray,NewI,N,NewArray)
    ),!.

dotheactualjob(N, M, _, _, 0, [0,0]):- N =\= M,!.

dotheactualjob(N, N, Node, Degree, JobResult, JobResultList):-
    NewN is N + 1,
    parseDegree(1,[], NewN, ParseResult, Degree),
    functor(PreNumOfChildren, array3, N),
    init(PreNumOfChildren, 1,  NewN, NumOfChildren),
    recursiveFoo(ParseResult, Node, Degree, NumOfChildren, [1,0,0], NewNode, NewDegree, NewNumOfChildren, NewLastSomething, ReRE),
    [LastLastFather,LastNumVisited, NumFinal]= NewLastSomething,
    getAS(LastFatherList, LastLastFather, NewNode),
    (((LastNumVisited > N - 3) ; (ParseResult = [0,0]) ; (LastFatherList = []) ; (ReRE = [0,0])) -> JobResultList = [0,0], JobResult = 0
    ; randomWalk(0,LastLastFather,[],  0, N, NewNode, NewDegree,[LastLastFather, LastNumVisited, NumFinal], NewNumOfChildren, JobResultList, JobResult)
    ),!.
        