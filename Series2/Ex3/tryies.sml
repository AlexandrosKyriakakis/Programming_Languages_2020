val new = Array2.array;
val update = Array2.update;
val sub = Array2.sub;
val cage = new(1000,1000,0);
val cell_price = 12;
val airports = [];
fun allowed (N,M,[a,b],queue,cell_price) = 
    if ( (a<0) orelse (b<0) orelse (a > N) orelse (b > M) )
    then (false)
    else 
        if ( sub(cage,a,b) = ~2 )
        then
            let
                fun priceToAir([]) = ()
                |   priceToAir([air_i,air_j]::tail) = 
                    let
                        val _ = update(cage,air_i,air_j,cell_price+5)
                    in
                        priceToAir(tail)
                    end
                val _ = priceToAir(airports)
                (*val stopError = recursiveFoo(airports,N,M)*)
            in 
                (false)
            end
        else (true)

(*
fun my (([i,j])::tail,acum) = 
    if (hd = nil) then acum
    else my(tail,acum + i + j)
fun choose ([],acum) = acum
    | choose ((neighbor_i,neighbor_j)::tail2,acum) = 
       if ((*allowed (N,M(neighbor_i,neighbor_j),cell_price) andalso*) sub(cage,neighbor_i,neighbor_j) > cell_price)
       then
           let 
               val _ = update(cage,neighbor_i,neighbor_j,cell_price+1)
           in
               choose(tail2,(neighbor_i,neighbor_j)::acum)
           end
val cage = new(1000,new(0,0));
fun init2d (arrayName,i) = 
    if (i = 1000) then ()
    else 
        let
            val _ = update(arrayName,i,new(1000,0))
        in 
            init2d(arrayName,i+1)
        end;


fun update2d (arrayName,i,j,newKey) = 
    let 
        val column = sub(arrayName,j) 
        val _ = update(column,i,newKey)
        val _ = update(cage,j,column)
    in
        ()
    end;
fun sub2d (arrayName,i,j) = sub(sub(arrayName,j),i);
*)