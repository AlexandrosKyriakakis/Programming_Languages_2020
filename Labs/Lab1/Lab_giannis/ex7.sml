fun mergesort [] = []
	| mergesort [a] = [a]
	| mergesort (x) = 
	let 
		fun halve nil = (nil, nil)
		| halve [a] = ([a], nil)
		| halve (a::b::cs) = 
		let
			val (x,y) = halve cs
		in
			(a::x, b::y)
		end
		val (a,b) = halve x

		fun merge ([],[]) = []
			| merge (fs,[]) = fs
			| merge ([],gs) = gs
			| merge (f::fs,g::gs) =
				if (f < g) then f :: merge(fs, g::gs)
							else g :: merge (f::fs,gs) 
	in merge (mergesort a, mergesort b)
	end			


	
