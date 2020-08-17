/*
incsubseq([2,1,4,5,4], 3, S).
*/
incsubseq(Mylist, K, S) :-
    distinct(auxincsubseq(Mylist, K, S)).
auxincsubseq(Mylist, K, S) :-
    member(A, Mylist),
    nth0(IndexA, Mylist, A),
    member(B, Mylist),
    nth0(IndexB, Mylist, B),
    IndexA<IndexB,
    member(C, Mylist),
    nth0(IndexC, Mylist, C),
    IndexB<IndexC,
    length(S, K),
    S=[A, B, C],
    msort(S, S).

prime_start(L,[[H|Ta]|T]):-
   member(H,L),
   nth0(IndH,L,H),
   prime(H),
   member(A,L),
   nth0(IndA,L,A),
   IndH < IndA,
   prime_start(L,T).