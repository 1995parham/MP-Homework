;
; HW-4-4.asm
;
; Created: 12/3/2015 12:23:19 PM
; Author : Parham Alvani
;


start:
	; Input
	ldi r16, 12
	mov r0, r16
	; Answer :)
	ldi r16, 0
	mov r1, r16
	; Odd number generator
	ldi r16, 1
	mov r2, r16
	; Step
	ldi r16, 2
	mov r3, r16
loop:
	add r1, r2
	add r2, r3
    dec r0
	mov r16, r0
	cpi r16, 0
	breq deadend
	rjmp loop
deadend:
    rjmp deadend
