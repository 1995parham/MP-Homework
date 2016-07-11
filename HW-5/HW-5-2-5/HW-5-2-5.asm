/*
 * _2_he.asm
 *
 *   Created: 5/15/2015 10:30:55 AM
 *   Author: Parham Alvani
 */ 
  .org	$000
		JMP RESET

RESET:
	LDI r16 , LOW(RAMEND)  
	OUT SPL , r16  
	LDI r17 , HIGH(RAMEND)  
	OUT SPH , r17  
	
	LDI	r16, (0<<DDD6)|(0<<DDD3)|(1<<DDD5)
	OUT	DDRD, r16

	LDI	r16, (1<<PD3)|1<<PD6|0<<PD5
	OUT	PORTD, r16	
	SEI

READLABEL:
	IN		r16, PIND
	ANDI	r16, 0x08
	BRNE	READLABEL
	
LABEL1:
	LDI		r16, (1<<PD3)|1<<PD6|(1<<PD5)
	OUT		PORTD, r16
	IN		r17, PIND
	ANDI	r17, 0x40
	BRNE	WATCHLABEL
	WDR
	JMP		LABEL1
	
WATCHLABEL:	
	LDI		r18, (0<<WDTOE)|(1<<WDE)|(1<< WDP2) | (1<< WDP1) | (1<< WDP0)
	OUT		WDTCR, r18
	JMP		LABEL1


