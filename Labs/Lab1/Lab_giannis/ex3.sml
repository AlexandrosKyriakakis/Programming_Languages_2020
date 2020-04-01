fun halve x =
	let
		fun take(xs, n) =
		if n < 0 
		then raise Subscript
		else 
			case xs of 
				[] => []
		  	| (x::xs') => if n > 0 then x::take(xs',n-1) else []

		fun listLength [] = 0
            | listLength (h::t) = 1 + listLength t

        val len = ((listLength(x)) div 2) 


        fun drop(xs, n) =
			if n < 0 then raise Subscript
			else if n = 0 then xs
			else 
				case xs of 
						[] => []
		  		| (_::xs') => drop(xs', n-1)
		  	in
		  		(take(x,len),drop(x,len))
		  	end