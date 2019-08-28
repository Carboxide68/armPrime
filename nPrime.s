.global main
.global wrb
.global rdb

.extern printf

.equ count, 100000 // Set this to mark the upper limit of the targeted number

.data

primestart: .SPACE count/16 + 16 // Adding some extra memory can't hurt, right? Also, since I store primes in bits I need an 8th the amount of bytes

primend: // This marks then end of my allocation

.text
//r0 = Lowest memory address
//r1 = Place to edit
//r2 = Contains a 1 in delC and the memory address in nextP
//r3 = 
//r4 = 
//r5 =
//r6 = Current number
//r7 = Prime amount counter
//r8 = Highest prime 
//r9 = Current prime

.macro rdb lmem, arradd, val // Read a bit
	MOV r3, #1
	AND r4, \arradd, #31 // Isolates the last 8 bits of arradd and stores it in r4
	MOV r5, \arradd, LSR#5 // Removes the 8 last bits of arradd and stores it in r5
	LDR \val, [\lmem, r5, LSL#2] // Loads the byte, which address is stored in register r5
	AND \val, \val, r3, LSL r4 // Isolates the correct bit in the byte, and stores it in val
.endm

.macro wrb lmem, arradd, val // Write to a bit
	MOV r3, #1
	AND r4, \arradd, #31 // Isolates the last 8 bits of arradd
	MOV r4, r3, LSL r4 // Sets r3 to a byte which 1 is on the right location that we want to extract out of the imported byte, and stores it in r4
	MOV r5, \arradd, LSR#5 // Removes the last bits of arrad and stores it in r5
	LDR r3, [\lmem, r5, LSL#2] // Loads the byte, which address is stored in the register r5
	CMP \val, #1
	MVNNE r4, r4 // If th val == 0, perform a bitwise not on r4, thus turning the target bit to 0 and everything else to 1
	ANDNE r3, r3, r4 //And when we want to make the bit 0 i.e if val = 0, we perform an and which leaves everything except our target bit unchanged, and our target 0
	ORREQ r3, r3, r4 //If val is 1 instead, we leave everything except our target bit untouched, which will become 1
	STR r3, [\lmem, r5, LSL#2] // We then put back our byte into the storage
.endm

main:
	LDR r8, =count // Highest prime
	LDR r0, =primestart // First memory address for primes
	MOV r7, #2 //Last memory address for primes
	MOV r2, #0
	MOV r1, #0
	MOV r6, #3
	MOV r9, r6
	B pLoop
	
pLoop:
	MOV r1, r9, LSR #1 //r1 becomes half of r9, rounding down
	MOV r2, #1
	BL delC // Removes the memory chain of the current prime
	ADD r6, r6, #2 // Preps r6 for nextP, making it the next uneven number 
	BL nextP // Places the next prime number in r6
	CMP r2, #0 // If nextP ended early, and r2 is 1, it means we reached the limit of how many primes we get and we exit the program with the last prime in r9
	BNE exit
	mov r9, r6 // Stores the prime in r9
	ADD r7, r7, #1

#ifdef _DEBUG
	
	push {r0, r1, r2, r3, r12}

	LDR r0, =str
	MOV r1, r7
	MOV r2, r9
	BL printf

	POP {r0, r1, r2, r3, r12}

#endif
	B pLoop

delC:
	wrb r0, r1, r2 // Writes a 1 to the current
	ADD r1, r9, r1 // Increases the location by r9 * 2, relative to r1, thus skipping even numbers
	CMP r8, r1, LSL#1 // We add the next number before we check if it's out of bounds because we don't want to be reading memory that's out of bounds
	BXMI LR // If r1 * 2, aka the current number, is bigger than the limit, we stop eliminating children, 
			// this also relies on the memory being 1 byte bigger in certain situations
	B delC  // Otherwise remove the next bit

nextP:
	MOV r1, r6, LSR#1 // r1 becomes half of r6, rounding down, so that we get the correct memory place
	rdb r0, r1, r2 // Read the target bit
	CMP r2, #0 // If the bit is 0, that means that it's a prime, we stop and return the prime
	BXEQ LR
	ADD r6, r6, #2 // We step r6 to the next uneven number
	CMP r8, r6 // We check if it's out of bounds
	BXMI LR // If it is out of bounds we return the function, with r2 being an 1. This then tells main that it's out of bounds, 
			// so that it knows that we've reached the last prime
	B nextP // Otherwise we restart the function

exit:

	LDR r0, =str
	MOV r1, r7
	MOV r2, r9
	BL printf
	bkpt

str: .asciz "Count: %d, Highest prime: %d\n"
