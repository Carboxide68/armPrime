.global main
.global wrb
.global rdb
.text
//r0 = Lowest memory address
//r1 = Place to edit
//r2 = Contains a 1 in delC and the memory address in nextP
//r3 = 
//r4 = 
//r5 =
//r6 = Current number
//r7 = 
//r8 = Highest prime 
//r9 = Current prime
//r10=

.macro rdb lmem, arradd, val
	MOV r3, #1
	AND r4, \arradd, #31
	MOV r5, \arradd, LSR#5
	LDR \val, [\lmem, r5, LSL#2]
	AND \val, \val, r3, LSL r4
.endm

.macro wrb lmem, arradd, val
	MOV r3, #1
	AND r4, \arradd, #31
	MOV r4, r3, LSL r4
	MOV r5, \arradd, LSR#5
	LDR r3, [\lmem, r5, LSL#2]
	CMP \val, #1
	MVNNE r4, r4
	ANDNE r3, r3, r4
	ORREQ r3, r3, r4
	STR r3, [\lmem, r5, LSL#2]
.endm

main:
	LDR r8, =10000
	ADD r8, r8, #15
	SUB sp, sp, r8, LSR#4
	SUB r8, r8, #15
	MOV r0, sp
	MOV r2, #0
	MOV r1, #0
	BL clsl
	MOV r6, #3
	B pLoop
	
pLoop:
	ADD r1, r6, r6, LSR#1
	MOV r2, #1
	BL delC
	ADD r6, r6, #2
	BL nextP
	CMP r2, #0
	BNE exit
	mov r9, r6
	B pLoop

delC:
	wrb r0, r1, r2
	ADD r1, r6, r1
	CMP r8, r1, LSL#1
	BXMI LR
	B delC

nextP:
	MOV r1, r6, LSR#1
	rdb r0, r1, r2
	CMP r2, #0
	BXEQ LR
	ADD r6, r6, #2
	CMP r8, r6
	BXMI LR
	B nextP

clsl: //Clean slate, set memory to 0's
	wrb r0, r1, r2
	ADD r1, r1, #1
	CMP r8, r1, LSL#1
	BXMI LR
	B clsl

exit:
	mov r1, r9
	ldr r0, =string
	BL printf
	bkpt

string: .asciz "%d\n"
