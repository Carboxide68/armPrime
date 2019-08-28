
clean:
	rm *.o nPrime debugPrime

debugPrime: nPrime.s
	gcc -g -x assembler-with-cpp -D _DEBUG nPrime.s -o $@

nPrime: nPrime.s
	gcc -x assembler-with-cpp nPrime.s -o $@
