// CPP implementation of the approach 
#include <bits/stdc++.h> 
using namespace std; 
  
// Graph class 
class Graph 
{ 
public: 
      
    // No. of vertices of graph 
    int v; 
  
    // Adjacency List 
    vector<int> *l; 
  
    Graph(int v) 
    { 
        this->v = v; 
        this->l = new vector<int>[v]; 
    } 
  
    void addedge(int i, int j) 
    { 
        l[i].push_back(j); 
        l[j].push_back(i); 
    } 
}; 
  
// Function to find a cycle in the given graph if exists 
void findCycle(int n, int r, Graph g) 
{ 
    // HashMap to store the degree of each node 
    unordered_map<int, int> degree; 
  
    for (int i = 0; i < g.v; i++) 
        degree[i] = g.l[i].size(); 
  
    // Array to track visited nodes 
    int visited[g.v] = {0}; 
  
    // Queue to store the nodes of degree 1 
    queue<int> q; 
  
    // Continuously adding those nodes whose 
    // degree is 1 to the queue 
    while (true) 
    { 
        // Adding nodes to queue whose degree is 1 
        // and is not visited 
        for (int i = 0; i < degree.size(); i++) 
            if (degree.at(i) == 1 and !visited[i]) 
                q.push(i); 
  
        // If queue becomes empty then get out 
        // of the continuous loop 
        if (q.empty()) 
            break; 
  
        while (!q.empty()) 
        { 
            // Remove the front element from the queue 
            int temp = q.front(); 
            q.pop(); 
  
            // Mark the removed element visited 
            visited[temp] = 1; 
  
            // Decrement the degree of all those nodes 
            // adjacent to removed node 
            for (int i = 0; i < g.l[temp].size(); i++) 
            { 
                int value = degree[g.l[temp][i]]; 
                degree[g.l[temp][i]] = --value; 
            } 
        } 
    } 
    int flag = 0; 
  
    // Checking all the nodes which are not visited 
    // i.e. they are part of the cycle 
    for (int i = 0; i < g.v; i++) 
        if (visited[i] == 0) 
            flag = 1; 
  
    if (flag == 0) 
        cout << "-1"; 
    else
    { 
        for (int i = 0; i < g.v; i++) 
            if (visited[i] == 0) 
                cout << i << " "; 
    } 
} 
  
// Driver Code 
int main() 
{ 
    // No of nodes 
    int n = 5; 
  
    // No of edges 
    int e = 5; 
    Graph g(n); 
  
    g.addedge(0, 1); 
    g.addedge(0, 2); 
    g.addedge(0, 3); 
    g.addedge(1, 2); 
    g.addedge(3, 4); 
  
    findCycle(n, e, g); 
    return 0; 
} 
  
// This code is contributed by 
// sanjeev2552 