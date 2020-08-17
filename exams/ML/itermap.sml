fun itermap (_, nil) = nil
   | itermap (myfun: int -> int,(hd: int)::(rest: int list)) = (myfun hd)::(itermap (map myfun rest))