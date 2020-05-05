/*
use_module(library(logarr)).
expects_dialect(sicstus).
*/
autoload_path(library(rbtrees)).
myarray(Z):- new_array(X), aset(0,X,12,Y), aref(0,Y,Z).

