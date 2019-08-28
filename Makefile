
clean:
	rm *.o nPrime debugPrime

debugPrime: nPrime.s
	gcc -g -x assembler-with-cpp -D _DEBUG nPrime.s -o $@

#debugPrime.o: nPrime.s
#	as -g nPrime.s -o $@

nPrime: nPrime.s
	gcc -x assembler-with-cpp nPrime.s -o $@

#nPrime.o: nPrime.s
#	as nPrime.s -o $@
