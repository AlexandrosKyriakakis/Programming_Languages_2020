val pow2 = ()
fun recursiveFoo N K lastelem resultList= (* result list start with [0]*)
    if (K>N) then []
    else if (K = 0 andalso N != 0) then []
    else if (K = 0 andalso N = 0) then resultList
         else 
            let val delta = IntInf.log2(N-K+1)
                val powDelta = IntInf.pow(2,delta)
                fun addZeros resultList lastelem delta=
                    if (lastelem = delta) then resultList
                    else addZeros (0::resultList) (lastelem-1) delta

            in
                if (delta != lastelem) 
                    then recursiveFoo (N-powDelta) (K-1) delta 1::(addZeros resultList)
                else  recursiveFoo (N-powDelta) (K-1) delta (((hd resultList)+1) :: (tl resultList))
            end;

fun findLog2 = ...


fun findPow2 = ...