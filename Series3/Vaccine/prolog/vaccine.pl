set_prolog_stack(global, limit(100000000000)).
set_prolog_stack(trail, limit(20000000000)).
set_prolog_stack(local, limit(2000000000)).

possibleStates("A", 1).
possibleStates("U", 2).
possibleStates("C", 3).
possibleStates("G", 4).
possibleStates("AU", 5).
possibleStates("AC", 6).
possibleStates("AG", 7).
possibleStates("UA", 8).
possibleStates("UC", 9).
possibleStates("UG", 10).
possibleStates("CA", 11).
possibleStates("CU", 12).
possibleStates("CG", 13).
possibleStates("GA", 14).
possibleStates("GU", 15).
possibleStates("GC", 16).
possibleStates("AUC", 17).
possibleStates("AUG", 18).
possibleStates("ACU", 19).
possibleStates("ACG", 20).
possibleStates("AGU", 21).
possibleStates("AGC", 22).
possibleStates("UAC", 23).
possibleStates("UAG", 24).
possibleStates("UCA", 25).
possibleStates("UCG", 26).
possibleStates("UGA", 27).
possibleStates("UGC", 28).
possibleStates("CAU", 29).
possibleStates("CAG", 30).
possibleStates("CUA", 31).
possibleStates("CUG", 32).
possibleStates("CGA", 33).
possibleStates("CGU", 34).
possibleStates("GAU", 35).
possibleStates("GAC", 36).
possibleStates("GUA", 37).
possibleStates("GUC", 38).
possibleStates("GCA", 39).
possibleStates("GCU", 40).
possibleStates("AUCG", 41).
possibleStates("AUGC", 42).
possibleStates("ACUG", 43).
possibleStates("ACGU", 44).
possibleStates("AGUC", 45).
possibleStates("AGCU", 46).
possibleStates("UACG", 47).
possibleStates("UAGC", 48).
possibleStates("UCAG", 49).
possibleStates("UCGA", 50).
possibleStates("UGAC", 51).
possibleStates("UGCA", 52).
possibleStates("CAUG", 53).
possibleStates("CAGU", 54).
possibleStates("CUAG", 55).
possibleStates("CUGA", 56).
possibleStates("CGAU", 57).
possibleStates("CGUA", 58).
possibleStates("GAUC", 59).
possibleStates("GACU", 60).
possibleStates("GUAC", 61).
possibleStates("GUCA", 62).
possibleStates("GCAU", 63).
possibleStates("GCUA", 64).
complementRNA("A", "U").
complementRNA("U", "A").
complementRNA("C", "G").
complementRNA("G", "C").
complementRNA(65, 85).
complementRNA(85, 65).
complementRNA(67, 71).
complementRNA(71, 67).

notK(1, 2).
notK(2, 1).
% Fix again!!! xreiazetai if then else aliws mpainei kai grafei mesa sto functor
possibleStatesNum(ListOfNums, Index) :-
    string_to_list(CharString, ListOfNums),
    possibleStates(CharString, Index).

getAS(Value, Index, Tree) :-
    arg(Index, Tree, Value),
    !.
get3D(Value, [I, J, K], Tree) :-
    getAS(Cell, I, Tree),
    getAS(InCell, J, Cell),
    getAS(Value, K, InCell).

insertAS(Value, Index, Tree) :-
    nb_setarg(Index, Tree, Value),
    !.
insert3D(Value, [I, J, K], Tree) :-
    getAS(Cell, I, Tree),
    getAS(InCell, J, Cell),
    insertAS(Value, K, InCell).
   
% doComplement("GUACA",[],Result,5). Works
doComplement(_, PreResult, Result, 0) :-
    string_to_list(Result, PreResult),
    !.
doComplement(CurrentInput, CurrentComplementedInput, Result, CurrentLen) :-
    string_to_list(CurrentInput, CodeList),
    nth1(CurrentLen, CodeList, Elem),
    complementRNA(Elem, ComplementedElem),
    append([ComplementedElem], CurrentComplementedInput, NewCurrentComplementedInput),
    NewItter is CurrentLen-1,
    doComplement(CurrentInput, NewCurrentComplementedInput, Result, NewItter).
   %CurrentComplementedInput
init(_, _, I, J) :-
    I is J+1.
init(Array, InitValue, I, N) :-
    insertAS(InitValue, I, Array),
    NewI is I+1,
    !,
    init(Array, InitValue, NewI, N),
    !.
vaccine(File, Answers) :-
    open(File, read, Stream),
    read_line1(Stream, T),
    [H|_]=T,
    read_and_do(H, Stream, [], Answers).
vaccine(_, _) :-
    false.
read_line1(Stream, L) :-
    not(at_end_of_stream(Stream)),
    !,
    read_line_to_codes(Stream, Line),
    !,
    %string_to_list(A,Line),
    %write_ln(A),
    atom_codes(Atom, Line),
    !,
    atomic_list_concat(Atoms, ' ', Atom),
    !,
    maplist(atom_number, Atoms, L).
% "p" = 112
% "c" = 99
% "r" = "114"
read_line2(Stream, L):-
    not(at_end_of_stream(Stream)),!,
    read_line_to_codes(Stream, Line),!,
    string_to_list(L,Line).


read_and_do(0, _Stream, CurrentAnswers, Answers):-
    reverse(CurrentAnswers, Answers),!.

read_and_do(T, Stream, CurrentAnswers, Answers):-
    read_line2(Stream, Input),!,
    runAll(Input,Output),
    append([Output],CurrentAnswers, NewCurrentAnswers),
    NewT is T - 1,!,
    read_and_do(NewT, Stream, NewCurrentAnswers, Answers),!.




runAll(Input,Output) :-
    functor(Result, single, 1),
    (   doTheJob(Input, Res),  % Edw Mpainei h eisodos
        insertAS(Res, 1, Result),
        false
    ;   true
    ),
    getAS(Output, 1, Result).


doTheJob(CurrentInput, Res) :-
    string_to_list(CurrentInput, CodeList),
    length(CodeList, CurrentLen),
    doComplement(CurrentInput, [], CurrentComplementedInput, CurrentLen),
    string_to_list(CurrentComplementedInput, ComplementedCodeList),
    functor(DPArray, array, 64),
    functor(Length, array, CurrentLen),
    functor(Boolean, array, 2),
    init(Boolean, [], 1, 2),
    init(Length, Boolean, 1, CurrentLen),
    init(DPArray, Length, 1, 64),
    last(CodeList, Elem),
    possibleStatesNum([Elem], Index),
    insert3D([112], [Index, 1, 1], DPArray),
    reverse(CodeList, RevCodeList),
    reverse(ComplementedCodeList, RevComplementedCodeList),
    recursiveFoo(DPArray, [Index, 1, 1], RevCodeList, RevComplementedCodeList, CurrentLen),
    print1(DPArray, CurrentLen, [], 1000000, 1, Res).

print2(_, Min, _, Elem, Res) :-
    length(Elem, Min),
    !,
    string_to_list(Res, Elem).
    %write_ln(Res).
print2(Result, Min, I, _, Res) :-
    nth1(I, Result, Elem),
    NewI is I+1,
    print2(Result, Min, NewI, Elem, Res).


print1(_, _, Result, Min, 65, Res) :-
    !,
    sort(Result, SortedRes),
    !,
    print2(SortedRes, Min, 1, [], Res).

print1(DPArray, CurrentLen, ResultList, MinLen, I, Res) :-
    NewI is I+1,
    get3D(Print, [I, CurrentLen, 1], DPArray),
    reverse(Print, RevPR),
    (   length(RevPR, A),
        A>0,
        A<MinLen
    ->  NewMinLen=A
    ;   NewMinLen=MinLen
    ),
    %string_to_list(ForPrint, RevPR),
    %write(ForPrint),
    %write(" , "),
    get3D(Other, [I, CurrentLen, 2], DPArray),
    reverse(Other, OtherPR),
    (   length(OtherPR, B),
        B>0,
        B<NewMinLen
    ->  NewNewMinLen=B
    ;   NewNewMinLen=NewMinLen
    ),
    MyRes=[RevPR, OtherPR],
    delete(MyRes, [], AppendToRes),
    append(AppendToRes, ResultList, NewResult),
    %string_to_list(ForPrintOther, OtherPR),
    %write_ln(ForPrintOther),
    print1(DPArray, CurrentLen, NewResult, NewNewMinLen, NewI, Res).

print(_, _, 65) :-
    !.
print(DPArray, CurrentLen, I) :-
    NewI is I+1,
    get3D(Print, [I, CurrentLen, 1], DPArray),
    reverse(Print, RevPR),
    string_to_list(ForPrint, RevPR),
    write(ForPrint),
    write(" , "),
    get3D(Other, [I, CurrentLen, 2], DPArray),
    reverse(Other, OtherPR),
    string_to_list(ForPrintOther, OtherPR),
    write_ln(ForPrintOther),
    print(DPArray, CurrentLen, NewI).

recursiveFooAUX(DPArray, NextMove, Cell, CurrentInput, CurrentComplementedInput, CurrentLen) :-
    (   get3D(Value, Cell, DPArray),
        Value=[]
    ->  insert3D(NextMove, Cell, DPArray),
        recursiveFoo(DPArray, Cell, CurrentInput, CurrentComplementedInput, CurrentLen)
    ).   
recursiveFooAUX(DPArray, NextMove, Cell, CurrentInput, CurrentComplementedInput, CurrentLen) :-
    (   get3D(Value, Cell, DPArray),
        length(Value, ExistingLength),
        length(NextMove, NewLength),
        ExistingLength>NewLength
    ->  insert3D(NextMove, Cell, DPArray),
        recursiveFoo(DPArray, Cell, CurrentInput, CurrentComplementedInput, CurrentLen)
    ).

% FIXME na elegxw ta oria sto telos
% Na prosexw apo poy vazw kai apo pou vgazw
% vazw kai vgazw apo thn arxh enw sthn python apo to telos
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [I, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    complementRNA(CurrentChar, ComplementedCurrentChar),
    nth1(1, State, ComplementedCurrentChar),
    append([112, 99], CurrentValue, NextMove),
    notK(K, NewK),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [I, NewJ, NewK],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).
    
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    complementRNA(CurrentChar, ComplementedCurrentChar),
    not(member(ComplementedCurrentChar, State)),
    append([112, 99], CurrentValue, NextMove),
    notK(K, NewK),
    append([ComplementedCurrentChar], State, NewState),
    possibleStatesNum(NewState, NewI),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, NewK],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    complementRNA(CurrentChar, ComplementedCurrentChar),
    last(State, ComplementedCurrentChar),
    append([112, 114, 99], CurrentValue, NextMove),
    reverse(State, NewState),
    possibleStatesNum(NewState, NewI),
    notK(K, NewK),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, NewK],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).    
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    complementRNA(CurrentChar, ComplementedCurrentChar),
    not(member(ComplementedCurrentChar, State)),
    append([112, 114, 99], CurrentValue, NextMove),
    reverse(State, AlmostNewState),
    append([ComplementedCurrentChar], AlmostNewState, NewState),
    possibleStatesNum(NewState, NewI),
    notK(K, NewK),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, NewK],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).   
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [I, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    nth1(1, State, CurrentChar),
    append([112], CurrentValue, NextMove),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [I, NewJ, K],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    not(member(CurrentChar, State)),
    append([112], CurrentValue, NextMove),
    append([CurrentChar], State, NewState),
    possibleStatesNum(NewState, NewI),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, K],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).
again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    last(State, CurrentChar),
    append([112, 114], CurrentValue, NextMove),
    reverse(State, NewState),
    possibleStatesNum(NewState, NewI),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, K],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).

again(NewJ, CurrentChar, State, CurrentValue, DPArray, [_, _, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    not(member(CurrentChar, State)),
    append([112, 114], CurrentValue, NextMove),
    reverse(State, AlmostNewState),
    append([CurrentChar], AlmostNewState, NewState),
    possibleStatesNum(NewState, NewI),
    recursiveFooAUX(DPArray,
                    NextMove,
                    [NewI, NewJ, K],
                    CurrentInput,
                    CurrentComplementedInput,
                    CurrentLen).

recursiveFoo(_, [_, J, _], _, _, K) :-
    J is K,
    !.

recursiveFoo(DPArray, [I, J, K], CurrentInput, CurrentComplementedInput, CurrentLen) :-
    NewJ is J+1,
    nth1(NewJ, CurrentInput, OriginalChar),
    nth1(NewJ, CurrentComplementedInput, ComplementedChar),
    (   K=1
    ->  CurrentChar=OriginalChar
    ;   CurrentChar=ComplementedChar
    ),
    possibleStates(AlmostState, I),
    string_to_list(AlmostState, State),
    get3D(CurrentValue, [I, J, K], DPArray),
    !,
    again(NewJ,
          CurrentChar,
          State,
          CurrentValue,
          DPArray,
          [I, J, K],
          CurrentInput,
          CurrentComplementedInput,
          CurrentLen).
   






    %(   not(member(CurrentChar, State))
    %->  append([112, 114], CurrentValue, NextMove),
    %    reverse(State, AlmostNewState),
    %    append([CurrentChar], AlmostNewState, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, K],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   last(State, CurrentChar)
    %->  append([112, 114], CurrentValue, NextMove),
    %    reverse(State, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, K],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   not(member(CurrentChar, State))
    %->  append([112], CurrentValue, NextMove),
    %    append([CurrentChar], State, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, K],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %     % EWS EDW
    %(   nth1(1, State, CurrentChar)
    %->  append([112], CurrentValue, NextMove),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [I, NewJ, K],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   complementRNA(CurrentChar, ComplementedCurrentChar),
    %    not(member(ComplementedCurrentChar, State))
    %->  append([112, 114, 99], CurrentValue, NextMove),
    %    reverse(State, AlmostNewState),
    %    append([ComplementedCurrentChar], AlmostNewState, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    notK(K, NewK),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, NewK],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   complementRNA(CurrentChar, ComplementedCurrentChar),
    %    last(State, ComplementedCurrentChar)
    %->  append([112, 114, 99], CurrentValue, NextMove),
    %    reverse(State, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    notK(K, NewK),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, NewK],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   complementRNA(CurrentChar, ComplementedCurrentChar),
    %    not(member(ComplementedCurrentChar, State))
    %->  append([112, 99], CurrentValue, NextMove),
    %    notK(K, NewK),
    %    append([ComplementedCurrentChar], State, NewState),
    %    possibleStatesNum(NewState, NewI),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [NewI, NewJ, NewK],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %),
    %(   complementRNA(CurrentChar, ComplementedCurrentChar),
    %    nth1(1, State, ComplementedCurrentChar)
    %->  append([112, 99], CurrentValue, NextMove),
    %    notK(K, NewK),
    %    recursiveFooAUX(DPArray,
    %                    NextMove,
    %                    [I, NewJ, NewK],
    %                    CurrentInput,
    %                    CurrentComplementedInput,
    %                    CurrentLen)
    %).
