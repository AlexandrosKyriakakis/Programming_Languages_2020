fun auxOddEven ([], last ,acum, curmax)= curmax
   | auxOddEven (h::t, last ,acum, curmax)= 
      if ((h mod 2) = (last mod 2)) then (
         if (acum > curmax) then (auxOddEven (t,h,1,acum))
         else (auxOddEven (t,h,1,curmax)) 
      )
      else (auxOddEven (t,h,acum+1,curmax))
fun oddeven (nil) = 0
   | oddeven (h::t) = auxOddEven (t,h,1,0) 

oddeven ([1,2,3]);

