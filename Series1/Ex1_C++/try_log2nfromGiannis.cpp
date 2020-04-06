#include <iostream>
#include <cstring>

#define BSIZE 1<<15
// Fast input taken from Dimitris Fotakis
char buffer[BSIZE];
long bpos = 0L, bsize = 0L;
long readLong(FILE* argv)
{
    long d = 0L, x = 0L; char c;
    while(1) {
        if (bpos >= bsize) {
            bpos = 0;
            if (feof(argv)) { // Edw trww seg
    std::cout <<"EISAI MALAKAS" <<std::endl;
                
                return x;}
            bsize = fread(buffer, 1, BSIZE, argv);
        }
        c = buffer[bpos++];
        if (c >= '0' && c <= '9') { x = x*10 + (c-'0'); d = 1; }
        else if (d == 1) return x;
    }
    return -1;
}


// Fast Log2 taken from StackOverflow url: https://stackoverflow.com/questions/11376288/fast-computing-of-log2-for-64-bit-integers
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

int powerOf2[50];
bool flag = 1;
int max_delta = 0;

bool recursiveFoo (long N, long K){
    if (N==K){
        powerOf2[0]+=K;
        return 1;
    }
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
        // Fastest Power of 2 I found it by shifting!!!
        return recursiveFoo(N - (1 << delta), K - 1);
    }

}

int main (int argc, char** argv){
    FILE * pFile;
    pFile = fopen (argv[1], "r");
    int T = readLong(pFile);
    for (int i = 0; i < T; i++){
        // Initializations
        //Fast Initialization of the array
        memset(powerOf2,0,sizeof(powerOf2));
        flag = 1;
        max_delta = 0;
        
        long N = readLong(pFile);
        long K = readLong(pFile);
        bool douleuei = recursiveFoo(N,K);
        if(!douleuei) std::cout << "[]" << std::endl;
        else {
            std::cout << '[';
            for (int i = 0; i < max_delta; i++){
                std::cout <<powerOf2[i] << ',';
            }
            std::cout << powerOf2[max_delta] << ']' << std::endl;
        }
        
    }
}
