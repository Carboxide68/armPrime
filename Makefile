
debugPrime: debugPrime.o
	gcc -g debugPrime.o -o $@

debugPrime.o: nPrime.s
	as -g nPrime.s -o $@

nPrime: nPrime.o
	gcc nPrime.o -o $@

nPrime.o: nPrime.s
	as nPrime.s -o $@


clean:
	rm *.o nPrime debugPrime
