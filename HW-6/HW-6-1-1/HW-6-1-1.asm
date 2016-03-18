;
; HW-6-1-1.asm
;
; Created: 12/18/2015 11:59:48 AM
; Author : Parham Alvani
;

 .ORG $000
	jmp RESET
 .ORG $012
	jmp timer0
	 

timer0:

	inc r18
	cpi r18,4

	brne WAITLABEL 

	cpi r17,0

	brne LABEL1

	ldi r16,(1<<PD4)|(0<<PD5)
	out PORTD,r16
	ldi r17,1
	
	jmp COUNTER0 

LABEL1:

	ldi r16,(0<<PD4)|(1<<PD5)
	
	out PORTD,r16
	ldi r17,0
	
	jmp COUNTER0  
	reti

RESET:

	ldi r16, LOW(RAMEND)
	out SPL, r16
	
	ldi r17, HIGH(RAMEND)
	out SPH, r16
	
	ldi r16,(1<<PD4)|(1<<PD5)
	out DDRD,r16
	
	ldi r16,(0<<PD4)|(1<<PD5)
	out PORTD,r16
	
	ldi r16,0x05
	out TCCR0,r16

COUNTER0:

	ldi r18,0

WAITLABEL:

	ldi r16,0x01
	out TIMSK,r16

	sei

InfinteLoop:

jmp InfinteLoop
