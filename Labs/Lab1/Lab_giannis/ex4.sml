fun is_perfect n =
	let fun add_factors 1 = 1 
		| add_factors m = 
		if n mod m = 0
		then m + add_factors (m-1)
		else add_factors (m-1)
	in
		(n < 2) orelse (add_factors (n div 2) = n)
	end
