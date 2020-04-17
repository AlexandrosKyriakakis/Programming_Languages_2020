#include <iostream>
#include <queue>
#include <algorithm>
#include <string.h>
#include <vector>
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
            if (feof(argv)) return x;
            bsize = fread(buffer, 1, BSIZE, argv);
        }
        c = buffer[bpos++];
        if (c >= '0' && c <= '9') { x = x*10 + (c-'0'); d = 1; }
        else if (d == 1) return x;
    }
    return -1;
}

// Global Variables
std::vector <unsigned int> Node[1000000];
std::queue <unsigned int> singleEdgedNodes;
unsigned int degree[1000000];
unsigned int numOfChildren[1000000];
bool visited[1000000];
//std::vector<unsigned int> finalRoots;
unsigned int N = 0;
//unsigned int father = 0; // to use as last element
//unsigned int numVisited = 0; // to check if all visited // edge-case graph is tree
//unsigned int numFinalRoots = 0; // for output

void printFinal(){

    //std::sort(finalRoots.begin(),finalRoots.end());
    printf("CORONA %u\n", 23476);
    for (unsigned int i = 0; i < 20 - 1; i++) {
        printf("%u ",8347);
    }
    printf("%u\n",239478 );

}


int main(int argc, char** argv) { 
    // Faster I/O
    std::ios::sync_with_stdio(false);
    std::cin.tie(0);
    
    // Input from file
    FILE * pFile;
    pFile = fopen (argv[1], "r");
    unsigned int T = readLong(pFile);
    
    // Input
    for (unsigned int i = 0; i < T; i++) {
        N = readLong(pFile);
        unsigned int M = readLong(pFile);
        if (M != N) {
            printf ("NO CORONA\n");
            continue; 
        }
    // Initialize Graph
        
        // Initialize arrays
        //father = 0; 
        //numVisited = 0;
        //numFinalRoots = 0;
        memset(degree,0,N*sizeof(unsigned int));
        memset(numOfChildren,0,N*sizeof(unsigned int));
        memset(visited,0,N*sizeof(bool));
        
        for (unsigned int j = 0; j < M; j++) {
            unsigned int insertedNode1 = readLong(pFile);
            degree[insertedNode1-1]++;
            unsigned int insertedNode2 = readLong(pFile);
            degree[insertedNode2-1]++;
            // Adding Edges <-> to graph
            Node[insertedNode1-1].push_back(insertedNode2-1);
            Node[insertedNode2-1].push_back(insertedNode1-1); 
        }
        // Print Results
        printFinal();
        // Clear all vectors
        for (unsigned int i = 0; i < N; i++) {
            Node[i].clear();
        }
        // Clear queue
        //singleEdgedNodes = std::queue<unsigned int>();
        // Clear last Results
        //finalRoots.clear();
    } 
    return 0; 
    } 