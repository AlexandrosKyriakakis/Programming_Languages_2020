datatype btree = Empty | Leaf | Node of btree * btree

fun cntleaves Empty = 0
    | cntleaves Leaf = 1
    | cntleaves (Node (tree1, tree2)) =
        (cntleaves tree1) + (cntleaves tree2);
;
val tree = Node (Node (Leaf, Leaf), Leaf);
