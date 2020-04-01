fun powerSet setList = 
    let
        fun parse var [] = ([])
            | parse var (h::t) = [h@[var]] @ (parse var t)
        fun forLoop [](*list = [1,2,3,...]*) acc(*acc = [[]] *)  = acc
            | forLoop (h::t) acc = forLoop t (acc @ parse h acc)
    in 
        forLoop setList [[]]
    end;

powerSet [1,2,3,4,5];
