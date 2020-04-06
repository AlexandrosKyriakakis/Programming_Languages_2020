fun recursiveFoo N K lastelem resultList = (* result list start with [] and lastelem = 0*)
    if (K > N) then []
    else if (K = 0 andalso N <> 0) then []
    else if (K = 0 andalso N = 0) then resultList
         else 
            let 
              val delta = IntInf.log2(N-K+1)
              (*Do pow with shift*)
              val powDelta = IntInf.pow(2,delta)
              (* addZeros resultList K delta*)
              fun addZeros resultList lastelem delta =
                  if (delta = (lastelem-1)) then resultList
                  else addZeros (0::resultList) lastelem (delta + 1)

            in
                if (delta > lastelem)
                then recursiveFoo (N - powDelta) (K-1) delta (1::resultList)
                else if (delta < lastelem) 
                then recursiveFoo (N - powDelta) (K-1) delta (1::(addZeros resultList lastelem delta))
                else recursiveFoo (N - powDelta) (K-1) delta (((hd resultList)+1) :: (tl resultList))
            end;

fun printlist nil = print("[]" ^ "\n")
    | printlist x =
    let
        fun printl (h::nil) = print (Int.toString (h) ^"]" ^"\n")
          | printl (h::t) = (print (Int.toString(h) ^ ",") ; printl t)
        in 
            (print("[") ; printl x)
        end;

fun parse file =
    let
  (* A function to read an integer from specified input. *)
        fun readInt input = 
      Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  (* Open input file. *)
      val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
  val n = readInt inStream
  val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
  fun readInts 0 acc = rev acc  
    | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
    (n, readInts (2*n) [])

    end
val a = hd(CommandLine.arguments ())
val (n, number_list) = parse a

(*val hello = recursiveFoo d e 0 []
val _ = printlist hello *)
fun do_the_job (0,_) = ()
  | do_the_job (_,[]) = ()
  | do_the_job (k, curr_list) =
  let
    val b = hd(curr_list)
    val c = hd(tl(curr_list))
    val d = Int.toLarge(b)
    val e = Int.toLarge(c)
  in
    if (k > 0) then (printlist(recursiveFoo d e 0 []) ; do_the_job ((k-1),tl(tl(curr_list)))) 
    else ()
  end
val _ = do_the_job(n,number_list);
val _ = OS.Process.exit(OS.Process.success);