val node = Array.array(1000000,([]:int list));
val degree = Array.array(1000000,0);
val numOfChildren = Array.array(1000000,0);
val lastFather_NumVisited_NumFinal = Array.array(3,0);

fun printlist nil = ()
    | printlist x =
    let
        fun printl (h::nil) = print (Int.toString (h) ^"\n")
          | printl (h::t) = (print (Int.toString(h)^" ") ; printl t)
          | printl [] = ()
        in 
            (printl x)
        end;


(* Parse degree to find leafs and retyrn list of the indexes*)
fun initNode (0) = ()
    | initNode n = 
        let 
            val stopError = Array.update(node,n-1,[])
            val stopError = Array.update(degree,n-1,0)
            val stopError = Array.update(numOfChildren,n-1,0)
            val stopError = if (n<3) then Array.update(lastFather_NumVisited_NumFinal,n,0) else ()
        in
            initNode (n-1)
        end

fun make_adj [] = ()
    | make_adj (last_element :: nil) = ()
    | make_adj (first_element :: second_element :: rest) = 
        (Array.update(node, first_element, (second_element :: Array.sub(node, first_element))) ;
        Array.update(node, second_element, (first_element :: Array.sub(node, second_element))) ;
        Array.update(degree,first_element, (Array.sub(degree,first_element) + 1));
        Array.update(degree,second_element, (Array.sub(degree,second_element) + 1));
            make_adj(rest))


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


fun parseDegree (index, false, acumm, N) = acumm
    | parseDegree (index, true, acumm, N) =  
        let 
            val arrayAtIndex = Array.sub(degree,index);
        in
            (* [0,0] is an indicator for "NO CORONA"*)
            if (arrayAtIndex = 0) then ([0,0]) 
            else (
                if (arrayAtIndex = 1) then (parseDegree (index+1, index+1<(N), (index::acumm), N))
                else (parseDegree (index+1, index+1<(N), acumm, N))
            )
        end;
    
fun recursiveFoo ([]) = ([])
    | recursiveFoo (leaf::tail) = 
        let 

            (* Take a random leaf and find his father *)
            (* 
            val _ = print("Got in recursiveFoo\n"); 
            *)
            val adjLeaf = Array.sub(node,leaf)
            
        in 
            if (adjLeaf = []) then ([0,0])
            else   
                let
                    val father = hd(adjLeaf)
                    (* val _ = print(Int.toString(father)^ "\n"); *)
                    
                    (* Erase edge to leaf from fathers list *)
                    val temp = Array.sub(node,father)
                    val temp = List.filter (fn x => (x <> leaf)) temp
                    val stopError = Array.update(node,father,temp)

                    (* Decrease fathers degree*)
                    val fathersDegree = Array.sub(degree,father) - 1
                    val stopError = Array.update(degree, father, fathersDegree)
                    (* Add children *)
                    val temp = Array.sub(numOfChildren,leaf) + Array.sub(numOfChildren,father) + 1
                    val stopError = Array.update(numOfChildren, father, temp)

                    (* Increase number of visited and update last father*)
                    val stopError = Array.update(lastFather_NumVisited_NumFinal, 0, father)
                    val temp = Array.sub(lastFather_NumVisited_NumFinal, 1) + 1
                    val stopError = Array.update(lastFather_NumVisited_NumFinal, 1, temp)
                in
                    if (fathersDegree = 1) then (recursiveFoo (father::tail))
                    else (recursiveFoo (tail))
                end
        end;
(* Check NumVisited and father before*) (* isFisible and ended must go *)
fun randomWalk (ended, randomUnvisitedNode, acum, numFinalRoots) =
        let
            (*
            val _ = print("Got in RandoMWalk\n")
            *)
            val firstFather = Array.sub(lastFather_NumVisited_NumFinal,0)
            (* if degree > 2 not simple cycle *)
            val degreeOfRdNode = Array.sub(degree,randomUnvisitedNode)
            (* Increase visited *)
            val temp = Array.sub(lastFather_NumVisited_NumFinal,1) + 1
            val stopError = Array.update(lastFather_NumVisited_NumFinal, 1, temp)
            val addToAcum = Array.sub(numOfChildren,randomUnvisitedNode) + 1
            (* Take random neighboor *)
            val temp = Array.sub(node,randomUnvisitedNode)
            val tempFather = hd(temp)
            (* Remove from adjastency list of random neighboor randomUnvisitedNode *)
            val temp = Array.sub(node,tempFather)
            val temp = List.filter (fn x => (x <> randomUnvisitedNode)) temp
            val stopError = Array.update(node,tempFather,temp)
        in
            if (degreeOfRdNode > 2) then ([0,0],0)
            else (  if (ended) then (mergesort acum,numFinalRoots)
                    else (randomWalk (tempFather = firstFather,tempFather, addToAcum::acum, numFinalRoots+1))
            )
        end;

fun doTheJob (N) =
    let
        (* 
        val _ = print ("got in DoTheJob\n"); 
        *)
        val test = parseDegree(0, 0<N, [], N);
        (* val _ = printlist(test); *)
        val stopError = recursiveFoo  (parseDegree(0, 0<N, [], N)) (* Returns None*)
        (* val _ = print ("got in 2\n"); *)
        val firstFather = Array.sub(lastFather_NumVisited_NumFinal,0)
        (* Cycle at least size 3 and  *)
        val num = Array.sub(lastFather_NumVisited_NumFinal,1) > (N) - 3;
        (* Last father should not empty *)
        val orNum = Array.sub(node,Array.sub(lastFather_NumVisited_NumFinal,0)) = [];
        val isNotFisible = num orelse orNum;
    in
        if (isNotFisible = true orelse stopError = [0,0]) then ([0,0],0)
        else(randomWalk( false, firstFather, [], 0))
    end;
    
fun printRes (resList, resNum) = 
    if (resList = [0,0]) then (print ("NO CORONA\n"))
    else (print ("CORONA "^Int.toString(resNum)^"\n"); printlist resList)

fun parse file =
    let
  (* A function to read an integer from specified input. *)
        fun readInt input = 
                Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        

        (* Open input file. *)
        val inStream = TextIO.openIn file
        (* Read an integer (number of graphs and consume newline. *)
        val t = readInt inStream
        val _ = TextIO.inputLine inStream
        fun readgraph 0  = ()
            | readgraph num  = 
                let 
                    val n = readInt inStream;
                    val m = readInt inStream;
                    (* val _ = print(Int.toString(n)); *)
                    val _ = TextIO.inputLine inStream;
                    val _ = initNode n;
                    (* A function to read N integers from the open file. *)
                    fun readInts 0 acc = rev acc 
                    | readInts i acc = readInts (i - 1) ((readInt inStream - 1) :: acc)
                    val res = readInts (2*m) [];
                    (* val _ = printlist res; *)
                    val hi = make_adj (res);
                    (* val _ = print("made adj"); *)
                    val resol = doTheJob(n);
                    (* val _ = print("did the job"); *)
                    val _ = printRes (#1 resol, #2 resol); 
                in
                    readgraph (num - 1)
                end;
    in
        readgraph t 
    end;

val a = hd(CommandLine.arguments ())
val _ = parse a;

