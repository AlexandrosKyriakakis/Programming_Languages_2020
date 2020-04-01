datatype 'a tree  = Empty | Node of 'a * 'a tree * 'a tree

fun leaflist (Empty, acc) = acc
  | leaflist (Node(n, Empty, Empty), acc) = n::acc
  | leaflist (Node(n, left, right), acc) = 
  leaflist (left, leaflist(right, acc))

 val t2 = Node(10,Node(1,Node(2,Node(4,Empty,Empty),Empty),Node(3,Empty,Empty)),Node(5,Empty,Empty));
 leaflist (t2,[]);
