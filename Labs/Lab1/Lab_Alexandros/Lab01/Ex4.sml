fun perfectNumbersCheck Number = 
    let fun check_i i bound accum =
            if i >= bound then accum
            else 
                if ((bound mod i) = 0) then check_i (i+1) (bound) (accum + i)
                else check_i (i+1) bound accum
    in
        check_i 2 Number 1 = Number
    end;

fun checkMany j =
    let fun aux i accum =
        if i = 0 then accum
        else if perfectNumbersCheck i then aux (i-1) (i::accum)
        else aux (i-1) accum
    in 
        aux j []
    end;
checkMany 1000;
