


val node = [[3,4,6,8],[4],[5],[0,4,5],[0,1,3],[2,3],[0],[8],[0,7]]
val degree = [4,1,1,3,3,2,1,1,2];
val numOfChildren = Array.array(9,0);
val N = 9;
val lastFather_NumVisited_NumFinal = Array.array(3,0);
(* List to array *)
val node = Array.fromList(node);
val degree = Array.fromList(degree);
(* Parse degree to find leafs and retyrn list of the indexes*)

fun parseDegree (index, false, acumm) = acumm
    | parseDegree (index, true, acumm) =  
        let 
            val arrayAtIndex = Array.sub(degree,index);
        in
            (* [0,0] is an indicator for "NO CORONA"*)
            if (arrayAtIndex = 0) then ([0,0]) 
            else (
                if (arrayAtIndex = 1) then (parseDegree (index+1, index+1<N, (index::acumm)))
                else (parseDegree (index+1, index+1<N, acumm))
            )
        end;
    


fun recursiveFoo ([]) = ()
    | recursiveFoo (leaf::tail) = 
        let 
            (* Take a random leaf and find his father *)
            val temp = Array.sub(node,leaf)
            val father = hd(temp)
            
            (* Erase edge to leaf from fathers list *)
            val temp = Array.sub(node,father)
            val temp = List.filter (fn x => (x <> leaf)) temp
            val stopError = Array.update(node,father,temp)
            
            (* Decrease fathers degree*)
            val fathersDegree = Array.sub(degree,father) - 1
            val stopError = Array.update(degree, father, fathersDegree)
            val temp = Array.sub(numOfChildren,leaf) + Array.sub(numOfChildren,father) + 1
            val stopError = Array.update(numOfChildren, father, temp)

            (* Increase number of visited and update last father*)
            val stopError = Array.update(lastFather_NumVisited_NumFinal, 0, father)
            val temp = Array.sub(lastFather_NumVisited_NumFinal, 1) + 1
            val stopError = Array.update(lastFather_NumVisited_NumFinal, 1, temp)
        in
            if (fathersDegree = 1) then (recursiveFoo (father::tail))
            else (recursiveFoo (tail))
        end;
(* Check NumVisited and father before*) (* isFisible and ended must go *)
fun randomWalk (isNotFisible, ended, randomUnvisitedNode, acum, numFinalRoots) =
        let
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
            if (isNotFisible orelse degreeOfRdNode > 2) then ([0,0],0)
            else (  if (ended) then (acum,numFinalRoots)
                    else (randomWalk (false,tempFather = firstFather,tempFather, addToAcum::acum, numFinalRoots+1))
            )
        end;
recursiveFoo (parseDegree(0, 0<N, [])) ;
(* Cycle at least size 3 and  *)
val num = Array.sub(lastFather_NumVisited_NumFinal,1) > N - 3;
(* Last father should not empty *)
val orNum = Array.sub(node,Array.sub(lastFather_NumVisited_NumFinal,0)) = [];

val isNotFisible = num orelse orNum;
val firstFather = Array.sub(lastFather_NumVisited_NumFinal,0);

(* [0,0] = No corona *)
val a = #1(randomWalk(isNotFisible, false, firstFather, [], 0));
val result = ListMergeSort.sort (fn (s,t) => s > t) a;

(*
fun sort (unsorted) = 
    let
(* Taken from https://github.com/eldesh/z3sml/blob/master/sample/sample.sml *)
        fun merge([], ys) = ys
        |	merge(xs, []) = xs
        |	merge(x::xs, y::ys) =
            if x < y then
                x::merge(xs, y::ys)
            else
                y::merge(x::xs, ys);
                
        fun split [] = ([],[])
        |	split [a] = ([a],[])
        |	split (a::b::cs) = 
                let val (M,N) =
                    split cs in (a::M, b::N)
                end

        fun mergesort [] = []
        |	mergesort [a] = [a]
        |   mergesort [a,b] =	if a <= b then
                                    [a,b]
                                else [b,a]
        |   mergesort L =
                let val (M,N) = split L
                in
                merge (mergesort M, mergesort N)
                end
    in
        mergesort(unsorted)
    end;    
*)

