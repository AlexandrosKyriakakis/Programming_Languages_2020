datatype 'a tree = Empty | Node of 'a * 'a tree * 'a tree;
val a = Node(   1, 
                    Node (  2, 
                                Node(4,Empty,Empty),Node(5,Empty,Empty)), 
                    Node (  3, 
                                Node(6,Empty,Empty),Node(7,Empty,Empty)));

fun findLeafs (t: 'a tree) acc =
   case t of    Empty => acc
            |   Node ((v: 'a),Empty,Empty) => (v::acc)
            |   Node ((v: 'a), Empty, (r: 'a tree)) => findLeafs r acc
            |   Node ((v: 'a), (l: 'a tree), Empty) => findLeafs l acc
            |   Node ((v: 'a), (l: 'a tree), (r: 'a tree)) => 
                    let 
                        val right = findLeafs l acc;
                        val left = findLeafs r acc;
                    in 
                        right @ left
                    end;
    findLeafs a [];
    

