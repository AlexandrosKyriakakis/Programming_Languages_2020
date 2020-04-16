// CPP implementation of the approach 
#include <vector>
#include <cstdio>
#include <queue>
#include <unordered_map>
#include <iostream>
#include <algorithm>
using namespace std;
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
  

// Graph class 
class Graph 
    { 
    public: 
        
        // No. of vertices of graph 
        int v; 
    
        // Adjacency List 
        vector<int> *l; 
        //Edge array
        vector<int> children;

        void DFSUtil(int v, vector<bool>& visited, vector<int>& final_children);
        void DFS(int v, vector<bool>& visited, vector<int>& final_children);
        
        Graph(int v) 
        { 
            this->v = v; 
            this->l = new vector<int>[v];
            this->children = vector<int>(v);
        } 
    
        void addedge(int i, int j) 
        { 
            l[i].push_back(j); 
            l[j].push_back(i);
        }
    //  void printedge()
    }; 


    // Checking all the nodes which are not visited 
    // i.e. they are part of the cycle
    void Graph::DFSUtil(int v, vector<bool>& visited, vector<int>& final_children) {

    // Mark the current node as visited and
    // print it
    if (!visited[v]) {
        final_children.push_back(children[v] + 1);
        visited[v] = true;
    }
    //cout << v << " ";

    // Recur for all the vertices adjacent
    // to this vertex
    vector<int>::iterator i;
    for (i = l[v].begin(); i != l[v].end(); ++i)
        if (!visited[*i])
            DFSUtil(*i, visited,final_children);
}
// DFS traversal of the vertices reachable from v.
// It uses recursive DFSUtil()
void Graph::DFS(int v,vector<bool>& visited, vector<int>& final_children) {
    

    // Call the recursive helper function
    DFSUtil(v, visited,final_children);
}
    

    
         
     
  
// Function to find a cycle in the given graph if exists 
bool findCycle(int n, int r, Graph g) 
{ 
    // HashMap to store the degree of each node 
    std::unordered_map<int, int> degree;
    int child = 0; 
    for (int i = 0; i < g.v; i++) 
        degree[i] = g.l[i].size(); 
  
    // Array to track visited nodes 
    vector<bool>visited(g.v);
  
    // Queue to store the nodes of degree 1 
    queue<int> q; 
  
    // Continuously adding those nodes whose 
    // degree is 1 to the queue 
    //while (true) 
    //{ 
        // Adding nodes to queue whose degree is 1 
        // and is not visited 
      
    for (unsigned int i = 0; i < degree.size(); i++) 
        if (degree.at(i) == 0) return 0;
        else if (degree.at(i) == 1 and !visited[i]) 
            q.push(i); 
    

    // If queue becomes empty then get out 
    // of the continuous loop        

    while (!q.empty()) 
    { 
        // Remove the front element from the queue 
        child = q.front();
        q.pop(); 

        // Mark the removed element visited 
        visited.at(child) = 1; 

        // Decrement the degree of all those nodes 
        // adjacent to removed node 
        int i = 0;
        int Father = g.l[child][i];

        int value = degree[Father]; 
        //FIXME add to queue
        degree[Father] = --value;
        if (value == 1)  q.push(Father);

        g.l[Father].erase(std::remove(g.l[Father].begin(), g.l[Father].end(), child), g.l[Father].end());
        
        //g.l[Father][child]
        g.children[Father] += g.children[child] + 1;
    
        
    } 
    //} 
    bool flag = false;
    vector<int> final_children;
    g.DFS(child,visited,final_children);
    for (int i = 0; i < g.v; i++) {
        if (!visited[i]) {
            flag = true;
            printf ("NO CORONA\n");
 //           cout <<"NO CORONA" << endl;
            break;
        }
    }
    if (!flag) {
        std::sort(final_children.begin(),final_children.end());
        int size = final_children.size();
        printf("CORONA %d\n", size);
//        cout << "CORONA" << " " << size << endl;
        for (int i = 0; i < size - 1; i++) {
            printf("%d ",final_children[i]);
//            cout << final_children[i] << " ";
        }
        printf("%d\n",final_children[size - 1] );
 //       cout << final_children[size - 1] << endl;
    }           
  return 1;
} 
  
// Driver Code 
int main(int argc, char** argv) 
{ 
    FILE * pFile;
    pFile = fopen (argv[1], "r");
    int T = readLong(pFile);
    // Input
    for (int i = 0; i < T; i++) {
        int N = readLong(pFile);
        int M = readLong(pFile);
        if (M != N) {
            printf ("NO CORONA\n");
            continue; 
        }
    // Initialize Graph
       Graph* g = new Graph(N);
        for (int j = 0; j < M; j++) {
            int k = readLong(pFile);
            int l = readLong(pFile);
            g->addedge(k-1,l-1);   
        }
       if (!findCycle(N, M, *g)) {
            printf ("NO CORONA\n");
       }
        
       delete g;
    } 
    return 0; 
} 
