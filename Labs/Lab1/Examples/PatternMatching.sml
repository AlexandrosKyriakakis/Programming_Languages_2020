fun factorial 0 = 1
    | factorial n = n * factorial (n-1)

fun length [] = 0
    | length (x::xs) = 1 + length xs

fun factorial2 n =
    case n of 0 => 1
        | m => m * factorial2 (m-1)

fun length2 l =
    case l of  [] => 0
        | x::xs   => 1 + length xs

fun fst (z,_) = z;

fun snd a = #2 ;