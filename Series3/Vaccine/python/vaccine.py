import numpy as np
from sys import argv
# Dictionaries
possibleStates = ["A", "U", "C", "G", "AU", "AC", "AG", "UA", "UC",
                  "UG", "CA", "CU", "CG", "GA", "GU", "GC", "AUC",
                  "AUG", "ACU", "ACG", "AGU", "AGC", "UAC", "UAG", "UCA",
                  "UCG", "UGA", "UGC", "CAU", "CAG", "CUA", "CUG", "CGA",
                  "CGU", "GAU", "GAC", "GUA", "GUC", "GCA", "GCU", "AUCG",
                  "AUGC", "ACUG", "ACGU", "AGUC", "AGCU", "UACG", "UAGC", "UCAG",
                  "UCGA", "UGAC", "UGCA", "CAUG", "CAGU", "CUAG", "CUGA", "CGAU",
                  "CGUA", "GAUC", "GACU", "GUAC", "GUCA", "GCAU", "GCUA"]
indexingPossibleStates = {}
for i in range(64):
    indexingPossibleStates[possibleStates[i]] = i
complement = {"A": "U", "U": "A", "C": "G", "G": "C"}


# Input Method
def inputNextString():
    with open(argv[1], mode='r') as FileObj:
        for line in FileObj:
            yield line


def recursiveFoo(cell):  # cell = [i,j,k]
    i, j, k = cell
    if (j < currentLen - 1):

        originalChar = currentInput[j+1]
        complemented = currentComplementedInput[j+1]
        currentChar = originalChar if (k == 0) else complemented
        state = possibleStates[i]  # Ex. ACG

        # Not included in right stack
        # FIXME den exw swsta th leksikografikh seira

        if (currentChar not in state):
            nextMove = DPArray[i][j][k] + "rp"
            new_i = indexingPossibleStates[possibleStates[i]
                                           [::-1] + currentChar]
            if (DPArray[new_i][j+1][k] == "" or len(DPArray[new_i][j+1][k]) > len(nextMove)):
                DPArray[new_i][j+1][k] = nextMove
                queue.append([new_i, j+1, k])

        if (state[0] == currentChar):
            nextMove = DPArray[i][j][k] + "rp"
            new_i = indexingPossibleStates[possibleStates[i][::-1]]
            if (DPArray[new_i][j+1][k] == "" or len(DPArray[new_i][j+1][k]) > len(nextMove)):
                DPArray[new_i][j+1][k] = nextMove
                queue.append([new_i, j+1, k])
        if (currentChar not in state):
            nextMove = DPArray[i][j][k] + "p"
            new_i = indexingPossibleStates[possibleStates[i] + currentChar]
            if (DPArray[new_i][j+1][k] == "" or len(DPArray[new_i][j+1][k]) > len(nextMove)):
                DPArray[new_i][j+1][k] = nextMove
                queue.append([new_i, j+1, k])
        if (state[-1] == currentChar):  # G == current char
            nextMove = DPArray[i][j][k] + "p"
            if (DPArray[i][j+1][k] == "" or len(DPArray[i][j+1][k]) > len(nextMove)):
                DPArray[i][j+1][k] = nextMove
                queue.append([i, j+1, k])

        if (complement[currentChar] not in state):
            nextMove = DPArray[i][j][k] + "crp"
            new_k = int(not k)
            new_i = indexingPossibleStates[possibleStates[i]
                                           [::-1] + complement[currentChar]]
            if (DPArray[new_i][j+1][new_k] == "" or len(DPArray[new_i][j+1][new_k]) > len(nextMove)):
                DPArray[new_i][j+1][new_k] = nextMove
                queue.append([new_i, j+1, new_k])

        if (state[0] == complement[currentChar]):
            nextMove = DPArray[i][j][k] + "crp"
            new_i = indexingPossibleStates[possibleStates[i][::-1]]
            new_k = int(not k)
            if (DPArray[new_i][j+1][new_k] == "" or len(DPArray[new_i][j+1][new_k]) > len(nextMove)):
                DPArray[new_i][j+1][new_k] = nextMove
                queue.append([new_i, j+1, new_k])

        if (complement[currentChar] not in state):
            nextMove = DPArray[i][j][k] + "cp"
            new_k = int(not k)
            new_i = indexingPossibleStates[possibleStates[i] +
                                           complement[currentChar]]
            if (DPArray[new_i][j+1][new_k] == "" or len(DPArray[new_i][j+1][new_k]) > len(nextMove)):  # FIXME ">="
                DPArray[new_i][j+1][new_k] = nextMove
                queue.append([new_i, j+1, new_k])

        if (state[-1] == complement[currentChar]):  # G == complemented current char
            nextMove = DPArray[i][j][k] + "cp"
            if (DPArray[i][j+1][int(not k)] == "" or len(DPArray[i][j+1][int(not k)]) > len(nextMove)):  # FIXME ">="
                DPArray[i][j+1][int(not k)] = nextMove
                queue.append([i, j+1, int(not k)])


def run():
    DPArray[indexingPossibleStates[currentInput[0]]][0][0] += "p"
    queue.append([indexingPossibleStates[currentInput[0]], 0, 0])
    while queue:
        currentCell = queue.pop()
        recursiveFoo(currentCell)


# Data
currentString = inputNextString()
N = int(next(currentString))
for _ in range(N):
    currentInput = next(currentString).strip()[::-1]
    currentComplementedInput = "".join(
        (map(lambda i: complement[i], currentInput)))
    currentLen = len(currentInput)
    queue = []
    DPArray = [[["", ""] for _ in range(currentLen)] for _ in range(64)]

    run()
    res = []
    for i in range(64):
        cur = DPArray[i][-1]
        # print(cur)
        res += cur
    minimum = min(len(i) for i in res if (i != ""))
    print(
        sorted(list(filter(lambda i: i != "" and len(i) == minimum, res)))[0])

# Get ready to start


# Assume that input is at the right side of the right stack
