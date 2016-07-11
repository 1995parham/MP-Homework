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
	; PB0 - PB7 --> output
	ldi r16, $FF
	out DDRB, r16
	sei
	jmp start
int0_isr:
	cli
	call key_find
	call key_print
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
	ldi r21, $81
	out PORTD, r21
	in r21, PIND
	mov r22, r21
	andi r21, $01
	mov r22, r21
	breq sw1_press
	andi r21, $80
	breq sw2_press
	jmp start
sw1_press:
	cli
	call key_find
	mov r16, r0
	ldi r17, 0
	ldi r18, 0
	call EEPROM_write
	call key_print
	sei
	ret
sw2_press:
	cli
	ldi r17, 0
	ldi r18, 0
	call EEPROM_read
	mov r0, r16
	call key_print
	sei
	ret
key_print:
	mov r17, r0
	ldi r16, $3D
	cpi r17, 0
	breq key_print_ret
	ldi r16, $06
	cpi r17, 1
	breq key_print_ret
	ldi r16, $5D
	cpi r17, 2
	breq key_print_ret
	ldi r16, $4F
	cpi r17, 3
	breq key_print_ret
	ldi r16, $66
	cpi r17, 4
	breq key_print_ret
	ldi r16, $6D
	cpi r17, 5
	breq key_print_ret
	ldi r16, $7D
	cpi r17, 6
	breq key_print_ret
	ldi r16, $07
	cpi r17, 7
	breq key_print_ret
	ldi r16, $7F
	cpi r17, 8
	breq key_print_ret
	ldi r16, $6F
	cpi r17, 9
	breq key_print_ret
	ldi r16, $77
	cpi r17, 10
	breq key_print_ret
	ldi r16, $7C
	cpi r17, 11
	breq key_print_ret
	ldi r16, $61
	cpi r17, 12
	breq key_print_ret
	ldi r16, $5E
	cpi r17, 13
	breq key_print_ret
	ldi r16, $79
	cpi r17, 14
	breq key_print_ret
	ldi r16, $71
	cpi r17, 15
	breq key_print_ret
	ldi r16, $00
key_print_ret:
	out PORTB, r16
	ret
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
EEPROM_write:
	sbic EECR, EEWE
	jmp EEPROM_write
	out EEARH, r18
	out EEARL, r17
	out EEDR, r16
	sbi EECR, EEMWE
	sbi EECR, EEWE
	ret
EEPROM_read:
	sbic EECR, EEWE
	jmp EEPROM_read
	out EEARH, r18
	out EEARL, r17
	sbi EECR, EERE
	in r16, EEDR
	ret