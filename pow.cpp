//#include <math.h>
#include <iostream>
using namespace std;
/*
int getThePowerOfTwo(int value) {
    static constexpr int twos[] = {
        1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
        1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
        1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23,
        1<<24, 1<<25, 1<<26, 1<<27, 1<<28, 1<<29, 1<<30, 1<<31
    };

    return std::lower_bound(std::begin(twos), std::end(twos), value) - std::begin(twos);
}
//table
static const int8 xs_KotayBits[32] =    {
       0,  1,  2, 16,  3,  6, 17, 21,
       14,  4,  7,  9, 18, 11, 22, 26,
       31, 15,  5, 20, 13,  8, 10, 25,
       30, 19, 12, 24, 29, 23, 28, 27
       };


//only works for powers of 2 inputs
static inline int32 xs_ILogPow2 (int32 v){
   assert (v && (v&(v-1)==0));
   //constant is binary 10 01010 11010 00110 01110 11111
   return xs_KotayBits[(uint32_t(v)*uint32_t( 0x04ad19df ))>>27];
}     
*/
unsigned lookup_log2(unsigned int value)
{
	static const unsigned int twos[] = {
		1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
		1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
		1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23,
		1<<24, 1<<25, 1<<26, 1<<27, 1<<28, 1<<29, 1<<30, 1u<<31
	};

	return std::lower_bound(std::begin(twos), std::end(twos), value) - std::begin(twos);
}
int main () {
    int b = 9;
    int pow2 = 2 << 9;
    int myarray[100];
    memset(myarray,0,100*sizeof(int));
    for (int i = 0; i < 100; i++) cout << myarray[i] << endl; 
    //std::cout <<  pow2 << std::endl;
    return 0;

}