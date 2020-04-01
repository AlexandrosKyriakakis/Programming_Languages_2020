val a = CommandLine.arguments ();
val v1 = Int.fromString(hd a); (* Then Int*)
val v2 = Int.fromString(hd (tl a)); (* Then Int*)
val v_int1 : int = valOf (v1);
val v_int2 : int = valOf (v2);
print (hd a);