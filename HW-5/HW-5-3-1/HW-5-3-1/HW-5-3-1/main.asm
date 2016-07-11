;
; HW-5-3-1.asm
;
; Created: 12/18/2015 11:59:48 AM
; Author : Parham Alvani
;


; Replace with your application code
.org $000
reset_label:
	jmp reset_isr
.org $002
int0_label:
	jmp int0_isr
.org $004
int1_label:
	jmp int1_isr 
reset_isr:
	cli
	ldi r16 , LOW(RAMEND) 
	out SPL , r16 
	ldi r16 , HIGH(RAMEND)
	out SPH , r16
	; PD5 --> output
	ldi r16, (1<<PD5)
	out DDRD, r16
	; Enable INT1 with low level trigger
	in r16, GICR
	ori r16, (1<<INT1)
	out GICR, r16
	in r16, MCUCR
	andi r16, $F3
	out MCUCR, r16
	sei
	jmp start
int0_isr:
	cli
	sei
int1_isr:
	cli
	in r16, PORTD
	ldi r17, (1<<PD5)
	eor r16, r17
	out PORTD, r16
	sei
start:
	jmp start

