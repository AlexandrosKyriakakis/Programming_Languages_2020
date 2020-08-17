datatype 'a tree  = Empty | Node of 'a * 'a tree * 'a tree;

fun leaflist (Empty, acc) = acc
  | leaflist (Node(n, Empty, Empty), acc) = n::acc
  | leaflist (Node(n, left, right), acc) = 
  leaflist (left, leaflist(right, acc));

val t2 = Node(10,Node(1,Node(2,Node(4,Empty,Empty),Empty),Node(3,Empty,Empty)),Node(5,Empty,Empty));
leaflist (t2,[]);
val k = 2;
fun floor (Empty : int tree) = 0
   | floor (Node(n, Empty, Empty) : int tree) = n
   | floor (Node(n, left, right) : int tree) = 
      let 
         val numleft = floor left
         val numright = floor right
         val mylist = [n,numright,numleft]
         val filterd = List.filter (fn x => (x <= 2)) mylist
         fun getmax (mymax, h::nil, true) = mymax
            | getmax (mymax, h::nil, false) = h
            | getmax (mymax, f::s::t, true) = getmax (mymax, s::t, mymax >= s)
            | getmax (mymax, f::s::t, false) = getmax (f, s::t, mymax >= s)
      in
         if (filterd = nil) then 0
         else (getmax (~1, filterd, false))
      end;
