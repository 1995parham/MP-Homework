/*
 * _2_jim.asm
 *
 *   Created: 5/15/2015 10:20:35 AM
 *   Author: Parham Alvani
 */ 

.org	$000
		JMP RESET

RESET:
	
	LDI r16 , LOW(RAMEND)  
	OUT SPL , r16  
	LDI r17 , HIGH(RAMEND)  
	OUT SPH , r17  

	LDI	r16, (1<<PD4)|(0<<PD6)
	OUT	DDRD, r16
	LDI	r16, (1<<PD6)|(0<<PD4)
	OUT	PORTD, r16	
	SEI

FIRSTLOOP:
READ:
	IN      r16, PIND
	ANDI	r16, 0x40
	BRNE	READ
	LDI		r17, 0x0A	  
SECONDLOOP:	
	LDI r16, 1<<PD4
	OUT	PORTD, r16
	CALL delay1s
	CALL delay1s
	LDI	r16, 0<<PD4
	OUT	PORTD, r16
	CALL delay1s
	CALL delay1s
	CALL delay1s
	CALL delay1s
	DEC r17
    BRNE SECONDLOOP
	JMP LABELLOOP



delay1s:
	LDI r20, 0xfa
LABEL1:
	LDI r21, 0xfa
LABEL2:	
	NOP 
	NOP
	NOP
	SUBI r21,0x01
	BRNE LABEL2
	NOP 
	NOP
	NOP
	SUBI r20,0x01
	BRNE LABEL1
RET
