
(* Πηγαινει πάνω κατω αριστερα δεξια και αφου ελεγξει με άλλη συνάρτηση αν 
    ειναι fisible προσθετει τις τουπλες στην ουρα *)

(*
S . . . . . . W
. . . . . . . X
X . X . . . . .
W X . . . . . .
. . . . . . . T 
        W    W
S
7 6 5 4 3 2 1 0
8 7 6 5 4 3 2 X
X 8 X 6 5 4 3 4
W X 4 5 6 5 4 5
1 2 3 4 5 6 5 T 
S
+0 +1 +2 +3 \3 \2 \1 \0
+1 +2 +3 +4 \4 \3 \2 \X
\X +3 \T +5 \5 \4 \3 \4
\W \X \4 \5 \6 \5 \4 \5
\1 \2 \3 \4 \5 \6 \5 \6 






        W    W
QUE [(7,0),(0,3)]
AIRPORTS [air1,air2,...]
RECURSION (hd(QUE)) 
        val c = timh_pinaka((7,0)) 
        gia kathe ena i -> [(8,0),(6,0),(7,-1),(7,1)] -> (R, L, U, D)
        if (allowed(i,c) && timh_pinaka(i) > c+1) -> timi_pinaka(i) = c+1
            QUE.append(i)
        AIRPORTS !!!

ALLOWED(N,M,(a,b), QUE, c )
    (* vgainw ektos orion*)
    val out_of_bounds = (a<0) orelse (b<0) orelse (a > N) orelse (b > N)
    (* einai AIRPORT*)
    if timh_pinaka(a,b) == -2 -> gia kathe j in [AIRPORTS] 
                                    timi_pinaka(c + 5)
                                    kai QUEUE.append(AIRPORTS)
*)


(*FIXME LIST allowed check parrent before itteration*)
val new = Array2.array;
val update = Array2.update;
val sub = Array2.sub;
val cage = new(1000,1000,0:int);
val a = hd(CommandLine.arguments ())
fun readChr input = Option.valOf(TextIO.scanStream String.scan input);
val inStream = TextIO.openIn a;

fun   readline ((#"X")::tail) i j airports start endH virus = (update(cage, i, j, ~1) ;                 readline tail i (j + 1) airports start endH virus)
    | readline ((#"S")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports [i,j] endH virus)
    | readline ((#".")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports start endH virus)
    | readline ((#"W")::tail) i j airports start endH virus = (update(cage, i, j, 0) ;                  readline tail i (j + 1) airports start endH [i, j])
    | readline ((#"T")::tail) i j airports start endH virus = (update(cage, i, j, valOf Int.maxInt) ;   readline tail i (j + 1) airports start [i,j] virus)
    | readline ((#"A")::tail) i j airports start endH virus = (update(cage, i, j, ~2) ;                 readline tail i (j + 1) ([i,j]::airports) start endH virus)
    | readline [] i j airports start endH virus = readmap inStream (i+1) j airports start endH virus
    (*| readline _ _ _ = ()*)
    
and readmap inStream i j airports start endH virus =
let
    val test = readChr inStream (* String *)
    val _ = TextIO.inputLine inStream
    val explodedtest = explode test  (* List of chars *)
in
    if (explodedtest = []) then (i-1, j-1, airports, start, endH, virus)
    else readline explodedtest i 0 airports start endH virus
end

val (N, M, airports, start, endH, virus) = readmap inStream 0 0 [] [] [] []

fun recursiveFoo ([]:int list list, N, M) = []
|   recursiveFoo ([i,j]::tail, N, M) = 
    let
        val cell_price = sub(cage,i,j)
        val neighbors = [[i,j+1],[i,j-1],[i-1,j],[i+1,j]]
        
        fun choose ([],acum) = acum
            | choose ([neighbor_i,neighbor_j]::tail2,acum) = 
                if (allowed(N,M,[neighbor_i,neighbor_j],cell_price+1) andalso sub(cage,neighbor_i,neighbor_j) > cell_price+1)
                then
                    let 
                        val _ = update(cage,neighbor_i,neighbor_j,cell_price+1)
                    in
                        choose(tail2, acum@[[neighbor_i,neighbor_j]])
                    end
                else choose(tail2,acum)
    in
        recursiveFoo(choose(neighbors,tail),N,M)
    end

and allowed (N,M,[a,b],cell_price) = 
    if ( (a<0) orelse (b<0) orelse (a > N) orelse (b > M) )
    then (false)
    else 
        if ( sub(cage,a,b) = ~2 )
        then
            let
                fun priceToAir([]:int list list) = ()
                |   priceToAir([air_i,air_j]::tail) = 
                    let
                        val _ = update(cage, air_i, air_j, cell_price+5) 
                    in
                        priceToAir(tail)
                    end
                val _ = priceToAir(airports)
                val _ = recursiveFoo(airports,N,M)
            in 
                (true)
            end
        else (true);


fun printGrid i N M grid =
  if (i >= N+1) then ()
  else
    (
      let
        fun printRow j M =
          if (j >= M + 1) then ()
          else (print (Int.toString(Array2.sub(grid, i, j))); print(" ") ; printRow (j+1) M)
      in
        printRow 0 M;
        print("\n");
        printGrid (i + 1) N M grid
      end
    )
(*
val _ = printGrid 0 N M cage
*)
val _ = recursiveFoo([virus],N,M);
val _ = print(Int.toString(15)^"\n"^"RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR")
(*
Minor Optimization: Do REal BFS with LIFO Done and Done!!!
*)