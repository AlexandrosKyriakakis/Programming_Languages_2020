
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
val a = hd(CommandLine.arguments ());
fun readChr input = Option.valOf(TextIO.scanStream String.scan input);
val inStream = TextIO.openIn a;
(* References *)
val foundTheEnd = ref false;
val adding = ref 2;

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
                if (allowed(N,M,[neighbor_i,neighbor_j],cell_price+(!adding)) andalso sub(cage,neighbor_i,neighbor_j) > cell_price+(!adding))
                then
                    let 
                        val _ = update(cage,neighbor_i,neighbor_j,cell_price+(!adding))
                        val _ = if ([neighbor_i,neighbor_j] = endH) then (foundTheEnd := true) else ()
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

fun allowedHome (N,M,[a,b]) = 
    if ( (a<0) orelse (b<0) orelse (a > N) orelse (b > M) orelse (sub(cage,a,b) < 0) )
    then (false) else (true)
        
fun returnHome ([i, j],revSol: char list, numSol) = 
    if ( allowedHome(N,M,[i,j-1]) andalso (sub(cage,i,j-1) = (sub(cage,i,j)-1)) )
    then ( print("R\n") ;returnHome([i,j-1],(#"R")::revSol,numSol+1)) 
    else (
        if ( allowedHome(N,M,[i,j+1]) andalso (sub(cage,i,j+1) = (sub(cage,i,j)-1)) )
        then (print("L\n"); returnHome([i,j+1],(#"L")::revSol,numSol+1)  )
        else (
            if ( allowedHome(N,M,[i-1,j]) andalso (sub(cage,i-1,j) = (sub(cage,i,j)-1)) )
            then ( print("D\n"); returnHome([i-1,j],(#"D")::revSol,numSol+1) )
            else (
                if ( allowedHome(N,M,[i+1,j]) andalso (sub(cage,i+1,j) = (sub(cage,i,j)-1)) )
                then (  print("U\n") ; returnHome([i+1,j],(#"U")::revSol,numSol+1))
                else (
                    if ([i, j] = start) then (revSol, numSol)
                    else ([#"a",#"l",#"e",#"x"],42)
                )
            )
        )
    )
(* APOTHIKI
val _ = print(Int.toString(15)^"\n"^"RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR")
val _ = printGrid 0 N M cage
*)
val _ = recursiveFoo([virus],N,M);
val [start_i, start_j] = start;
val _ = update(cage,start_i,start_j,0);
val _ = foundTheEnd := false;
val _ = adding := 1;
val _ = recursiveFoo([start],N,M);
val _ = if (!foundTheEnd) then () else ( print("IMPOSSIBLE\n") );
val (ResultList, ResultNum) = returnHome(endH,[],0)
val _ = print(Int.toString(ResultNum)^"\n"^implode(ResultList) ^ "\n")

(*
val _ = printGrid 0 N M cage
Minor Optimization: Do REal BFS with LIFO -> Done and Done!!!
με λεξικογραφική σειρά: down, left, right, up. FIXME
*)