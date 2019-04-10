
nPrime: nPrime.o
	gcc -g nPrime.o -o nPrime

nPrime.o: nPrime.s
	as -g nPrime.s -o nPrime.o
