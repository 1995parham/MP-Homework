;
; HW-6-1-2.asm
;
; Created: 12/18/2015 11:59:48 AM
; Author : Parham Alvani
;


 .org $000
jmp RESET
 .org $026
jmp timer0_comp

timer0_comp:
	jmp OCI
	reti

RESET:
	ldi r16, LOW(RAMEND)
	out SPL, r16
	
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	ldi r16, (1<<DDB3)
	out DDRB, r16

	ldi r16, (1<<CS02)|(0<<CS01)|(1<<CS00)|(1<<WGM01)|(0<<WGM00)|(1<<COM00)|(0<<COM01)
	
	out TCCR0, r16

	ldi r16, 0xFF
	out OCR0, r16

OCI:
	ldi r16, (1<<OCIE0)
	out TIMSK, r16
	sei

InfiniteLoop:
jmp InfiniteLoop
