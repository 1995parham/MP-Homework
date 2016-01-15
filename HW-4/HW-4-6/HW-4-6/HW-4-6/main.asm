;
; HW-4-6.asm
;
; Created: 12/3/2015 4:20:03 PM
; Author : Parham Alvani
;


.DSEG
data: .byte 200
.CSEG
start:
	; ===Just For Test===
	ldi r16, 10
	ldi r30, low(data)
	ldi r31, high(data)
	st Z+, r16
	st Z+, r16
	; ===================
	ldi r16, 200
outer_loop:
	mov r17, r16
	; moving 'data' offset into Z register
	ldi r30, low(data)
	ldi r31, high(data)
	; r20 = data[0]
	; r21 = data[1]
	ld r20, Z+
	ld r21, Z
inner_loop:
	cp r21, r20
	brsh go_to_inner_loop
	st -Z, r21
	adiw r30:r31, 1
	st Z, r20
go_to_inner_loop:
	dec r17
	cpi r17, 0
	breq go_to_outer_loop
	mov r20, r21
	adiw r30:r31, 1
	ld r21, Z
	rjmp inner_loop
go_to_outer_loop:
	dec r16
    rjmp outer_loop