% Taken from Pierre in https://stackoverflow.com/questions/9051781/how-can-make-array-in-prolog
%:- module(arraysim, [insertAS/4,getAS/3]).
use_module(library(lists)).

find_path(Index,Path):-
    integer(Index),
    Index > 0,
    find_path2(Index,[],Path).

%-----------------------------------------------------------------
%
% find_path2(+Index,+Acc,-Path)
%
% Use of an accumulator pair to ensure that the sequence is in the
% correct order (i.e. starting from root of tree).
%
%-----------------------------------------------------------------


find_path2(1,Path,Path):-!.
find_path2(Index,Path,ReturnedPath):-
    Parity is Index mod 2,
    ParentIndex is Index div 2,
(   Parity =:= 0
->  find_path2(ParentIndex,[left|Path],ReturnedPath)
;   find_path2(ParentIndex,[right|Path],ReturnedPath)
).

%-----------------------------------------------------------------
%
% insertAS(+Value,+Index,+Tree,-NewTree)
%
% Insert Value at node of index Index in Tree to produce NewTree.
%
%-----------------------------------------------------------------

insertAS(Value,Index,Tree,NewTree):-
    find_path(Index,Path),
    insert(Value,Path,Tree,NewTree),!.

%-----------------------------------------------------------------
%
% insert(+Value,+Path,+Tree,-NewTree)
%
% Insert Value at position given by Path in Tree to produce
% NewTree.
%
%-----------------------------------------------------------------

% insertion in empty tree
%
insert(Value,[],[],[Value]).
insert(Value,[left|P],[],[nil,Left,[]]):-
    insert(Value,P,[],Left).
insert(Value,[right|P],[],[nil,[],Right]):-
    insert(Value,P,[],Right).

% insertion at leaf node
%
insert(Value,[],[_],[Value]).
insert(Value,[left|P],[X],[X,Left,[]]):-
    insert(Value,P,[],Left).
insert(Value,[right|P],[X],[X,[],Right]):-
    insert(Value,P,[],Right).

% insertion in non-empty non-leaf tree
%
insert(Value,[],[_,Left,Right],[Value,Left,Right]).
insert(Value,[left|P],[X,Left,Right],[X,NewLeft,Right]):-
    insert(Value,P,Left,NewLeft).
insert(Value,[right|P],[X,Left,Right],[X,Left,NewRight]):-
    insert(Value,P,Right,NewRight).

%-----------------------------------------------------------------
%
% getAS(-Value,+Index,+Tree)
%
% get the Value stored in node of index Index in Tree.
% Value is nil if nothing has been stored in the node
% (including the case when the node was never created).
%
%-----------------------------------------------------------------

getAS(Value,Index,Tree):-
    find_path(Index,Path),
    get(Value,Path,Tree),!.

%-----------------------------------------------------------------
%
% get(-Value,Path,+Tree)
%
% get the Value stored in node with access path Path in Tree.
% Value is nil if nothing has been stored in the node
% (including the case when the node was never created).
%
%-----------------------------------------------------------------

get(nil,_,[]).
get(nil,[_|_],[_]).
get(Value,[],[Value]).
get(Value,[],[Value,_,_]).
get(Value,[left|P],[_,Left,_]):-
    get(Value,P,Left).
get(Value,[right|P],[_,_,Right]):-
    get(Value,P,Right).


recursiveFoo([], Node, Degree, NumOfChildren, LastFather_NumVisited_NumFinal, Node, Degree, NumOfChildren, LastFather_NumVisited_NumFinal, []):-!.
recursiveFoo([0,0],Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,Node,Degree,NumOfChildren,LastFather_NumVisited_NumFinal,[0,0]):-!.
%recursiveFoo(leaf|tail)
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
            NewFathersDegree = 1, 
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
            append([Father],Tail,NewRecursion), 
            recursiveFoo(NewRecursion, ReNewNode, ReNewDegree, ReNewNumOfChildren, ReNewLastFather_NumVisited_NumFinal, NewNode, NewDegree, NewNumOfChildren, NewLastFather_NumVisited_NumFinal, Result)
               
            
    ).

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
            NewFathersDegree =\= 1, 
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
            recursiveFoo(Tail, ReNewNode, ReNewDegree, ReNewNumOfChildren, ReNewLastFather_NumVisited_NumFinal, NewNode, NewDegree, NewNumOfChildren, NewLastFather_NumVisited_NumFinal, Result)
               
            
    ).

%insertAS([2,3],1,_,Node),insertAS([1,3],2,Node,NewNode),insertAS([2,1],3,NewNode,NewNewNode),
%insertAS(2,1,_,Degree),insertAS(2,2,Degree,NewDegree),insertAS(2,3,NewDegree,NewNewDegree),
%insertAS(0,1,_,Children),insertAS(0,2,Children,NewChildren),insertAS(0,3,NewChildren,NewNewChildren).
%randomWalk(1,[],0,4,NewNewNode,NewNewDegree,[0,0,0],NewNewChildren,JobA,JobB).

randomWalk(_,RandomUnvisitedNode,_,_,_,Node,_,[_, _, _],_,[0,0],0):- getAS(DegreeOfRdNode,RandomUnvisitedNode,Node), DegreeOfRdNode = [],!.
randomWalk(TempTemp,_,Acum,NumFinalRoots,N,_,_,[LastFather, NumVisited, _],_,ResultList, Result):-
    (   % LastFather = FirstFather
        % Increase visited
        NewNumVisited is NumVisited + 1,
        %getAS(ToAcum,RandomUnvisitedNode,NumOfChildren),
        %AddToAcum is ToAcum + 1,
        % Take random neighboor
        %getAS(Temp, RandomUnvisitedNode, Node),
        %Temp = [TempFather|_],
        % Remove from adjastency list of random neighboor randomUnvisitedNode
        %getAS(TempFatherAdj,TempFather,Node),
        %delete(TempFatherAdj,RandomUnvisitedNode, NewTempFatherAdj),
        %insertAS(NewTempFatherAdj,TempFather,Node,NewNode),  %Evala Renew
        NewN is N+1,
        TempTemp =:= LastFather, NewNumVisited =:= NewN, msort(Acum,ResultList), Result = NumFinalRoots),!.
randomWalk(TempTemp,_,_,_,N,_,_,[LastFather, NumVisited, _],_,ResultList, Result):-
        (   % LastFather = FirstFather
            % Increase visited
            NewNumVisited is NumVisited + 1,
            %getAS(ToAcum,RandomUnvisitedNode,NumOfChildren),
            %AddToAcum is ToAcum + 1,
            %% Take random neighboor
            %getAS(Temp, RandomUnvisitedNode, Node),
            %Temp = [TempFather|_],
            %% Remove from adjastency list of random neighboor randomUnvisitedNode
            %getAS(TempFatherAdj,TempFather,Node),
            %delete(TempFatherAdj,RandomUnvisitedNode, NewTempFatherAdj),
            %insertAS(NewTempFatherAdj,TempFather,Node,NewNode),  %Evala Renew
            NewN is N+1,
            TempTemp = LastFather, NewNumVisited =\= NewN, ResultList = [0,0], Result = 0),!.
randomWalk(_,RandomUnvisitedNode,Acum,NumFinalRoots,N,Node,Degree,[LastFather, NumVisited, NumFinal],NumOfChildren,ResultList, Result):-
    (   % LastFather = FirstFather
        % Increase visited
        NewNumVisited is NumVisited + 1,
        getAS(ToAcum,RandomUnvisitedNode,NumOfChildren),
        AddToAcum is ToAcum + 1,
        % Take random neighboor
        getAS(Temp, RandomUnvisitedNode, Node),
        Temp = [TempFather|_],
        % Remove from adjastency list of random neighboor randomUnvisitedNode
        getAS(TempFatherAdj,TempFather,Node),
        delete(TempFatherAdj,RandomUnvisitedNode, NewTempFatherAdj),
        insertAS(NewTempFatherAdj,TempFather,Node,NewNode),  %Evala Renew

        append([AddToAcum],Acum,NewAccum), NewNumFinalRoots is NumFinalRoots + 1, 
        randomWalk(TempFather,TempFather,NewAccum,NewNumFinalRoots,N,NewNode,Degree,[LastFather,NewNumVisited,NumFinal],NumOfChildren, ResultList, Result)      
    ).

/* make_adj(InputList, empty adj Table, empty degree Table, Result adj Table, Result degree Table) */
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
    make_adj(Rest, NewT, NewDT, RT, RDT).
/* swipl mergesort: sort(List, SortedList) */

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
    ).

read_and_do(0, _Stream, CurrentAnswers, Answers):-
    reverse(CurrentAnswers, Answers),!.

read_and_do(T, Stream, CurrentAnswers, Answers):-
    read_line(Stream, [N, M]),
    read_edges(Stream, M, [], InputList),
    make_adj(InputList, [], [], Node, Degree ),
    dotheactualjob(N, M, Node, Degree, JobResult, JobResultList),
    (JobResult =\= 0 
    -> append([[JobResult,JobResultList ]],CurrentAnswers, NewCurrentAnswers)
    ; append(["'NO CORONA'"], CurrentAnswers, NewCurrentAnswers)
    ),
    NewT is T - 1,
    read_and_do(NewT, Stream, NewCurrentAnswers, Answers).
coronograph(File, Answers) :-
    open(File, read, Stream),
    read_line(Stream, T),
    [H | _] = T,
    read_and_do(H, Stream, [], Answers).

read_edges(_Stream, 0, CurrList, InputList):-
    reverse(CurrList,InputList),!.

read_edges(Stream, M, CurrList, InputList):-
    read_line(Stream, Pair),
    append(Pair, CurrList, NewList),
    NewM is M - 1,
    read_edges(Stream, NewM, NewList, InputList).

read_line(Stream, L):-
    not(at_end_of_stream(Stream)),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms,' ', Atom),
    maplist(atom_number, Atoms, L).

init(Array,I,N,NewArray):-
    (
        N =:= I -> NewArray = Array
        ; insertAS(0,I,Array,ReNewArray), NewI is I +1,
         init(ReNewArray,NewI,N,NewArray)
    ).
/*
make_adj([6,3,7,1,8,9,6,4,5,1,1,9,2,5,1,4,5,4],[],[], Node,Degree),
parseDegree(1,[],10,Result,Degree),init([],1,10,NumOfChildren), 
recursiveFoo(Result,Node, Degree, NumOfChildren,[0,0,0],NewNode,NewDegree,NewNumOfChildren,NewLastSomething,ReRE), 
[LastFather|_] = NewLastSomething,
randomWalk(0,LastFather,[],0,9,NewNode,NewDegree,NewLastSomething,NewNumOfChildren,JobA,JobB).
*/

%[4,6,8,1,3,4,2,8,6,7,9,3,4,7,1,5,4,9]
dotheactualjob(N, M, _, _, 0, [0,0]):- N =\= M,!.

dotheactualjob(N, N, Node, Degree, JobResult, JobResultList):-
    %print(will_get_into_random_walk),nl, 
    NewN is N + 1,
    parseDegree(1,[], NewN, ParseResult, Degree),
    init([], 1,  NewN, NumOfChildren),
    recursiveFoo(ParseResult, Node, Degree, NumOfChildren, [1,0,0], NewNode, _NewDegree, _NewNumOfChildren, NewLastSomething, ReRE),

    %print(ReRE),
    [LastLastFather,LastNumVisited, _NumFinal]= NewLastSomething,
    %print(LastLastFather),
    %print(printed_last_last_father),
    getAS(LastFatherList, LastLastFather, NewNode),
    %print(42),
    ((LastNumVisited > N - 3) ; (ParseResult = [0,0]) ; (LastFatherList = []) ; (ReRE = [0,0])) -> JobResultList = [0,0], JobResult = 0
    ; (
        NewN is N + 1,
        parseDegree(1,[], NewN, ParseResult, Degree),
        init([], 1,  NewN, NumOfChildren),
        recursiveFoo(ParseResult, Node, Degree, NumOfChildren, [1,0,0], NewNode, NewDegree, NewNumOfChildren, NewLastSomething, _ReRE),
    
        %print(ReRE),
        [LastLastFather,LastNumVisited, NumFinal]= NewLastSomething,
        %print(LastLastFather),
        %print(printed_last_last_father),
        % getAS(LastFatherList, LastLastFather, NewNode),
        %print(42),
        %print(will_get_into_random_walk), 
        randomWalk(0,LastLastFather,[],  0, N, NewNode, NewDegree,[LastLastFather, LastNumVisited, NumFinal], NewNumOfChildren, JobResultList, JobResult)),!.



%insertAS([2,3],1,_,Node),insertAS([1,3],2,Node,NewNode),insertAS([2,1],3,NewNode,NewNewNode),
%insertAS(2,1,_,Degree),insertAS(2,2,Degree,NewDegree),insertAS(2,3,NewDegree,NewNewDegree),
%insertAS(0,1,_,Children),insertAS(0,2,Children,NewChildren),insertAS(0,3,NewChildren,NewNewChildren),
%randomWalk(1,[],0,3,NewNewNode,NewNewDegree,[1,0,0],NewNewChildren,JobA,JobB).
