file = open("/Users/alexanders_mac/MyProjects/C++_Projects/Programming_Languages_1_2020/Series2/Prolog/try.pl", mode = 'w+')
for x in range(10000):
    print("likes({},{}).\n".format(x,x+1), file=file)