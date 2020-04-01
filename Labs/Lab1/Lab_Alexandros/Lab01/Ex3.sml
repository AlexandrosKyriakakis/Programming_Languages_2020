(*fun separateList List = 
    let fun listLength [] = 0
        | listLength (h::t) = 1 + listLength t;
    let val counter = 0;
    let separateListAux [] firstPart length = firstPart
        | separateListAux (h::t) firstPart length =
            
    in 
     
    end
        
    let fun firstHalf [] firstPart = firstPart
        | 
*)
val lst = [1,2,3,4,5,6,6,3,8,6,9,0,4,4,4,4]

fun separateList lst = 
    let    fun listLength [] = 0
            | listLength (h::t) = 1 + listLength t
    
            val median  = (listLength lst) div 2
    
           fun separate [] [] 0 0 false = ([], [])
            | separate lst firstPart counter median true = (firstPart, lst)
            | separate (h::t) firstPart counter median bol = 
                separate t (firstPart@(h::nil)) (counter + 1) median (counter+1>=median)
    in
        separate lst [] 0 median false
    end;

