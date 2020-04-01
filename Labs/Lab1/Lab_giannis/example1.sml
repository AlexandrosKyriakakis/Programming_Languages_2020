fun make_list n = 
  let fun loop 0 result = result 
        | loop i result = loop (i-1) (i::result)
  in 
    loop n []
end

fun len [] = 0
	| len (h::t) = 1 + len t


fun len2 l = 
	let fun aux [] i = i
		|	aux (h::t) i = aux t (i+1)
	in 
		aux l 0
	end

