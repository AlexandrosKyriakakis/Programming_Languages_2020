# Algorithm for Vaccine Problem

## Input

- While reading the file at the same time create the complemented string

## Build 3D Array

1. The length of given string is the first dimentsion.
2. All 64 subsets (powerset) of [a,b,c,d] and all permutations of them is the second dimension.
3. One more level of the above 2D-Array holding the information of Reversion is the third dimention.

- Every cell of the above array holds the path to the current cell [pprcppp...].

## Build the function to fill the Array

### The function has input a Cell.

- If the next char is the same as the front then just push.
- If not then try reverse - push (in-case char is the same as tail)
  and complement - push (in-case char is contained).
- If none of [rp,cp] work try reverse - complement - push.
- At each of the above cases check if the length of the contained string is bigger. Hold the smaller string.
