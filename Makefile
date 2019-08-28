
clean:
	rm *.o nPrime debugPrime

debugPrime: debugPrime.o
	gcc -D DEBUG -g debugPrime.o -o $@

debugPrime.o: nPrime.s
	as -g nPrime.s -o $@

nPrime: nPrime.o
	gcc -D DEBUG=0 nPrime.o -o $@

nPrime.o: nPrime.s
	as nPrime.s -o $@
