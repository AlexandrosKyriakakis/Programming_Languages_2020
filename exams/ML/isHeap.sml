datatype 'd heap  = Empty | Node of 'd * 'd heap * 'd heap;

fun isHeap (Empty) = true
   | isHeap (Node(_,Empty,Empty)) = true
   | isHeap (Node(N,Node(A,L,R),Empty)) = ((N <= A) andalso isHeap(Node(A,L,R)))
   | isHeap (Node(N,Empty,Node(A,L,R))) = ((N <= A) andalso isHeap(Node(A,L,R)))
   | isHeap (Node(N,Node(A,LA,RA),Node(B,LB,RB))) = ((N <= A) andalso (N<=B)  andalso isHeap(Node(A,LA,RA)) andalso isHeap(Node(B,LB,RB)))