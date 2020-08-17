for i in range(10):
    DPArray = [[["", ""] for _ in range(101)] for _ in range(64)]
    DPArray[63][100][1] += str(i)
    print(DPArray[63][100][1])
# print(len(["A", "U", "C", "G", "AU", "AC", "AG", "UA", "UC", "UG", "CA", "CU", "CG", "GA", "GU", "GC", "AUC", "AUG", "ACU", "ACG", "AGU", "AGC", "UAC", "UAG", "UCA", "UCG", "UGA", "UGC", "CAU", "CAG", "CUA", "CUG", "CGA", "CGU", "GAU",
#           "GAC", "GUA", "GUC", "GCA", "GCU", "AUCG", "AUGC", "ACUG", "ACGU", "AGUC", "AGCU", "UACG", "UAGC", "UCAG", "UCGA", "UGAC", "UGCA", "CAUG", "CAGU", "CUAG", "CUGA", "CGAU", "CGUA", "GAUC", "GACU", "GUAC", "GUCA", "GCAU", "GCUA"]))
