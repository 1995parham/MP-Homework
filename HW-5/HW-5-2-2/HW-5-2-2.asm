/*
 * _2_be.asm
 *
 *   Created: 5/15/2015 09:43:45 AM
 *   Author: Parham Alvani
 */ 
 .org	$000
		JMP RESET

RESET:
	LDI r16 , LOW(RAMEND)  
	OUT SPL , r16  
	LDI r17 , HIGH(RAMEND)  
	OUT SPH , r17  
	SEI
	LDI		r16, (1<<PD5)|(0<<PD3)
	OUT		DDRD, r16

START:
		LDI		r16, (0<<PD5)|(1<<PD3)
		OUT		PORTD, r16
		NOP

LABEL1:
		IN		 r17, PIND
		ANDI	 r17, 0x08
		BRNE	 START
		LDI		 r16, (1<<PD5)|(1<<PD3)
		OUT		 PORTD, r16


JMP LABEL1

