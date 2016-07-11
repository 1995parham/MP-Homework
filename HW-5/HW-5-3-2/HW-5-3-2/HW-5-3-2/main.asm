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
	; PC0 - PC3 --> input + pullup
	; PC4 - PC7 --> output
	ldi r16, $F0
	out DDRC, r16
	in r16, SFIOR
	ldi r16, $FB
	out SFIOR, r16
	ldi r16, $0F
	out PORTC, r16
	; Enable INT0 with low level trigger
	in r16, GICR
	ori r16, (1<<INT0)
	out GICR, r16
	in r16, MCUCR
	andi r16, $FC
	out MCUCR, r16
	sei
	jmp start
int0_isr:
	cli
	call key_find
	ldi r16, $0F
	out PORTC, r16
	sei
	reti
int1_isr:
	cli
	in r16, PORTD
	ldi r17, (1<<PD5)
	eor r16, r17
	out PORTD, r16
	sei
	reti
start:
	jmp start
key_find:
	ldi r17, $00
	ldi r18, $00
	ldi r19, $7F
key_find_loop1:
	mov r16, r19
	out PORTC, r16
	nop
	in r16, PINC
	ldi r20, $04
key_find_loop2:
	ror r16
	brcc key_find_ret
	dec r20
	brne key_find_loop2
	inc r18
	inc r18
	inc r18
	inc r18
	ror r19
	inc r17
	cpi r17, $04
	brne key_find_loop1
key_find_ret:
	mov r0, r20
	add r0, r18
	dec r0
	ret