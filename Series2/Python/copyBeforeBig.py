
def InputMap() :
    from sys import maxsize, argv
    mymax = maxsize
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
        if (i == 'A'): 
            airports.append([N-1,counter])
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
    with open(argv[1],mode='r') as FileObj:
        cageAppend = cage.append
        for line in FileObj:
            N += 1
            M = mylen(line)-1
            cageAppend(list(map(readData,line[:-1])))

    return(N-1,M-1,cage,start, end ,virus, airports)

def do_the_job ():
    # Global Variables
    N, M, cage, start, end, virus, airports = InputMap()
    adding = 2
    foundEnd = False
    swtos = False
    counter = 1
    newcage = list(map(lambda i:([0]*(M+1)),range(N+1)))
    from collections import deque
    queue = deque()
    
    def allowed (cell): return (((cell[0]>-1) and (cell[0] <= N) and (cell[1] > -1) and (cell[1] <= M)))
    def recursiveFoo1(cell):
        nonlocal counter, foundEnd, recFoo
        i,j = cell
        cell_price = cage[i][j]
        for neighbor_i,neighbor_j in filter(allowed,[[i+1,j],[i,j-1],[i,j+1],[i-1,j]]):
            currNeighbor = cage[neighbor_i][neighbor_j]
            if (currNeighbor > (cell_price + adding) ):
                cage[neighbor_i][neighbor_j] = cell_price + adding
                queue.append([neighbor_i,neighbor_j])
            elif (currNeighbor == -2):
                recFoo = recursiveFoo2
                queueAppend = queue.append
                for airport_i,airport_j in airports:
                    cage[airport_i][airport_j] = cell_price + adding + 5
                    queueAppend([airport_i,airport_j])
                cage[neighbor_i][neighbor_j] = cell_price + adding
    
    recFoo = recursiveFoo1
    
    def recursiveFoo2(cell):
        nonlocal counter, foundEnd
        i,j = cell
        cell_price = cage[i][j]
        for neighbor_i,neighbor_j in filter(allowed,[[i+1,j],[i,j-1],[i,j+1],[i-1,j]]):
            currNeighbor = cage[neighbor_i][neighbor_j]
            if (currNeighbor > (cell_price + adding) ):
                cage[neighbor_i][neighbor_j] = cell_price + adding
                queue.append([neighbor_i,neighbor_j])
    
    def recursiveFoo3(cell):
        nonlocal counter, foundEnd
        i,j = cell
        cell_price = cage[i][j]
        for neighbor_i,neighbor_j in filter(allowed,[[i+1,j],[i,j-1],[i,j+1],[i-1,j]]):
            currNeighbor = cage[neighbor_i][neighbor_j]
            if (currNeighbor > (cell_price + adding) ):
                if ([neighbor_i,neighbor_j] == end): foundEnd = True
                newcage[neighbor_i][neighbor_j] = counter
                counter += 1
                cage[neighbor_i][neighbor_j] = cell_price + adding
                queue.append([neighbor_i,neighbor_j])
    
    # Virus spreading
    def VirusSpread ():
        nonlocal queue,virus
        queue.append(virus)
        while queue: 
            currentCell = queue.popleft()
            recFoo(currentCell)

    def SotosSpread():
        nonlocal swtos, adding, cage, start, queue
        cage[start[0]][start[1]] = 0
        queue.append(start)
        adding = 1

        # Sotiris spreading
        while queue: 
            currentCell = queue.popleft()
            recursiveFoo3(currentCell)
    # Apothiki
    # print(N,M, start, end, airports)
    VirusSpread()
    SotosSpread()
    #import numpy as np
    #print(np.array(cage))
    #print (np.array(newcage))
    if (foundEnd):
        print("15\nRRRRRRRRRRRRRRRRRRRRRRRR") 
    else: print("IMPOSSIBLE")
do_the_job()        
