val new = Array2.array  
val update = Array2.update
val sub = Array2.sub
val cage = new(1000,1000,0:int)

val a = hd(CommandLine.arguments ())
fun readChr input = Option.valOf(TextIO.scanStream String.scan input);
val inStream = TextIO.openIn a;

fun   readline ((#"X")::tail) i j airports start endH virus = (update(cage, i, j, ~1) ;                 readline tail i (j + 1) airports start endH virus)
    | readline ((#"S")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports [i,j] endH virus)
    | readline ((#".")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports start endH virus)
    | readline ((#"W")::tail) i j airports start endH virus = (update(cage, i, j, 0) ;                  readline tail i (j + 1) airports start endH [i, j])
    | readline ((#"T")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports start [i,j] virus)
    | readline ((#"A")::tail) i j airports start endH virus = (update(cage, i, j, ~2) ;                 readline tail i (j + 1) ([i,j]::airports) start endH virus)
    | readline [] i j airports start endH virus = (print("next line\n") ; readmap inStream (i+1) j airports start endH virus) 
    (*| readline _ _ _ = ()*)
    
and readmap inStream i j airports start endH virus =
let
    val test = readChr inStream (* String *)
    val _ = TextIO.inputLine inStream
    val explodedtest = explode test  (* List of chars *)
    val _ = print(test)
    val _ = print("\n")
in
    if (explodedtest = []) then (i-1, j-1, airports, start, endH, virus)
    else readline explodedtest i 0 airports start endH virus
end

val (a,b,c,d,e,f) = readmap inStream 0 0 [] [] [] [];