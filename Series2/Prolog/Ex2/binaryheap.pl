% Taken from Pierre https://stackoverflow.com/questions/9051781/how-can-make-array-in-prolog
:- module(arraysim, [insertAS/4,getAS/3]).
%------------------------------------------------------------------------    
%
% AUTHOR: Pierre
%
% USE OF A BINARY TREE TO STORE AND ACCESS ELEMENTS INDEXED FROM THE
% SET OF POSITIVE INTEGERS, I.E. SIMULATION OF SPARSE ARRAYS.
%
% Provide predicates:
% = =================
%
% insertAS(+Value,+Index,+Tree,-NewTree) to insert/rewrite Value at node
% of index Index in Tree to produce NewTree.
%
% getAS(-Value,+Index,+Tree): to get the Value stored in node of index
% Index in Tree. Value is nil if nothing has been stored in the node
% (including the case when the node was never created).
%
% User note:
% =========
%
% assume indexation starts at 1.
% The empty Tree is [].
%
% Data Structure:
% ==============
%
% The nodes of the binary tree are indexed using the indexing scheme
% employed to implement binary heaps using arrays. Thus, the indexes of
% elements in the tree are defined as follows:
%
% The index of the root of the tree is 1
% The index of a left child is twice the index of the parent node
% The index of a right child is twice the index of the parent node plus
% one.
%
% A tree is recursively represented as a triple:
% [Value,LeftTree,RightTree] where Value is the value associated with
% the root of the tree. if one of LeftTree or RightTree is empty this
% tree is represented as an empty list.
%
% However, if both left and right tree are empty the tree (a leaf node)
% is represented by the singleton list: [Value].
%
% Nodes that correspond to an index position whose associated value has
% not been set, but are used to access other nodes, are given the
% default value nil.
%
% Complexity:
% ==========
%
% Insertion (insertAS) and extraction (getAS) of the element at index i
% runs in Theta(log_2(i)) operations.
%
% The tree enables to store sparse arrays with at most a logarithmic (in
% index of element) storage cost per element.
%
% Example of execution:
% ====================
%
% 10 ?- insertAS(-5,5,[],T), insertAS(-2,2,T,T1),
% | insertAS(-21,21,T1,T2), getAS(V5,5,T2),
% | getAS(V2,2,T2),getAS(V10,10,T2),getAS(V21,21,T2).
% T = [nil, [nil, [], [-5]], []],
% T1 = [nil, [-2, [], [-5]], []],
% T2 = [nil, [-2, [], [-5, [nil, [], [-21]], []]], []],
% V5 = -5,
% V2 = -2,
% V10 = nil,
% V21 = -21.
%
%------------------------------------------------------------------------


%------------------------------------------------------------------------
%
% find_path(+Index,-Path)
%
% Given an index find the sequence (list), Path, of left/right moves
% from the root of the tree to reach the node of index Index.
%
%------------------------------------------------------------------------

find_path(Index,Path):-
    integer(Index),
    Index > 0,
    find_path2(Index,[],Path).

%-----------------------------------------------------------------
%
% find_path2(+Index,+Acc,-Path)
%
% Use of an accumulator pair to ensure that the sequence is in the
% correct order (i.e. starting from root of tree).
%
%-----------------------------------------------------------------


find_path2(1,Path,Path):-!.
find_path2(Index,Path,ReturnedPath):-
    Parity is Index mod 2,
    ParentIndex is Index div 2,
(   Parity =:= 0
->  find_path2(ParentIndex,[left|Path],ReturnedPath)
;   find_path2(ParentIndex,[right|Path],ReturnedPath)
).

%-----------------------------------------------------------------
%
% insertAS(+Value,+Index,+Tree,-NewTree)
%
% Insert Value at node of index Index in Tree to produce NewTree.
%
%-----------------------------------------------------------------

insertAS(Value,Index,Tree,NewTree):-
    find_path(Index,Path),
    insert(Value,Path,Tree,NewTree),!.

%-----------------------------------------------------------------
%
% insert(+Value,+Path,+Tree,-NewTree)
%
% Insert Value at position given by Path in Tree to produce
% NewTree.
%
%-----------------------------------------------------------------

% insertion in empty tree
%
insert(Value,[],[],[Value]).
insert(Value,[left|P],[],[nil,Left,[]]):-
    insert(Value,P,[],Left).
insert(Value,[right|P],[],[nil,[],Right]):-
    insert(Value,P,[],Right).

% insertion at leaf node
%
insert(Value,[],[_],[Value]).
insert(Value,[left|P],[X],[X,Left,[]]):-
    insert(Value,P,[],Left).
insert(Value,[right|P],[X],[X,[],Right]):-
    insert(Value,P,[],Right).

% insertion in non-empty non-leaf tree
%
insert(Value,[],[_,Left,Right],[Value,Left,Right]).
insert(Value,[left|P],[X,Left,Right],[X,NewLeft,Right]):-
    insert(Value,P,Left,NewLeft).
insert(Value,[right|P],[X,Left,Right],[X,Left,NewRight]):-
    insert(Value,P,Right,NewRight).

%-----------------------------------------------------------------
%
% getAS(-Value,+Index,+Tree)
%
% get the Value stored in node of index Index in Tree.
% Value is nil if nothing has been stored in the node
% (including the case when the node was never created).
%
%-----------------------------------------------------------------

getAS(Value,Index,Tree):-
    find_path(Index,Path),
    get(Value,Path,Tree),!.

%-----------------------------------------------------------------
%
% get(-Value,Path,+Tree)
%
% get the Value stored in node with access path Path in Tree.
% Value is nil if nothing has been stored in the node
% (including the case when the node was never created).
%
%-----------------------------------------------------------------

get(nil,_,[]).
get(nil,[_|_],[_]).
get(Value,[],[Value]).
get(Value,[],[Value,_,_]).
get(Value,[left|P],[_,Left,_]):-
    get(Value,P,Left).
get(Value,[right|P],[_,_,Right]):-
    get(Value,P,Right).