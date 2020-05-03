#include <iostream>
#include <queue>
#include <algorithm>
#include <string.h>
#include <vector>
#define BSIZE 1<<15

// Fast input taken from Dimitris Fotakis
char buffer[BSIZE];
long bpos = 0L, bsize = 0L;
long readLong(FILE* argv, bool isNothing)
{
    long d = 0L, x = 0L; char c;
    while(1) {
        if (bpos >= bsize) {
            bpos = 0;
            if (feof(argv)) return x;
            bsize = fread(buffer, 1, BSIZE, argv);
        }
        c = buffer[bpos++];
        if (isNothing) return(c);
        else if (c >= '0' && c <= '9') { x = x*10 + (c-'0'); d = 1; }
        else if (d == 1) return x;
    }
    return -1;
}

// Global Variables
std::vector <unsigned int> Node[1000000];
std::queue <unsigned int> singleEdgedNodes;
unsigned int degree[1000000];
unsigned int numOfChildren[1000000];
std::vector<unsigned int> finalRoots;
unsigned int N = 0;
unsigned int father = 0; // to use as last element
unsigned int numVisited = 0; // to check if all visited // edge-case graph is tree
unsigned int numFinalRoots = 0; // for output
bool isCycle = false;
// Track children and find cycle
bool recursiveFoo(){
    // Find all nodes with only one edge
    for (unsigned int i = 0; i < N; i++) {
        if (degree[i] == 0) return 0; 
        else if (degree[i] == 1) singleEdgedNodes.push(i); 
    }
    // Find num of children to all nodes
    while(!singleEdgedNodes.empty()){
        // Pop Front Leaf
        unsigned int leaf = singleEdgedNodes.front();
        if(degree[leaf] != 1) return 0;
        singleEdgedNodes.pop();
        //
        father = Node[leaf][0];
        // Erase fathers edge to leaf
        Node[father].erase(std::remove(Node[father].begin(), Node[father].end(), leaf), Node[father].end());
        // Decrease fathers degree by 1 and check if fathers degree == 1
        if (--degree[father] == 1) singleEdgedNodes.push(father);
        else if (degree[father] == 0) return 0;
        // Add num of leaf's chindrens to father + 1
        ++numOfChildren[father] += numOfChildren[leaf];
        numVisited++;
    }
    return 1;
}

bool randomWalk (){
    // Cycle at least size 3 and last father should not empty
    if ((numVisited > N-3) || Node[father].empty()) return 0;
    unsigned int randomUnvisitedNode = father;
    // Random Walk
    do{
        // if degree > 2 not simple cycle
        if (degree[randomUnvisitedNode] > 2) return 0;
        numVisited++;
        
        // Add to final Result
        finalRoots.push_back(numOfChildren[randomUnvisitedNode]+1);
        numFinalRoots++;
        // Go to next random node
        unsigned int tempFather = Node[randomUnvisitedNode][0];
        Node[tempFather].erase(std::remove(Node[tempFather].begin(), Node[tempFather].end(), randomUnvisitedNode), Node[tempFather].end());
        randomUnvisitedNode = tempFather;
    }while(randomUnvisitedNode != father);
    //std::cout << "Visited This Area numVisited -> " << numVisited << " N -> " << N <<std::endl;
    return (numVisited == N);
}
// Print Results
void printFinal(){
    if (recursiveFoo() && randomWalk()){
        std::sort(finalRoots.begin(),finalRoots.end());
        printf("CORONA %u\n", numFinalRoots);
        for (unsigned int i = 0; i < numFinalRoots - 1; i++) {
            printf("%u ",finalRoots[i]);
        }
        printf("%u\n",finalRoots[numFinalRoots - 1] );
    }
    else {
        printf ("NO CORONA\n");
    }
}

int main(int argc, char** argv) { 
    // Faster I/O
    std::ios::sync_with_stdio(false);
    std::cin.tie(0);
    
    // Input from file
    FILE * pFile;
    pFile = fopen (argv[1], "r");
    unsigned int T = readLong(pFile, false);
    
    // Input
    for (unsigned int i = 0; i < T; i++) {
        N = readLong(pFile, false);
        unsigned int M = readLong(pFile, false);
        if (M != N) {
            printf ("NO CORONA\n");
            unsigned int counter = 0;
            while (counter < (M )) {
              char a = readLong(pFile, true);
              if (a == '\n') counter++;
            }
        
        continue;
        } 
    
    // Initialize Graph
        
        // Initialize arrays
        father = 0; 
        numVisited = 0;
        numFinalRoots = 0;
        memset(degree,0,N*sizeof(unsigned int));
        memset(numOfChildren,0,N*sizeof(unsigned int));
        
        for (unsigned int j = 0; j < M; j++) {
            unsigned int insertedNode1 = readLong(pFile, false);
            degree[insertedNode1-1]++;
            unsigned int insertedNode2 = readLong(pFile, false);
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
        singleEdgedNodes = std::queue<unsigned int>();
        // Clear last Results
        finalRoots.clear();
    } 
    return 0; 
  } 
