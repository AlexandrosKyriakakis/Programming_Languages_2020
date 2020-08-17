fun getmax (mymax, h::nil, true) = mymax
   | getmax (mymax, h::nil, false) = h
   | getmax (mymax, f::s::t, true) = getmax (mymax, s::t, mymax >= s)
   | getmax (mymax, f::s::t, false) = getmax (f, s::t, mymax >= s);

val mylist = [1,2,3,45,2,2,1,1,3,4,4,2,1,1,4,2,5,5,55,55,5,5,5,3];
getmax(~1,mylist,false);