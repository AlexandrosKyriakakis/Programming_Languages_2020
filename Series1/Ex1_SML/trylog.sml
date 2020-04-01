fun recursiveFoo N K lastelem resultList= (* result list start with [0]*)
    if (K>N) then []
    else if (K = 0 andalso N != 0) then []
         else 
            let val delta = IntInf.log2(N-K+1)
                val powDelta = IntInf.pow(2,delta)
            in
                if (delta != lastelem) 
                    then recursiveFoo (N-powDelta) (K-1) delta 1::(addZeros resultList)
                else  recursiveFoo (N-powDelta) (K-1) delta ((hd resultList)+1) :: (tl resultList)
            end;
fun addZeros = ...

fun findLog2 = ...

fun findPow2 = ...