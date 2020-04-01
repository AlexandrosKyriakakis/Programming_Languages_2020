(* a *)

print (Int.toString(42));

(* b *)

fun foo () = 42;
foo ();

(* c *)

fun inc x = x + 1;
fun f n = inc 1; (* Unmatched types boolean != int *)

(* d *)

fun divide_by_two x = x/Real.fromInt(2) ;

(* e *)
(*
datatype 'a btree = Leaf of 'a | Node of 'a btree * 'a btree 

fun preorder Leaf(v) = [v]
    | preorder Node(l,r) = preorder l @ preorder r
(* st *)
    
datatype 'a option = NONE | SOME of 'a 

fun filter pred l =
    let fun filterP (x::r, l) = 
        case (pred x) of
            SOME y => filterP (r, y::l) 
          | NONE => filterP (r, l)
      | filterP ([], l) = rev l 
    in
        filterP (l, [])
    end

let val e =  (* unbounded e *)
    5 and f = 
        e + 1 
            in e + f 
            end;
*) 
val (x,y) = (42,42);

fun f 0 = "zero"
    | f _ ="nonzero"
           (* | (x,y,z) => x + y + z + 2*)

fun h (x::xs) = x + 1;

val succ = op + 1