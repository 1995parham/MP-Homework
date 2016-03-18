;
; HW-6-3-1.asm
;
; Created: 12/18/2015 11:59:48 AM
; Author : Parham Alvani
;


.org $000
	jmp RESET
.org $012
	jmp timer0_overflow




timer0_overflow:

FirstREAD:
		in r16, PIND
		cpi r16, 0x40

		brne SecondREAD

		ldi r16, 0xB0
		out OCR0, r16

		jmp ENABLELABEL

SecondREAD:
		in r16, PIND
		cpi r16, 0x80

		brne FirstREAD

		ldi r16, 0x88
		out OCR0, r16

		jmp ENABLELABEL


RESET:

	ldi r16, LOW(RAMEND)
	out SPL, r16

	ldi r17, HIGH(RAMEND)
	out SPH, r17

	ldi r16, (1<<CS00)|(0<<CS01)|(0<<CS02)|(1<<COM01)|(1<<COM00)|(1<<WGM01)|(1<<WGM00)
	out TCCR0, r16

	ldi r16, (1<<DDB3)
	out DDRB, r16

	ldi r16, (1<<DDD5)|(1<<DDD4)|(0<<DDD6)|(0<<DDD7)
	out DDRD, r16

	ldi r16, (1<<PD7)|(1<<PD6)
	out PORTD, r16

ENABLELABEL:
	ldi r16,0x01
	out TIMSK,r16

	SEI

InfiniteLoop:
jmp InfiniteLoop
