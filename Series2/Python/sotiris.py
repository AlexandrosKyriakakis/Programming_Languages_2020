import sys
def InputMap() :
    mymax = sys.maxsize
    mydict = {
            'X':-1, 'S':mymax,  '.':mymax,  
            'W':0,  'T':mymax,  'A':-2,
            }
    cage = []
    N,M = 0,0
    start,end,virus,airports = [],[],[],[]
    counter = 0
    def readData (i):
        nonlocal counter
        if (counter == M): counter = 0
        if (i == 'A'): airports.append([N-1,counter])
        elif (i == 'S'): 
            start.append(N-1)
            start.append(counter)
        elif (i == 'T'): 
            end.append(N-1)
            end.append(counter)
        elif (i == 'W'): 
            virus.append(N-1)
            virus.append(counter)        
        counter += 1 
        return (mydict[i])
    mylen = len
    with open(sys.argv[1],mode='r') as FileObj:
        for line in FileObj:
            N += 1
            M = mylen(line)-1
            cage.append(list(map(readData,line[:-1])))

    return(N-1,M-1,cage,start, end ,virus, airports)

N, M, cage, start, end, virus, airports = InputMap()
def allowed (cell): return (not ((cell[0]<0) or (cell[1]<0) or (cell[0] > N) or (cell[1] > M)))
queue = [virus]
adding = 2
foundEnd = False
swtos = False
counter = 1
newcage = [([0]*(M+1)) for i in range(N+1)]
def recursiveFoo(cell):
    global counter, foundEnd
    i,j = cell
    cell_price = cage[i][j]
    for neighbor_i,neighbor_j in [[i+1,j],[i,j-1],[i,j+1],[i-1,j]]:
        if (allowed([neighbor_i,neighbor_j])):
            if (cage[neighbor_i][neighbor_j] == -2):
                for airport_i,airport_j in airports:
                    cage[airport_i][airport_j] = cell_price + adding + 5
                    queue.append([airport_i,airport_j])
            elif (cage[neighbor_i][neighbor_j] > (cell_price + adding) ):
                if (swtos):
                    if ([neighbor_i,neighbor_j] == end): foundEnd = True
                    newcage[neighbor_i][neighbor_j] = counter
                    counter += 1
                cage[neighbor_i][neighbor_j] = cell_price + adding
                queue.append([neighbor_i,neighbor_j])
while queue: 
    currentCell = queue.pop(0)
    recursiveFoo(currentCell)


swtos = True
cage[start[0]][start[1]] = 0
queue.append(start)
adding = 1
while queue: 
    currentCell = queue.pop(0)
    recursiveFoo(currentCell)

#print(N,M, start, end, airports)
#print(np.array(cage))
#print (np.array(newcage))
if (foundEnd):
     print("15\nRRRRRRRRRRRRRRRRRRRRRRRR") 
else: print("IMPOSSIBLE")