#include <iostream>

#define BSIZE 1<<15
using namespace std;
char buffer[BSIZE];
long bpos = 0L, bsize = 0L;
long readLong()
{
    long d = 0L, x = 0L; char c;
    while(1) {
        if (bpos >= bsize) {
            bpos = 0;
            if (feof(stdin)) return x;
            bsize = fread(buffer, 1, BSIZE, stdin);
        }
        c = buffer[bpos++];
        if (c >= '0' && c <= '9') { x = x*10 + (c-'0'); d = 1; }
        else if (d == 1) return x;
    }
    return -1;
}
long long N, H[1000000];


const int tab64[64] = {
    63,  0, 58,  1, 59, 47, 53,  2,
    60, 39, 48, 27, 54, 33, 42,  3,
    61, 51, 37, 40, 49, 18, 28, 20,
    55, 30, 34, 11, 43, 14, 22,  4,
    62, 57, 46, 52, 38, 26, 32, 41,
    50, 36, 17, 19, 29, 10, 13, 21,
    56, 45, 25, 31, 35, 16,  9, 12,
    44, 24, 15,  8, 23,  7,  6,  5};

int log2_64 (uint64_t value)
{
    value |= value >> 1;
    value |= value >> 2;
    value |= value >> 4;
    value |= value >> 8;
    value |= value >> 16;
    value |= value >> 32;
    return tab64[((uint64_t)((value - (value >> 1))*0x07EDD5E59A4E28C2)) >> 58];
}
/*unsigned char _BitScanReverse64(
   unsigned long * Index,
   unsigned __int64 Mask);

unsigned int Log2_ViaBSR(unsigned long value)
{
    unsigned long result;
    _BitScanReverse64(&result, static_cast<unsigned long>(value));
    return result;
}
*/
int main (){
    int N = readLong();
    //std::cin >> N;
    std::cout << log2_64(N) << std::endl;
}