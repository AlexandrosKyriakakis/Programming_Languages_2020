fun fordown n =  
    if n < 0 then ()
    else ( print (Int.toString (n*n)); print "\n"; fordown(n-1) ); 
fordown 16;

(*
fun prntlst acc =
    (*if (acc = []) then ()
    else (print (Int.toString ()));*)
    print (Int.toString (acc));
*)

fun forlst n acc =
    if n < 0 then map (fn x => print (Int.toString(x) ^ "\n") ) acc
    else forlst (n-1) ((n*n)::acc);
forlst 16 [];

fun make_list n =
    let fun loop 0 result = result
        | loop i result = loop (i-1) (i::result)
    in
     loop n []
    end;


fun len [] = 0
    | len (h::t) = 1 + len t;
make_list 4;
len it;
(* Tail recursive*)
fun len2 l = 
    let fun aux [] i = i
        | aux (h::t) i = aux t (i+1)
    in
        aux l 0
    end;
len2 (make_list 4);