import numpy as np
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
    with open(argv[1],mode='r') as FileObj:
        cageAppend = cage.append
        for line in FileObj:
            N += 1
            M = mylen(line)-1
            cageAppend(list(map(readData,line[:-1])))

    return(N-1,M-1,cage,start, end ,virus, airports)

# Global Variables
def do_the_job ():
    N, M, cage, start, end, virus, airports = InputMap()
    adding = 2
    foundEnd = False
    swtos = False
    counter = 1
    newcage = [([0]*(M+1)) for i in range(N+1)]
    queue = []
    def allowed (cell): return (not ((cell[0]<0)or (cell[0] > N) or (cell[1]<0)  or (cell[1] > M)))
    def recursiveFoo(cell):
        nonlocal counter, foundEnd, queue
        i,j = cell
        cell_price = cage[i][j]
        for neighbor_i,neighbor_j in [[i+1,j],[i,j-1],[i,j+1],[i-1,j]]:
            if (allowed([neighbor_i,neighbor_j])):
                currNeighbor = cage[neighbor_i][neighbor_j]
                if (currNeighbor > (cell_price + adding) ):
                    if (swtos):
                        if ([neighbor_i,neighbor_j] == end): foundEnd = True
                        newcage[neighbor_i][neighbor_j] = counter
                        counter += 1
                    cage[neighbor_i][neighbor_j] = cell_price + adding
                    queue.append([neighbor_i,neighbor_j])
                elif (currNeighbor == -2):
                    for airport_i,airport_j in airports:
                        cage[airport_i][airport_j] = cell_price + adding + 5
                        queue.append([airport_i,airport_j])
        #queue.pop(0)

    # Virus spreading
    def VirusSpread ():
        nonlocal virus
        queue = [virus]
        #any(map(recursiveFoo,queue))
        while queue: 
            currentCell = queue.pop(0)
            recursiveFoo(currentCell)

    def SotosSpread():
        nonlocal swtos, adding, cage, start, queue
        swtos = True
        cage[start[0]][start[1]] = 0
        queue = [start]
        adding = 1
        #queuePop = queue.pop
        # Sotiris spreading
        while queue: 
            currentCell = queue.pop(0)
            recursiveFoo(currentCell)
    # Apothiki
    # print(N,M, start, end, airports)
    VirusSpread()
    SotosSpread()
    print(np.array(cage),'\n')
    print (np.array(newcage))
    if (foundEnd):
        print("15\nRRRRRRRRRRRRRRRRRRRRRRRR") 
    else: print("IMPOSSIBLE")
do_the_job()