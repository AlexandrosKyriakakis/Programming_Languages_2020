#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define BSIZE 1<<15

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

int powerOf2[30] = {};
bool flag = 1;
int max_delta = 0;
bool recursiveFoo (int N, int K){
    if (K > N) return 0;
    if (K == 0 && N != 0) return 0;
    
    if (K == 0) return 1;
    else {
        int delta = log2_64(N-K+1);
        if (flag) {
            max_delta = delta;
            flag = 0;
        }
        powerOf2[delta]++;
        // Fastest Power I found it by shifting!!!
        //int pow2 = 1 << delta;
        return recursiveFoo(N - (1 << delta), K - 1);
    }

}

int main (int argc, char** argv){
  /*  
    FILE * pFile;
    int * buffer;
    int lSize;
    pFile = fopen (argv[1], "r");
    size_t result;
    fseek (pFile , 0 , SEEK_END);
    lSize = ftell (pFile);
    rewind (pFile);
    buffer = (int*) malloc (sizeof(int)*lSize);
    result = fread (buffer, 1 , lSize, pFile);
    if (result != lSize) return 1;
    for (int i = 0; i < lSize; i++) {
        std::cout << buffer[i];
    }
     std::cout << std::endl;
}

    
    //result = fread();

    

    int T = readLong();
    */
    
    int N = readLong();
    int K = readLong();

    bool douleuei = recursiveFoo(N,K);
    if(!douleuei) std::cout << "[]" << std::endl;
    else {
        std::cout << '[';
        for (int i = 0; i < max_delta; i++){
            std::cout <<powerOf2[i] << ',';
        }
        std::cout << powerOf2[max_delta] << ']' << std::endl;
    }
    //std::cin >> N;
    //std::cout << log2_64(N) << std::endl;
}