fun recursiveFoo N K lastelem resultList = (* result list start with [0]*)
    if (K > N) then []
    else if (K = 0 andalso N <> 0) then []
    else if (K = 0 andalso N = 0) then resultList
         else 
            let 
              val delta = IntInf.log2(N-K+1)
              val powDelta = IntInf.pow(2,delta)
              (* addZeros resultList K delta*)
              fun addZeros resultList lastelem delta =
                  if (delta = lastelem) then resultList
                  else addZeros (0::resultList) lastelem (delta + 1)

            in
                if (delta <> lastelem) 
                then
                      recursiveFoo (N - powDelta) (K-1) delta
                else  recursiveFoo (N - powDelta) (K-1) delta (((hd resultList)+1) :: (tl resultList))
            end;

fun printlist nil = print("[]" ^ "\n")
     | printlist x =
     let
         fun printl (h::nil) = print (Int.toString (h) ^"]" ^"\n")
           | printl (h::t) = (print (Int.toString(h) ^ ", ") ; printl t)
         in
             (print("[") ; printl x)
         end
