fun printlist nil = print("[]" ^ "\n")
	| printlist x =
	let
		fun printl (h::nil) = print (Int.toString (h) ^"]" ^"\n")
		  | printl (h::t) = (print (Int.toString(h) ^ ", ") ; printl t)
		in 
			(print("[") ; printl x)
		end
