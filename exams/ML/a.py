def has_edge_mat(M,u,v):
   return (v in M[u]) # O(N) N max(plithos akmvn kapoioy komvou)

def adj_mat_list(M):
   myGraph = {}
   for i in M:
      myGraph[i] = []
      for j in i:
         if (i != 0):
            myGraph[i].append(j) 
            # O(N^2), N = max(max(akmes),max(koryfes))

def has_edge_list(G,u,v):
   return (v in G[u]) # O(N) N einai plithos akmvn poy jekinoyn apo u
