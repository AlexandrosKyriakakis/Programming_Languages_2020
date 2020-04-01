
fun next_String input = (TextIO.inputAll input); (*Inputs Everything from the file*)
CommandLine.arguments (); (*Takes The name of the argument *)
hd it; (* makes it Str from list of Strings*)
val stream = TextIO.openIn it; (* Epens the file *)
val a = next_String stream; (*returns a vector of TextIO.vector*)
explode(a); (* makes the file "things" as list of chars *)
hd it; (*Takes the first char*)
Char.toString(it); (*Makes it String *)
Int.fromString(it); (* Then Int*)
val i : int = valOf (it); (* And last but not least removes the "SOME int option"*)
print(Int.toString(i)^"\n");
OS.Process.exit(OS.Process.success);(*End program*)
(*
Char.isSpace o TextIO.inputAll
*)