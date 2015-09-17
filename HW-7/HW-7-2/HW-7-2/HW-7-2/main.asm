;
; HW-7-2.asm
;
; Created: 1/15/2016 12:31:42 PM
; Author : Parham Alvani
;


 .org $000
 reset_label:
	jmp reset_isr
.org $002
int0_label:
	jmp int0_isr
 .org $018
 udre_label:
	jmp udre_isr

udre_isr:
	cli
	cbi UCSRB, TXB8
	; Skip if we have no valid data in r0
	sbrc r28, 7
	out UDR, r28
	sei
	reti

int0_isr:
	cli
	call ROW
	in  r26, PINC
	nop
	com r26
	andi r26,0xF0

	nop
	nop
	nop
	nop
	nop

	CALL COLUMN
	in r27, PINC
	nop 

	com r27
	andi r27,$0F
	
	out PORTB, r27
	or r26, r27

	call key_handler

	sei
	reti

reset_isr:
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	ldi r18, $00

	; Enable INT0 with rising edge trigger
	ldi r17,(1<<ISC01)|(1<<ISC00)
	out MCUCR,r17
	ldi r16,(1<<INT0)
	out GICR,r16
	
	; Set USART baud rate to 19.2kbps 
	ldi r16, $00
	out UBRRH, r16
	ldi r16, $19
	out UBRRL,r16

	; Set USART startup settings
	ldi r24,(0<<UMSEL)|(1<<UCSZ1)|(1<<URSEL)|(1<<UPM1)|(0<<UPM0)|(0<<UCPOL)|(1<<UCSZ0)|(0<<USBS)
	out UCSRC,r24
	ldi r24,(1<<UCSZ2)|(1<<TXEN)|(1<<RXEN)|(1<<UDRIE)
	out UCSRB,r24
	ldi r24,(0<<U2X)|(0<<MPCM)
	out UCSRA,r24

	sei
	jmp start

start:
	jmp start
	
key_handler:
key_handler_0:
	cpi r26, $11
	brne key_handler_1

	eor r28, r28
	ldi r16, $00
	or r28, r16
		
	ldi r16, $7E
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_1:
	cpi r26, $12
	brne key_handler_2
		
	eor r28, r28	
	ldi r16, $01
	or r28, r16
		
	ldi r16, $30
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_2:
	cpi r26, $14
	brne key_handler_3
		
	eor r28, r28
	ldi r16, $02	
	or r28, r16
		
	ldi r16, $6D
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_3:
	cpi r26, $18
	brne key_handler_4

	eor r28, r28
	ldi r16, $03
	or r28, r16
		
	ldi r16, $79
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_4:
	cpi r26, $21
	brne key_handler_5
		
	eor r28, r28
	ldi r16, $04	
	or r28, r16
		
	ldi r16, $33
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_5:
	cpi r26, $22
	brne key_handler_6
		
	eor r28, r28
	ldi r16, $05	
	or r28, r16
		
	ldi r16, $5B
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_6:
	cpi r26, $24
	brne key_handler_7
		
	eor r28, r28
	ldi r16, $06	
	or  r28, r16
		
	ldi r16, $5F
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_7:
	cpi r26, $28
	brne key_handler_8
		
	eor r28, r28
	ldi r16, $07	
	or  r28, r16
		
	ldi r16, $70
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_8:
	cpi r26, $41
	brne key_handler_9
		
	eor r28, r28
	ldi r16, $08	
	or  r28, r16
		
	ldi r16, $7F
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_9:
	cpi r26, $42
	brne key_handler_A
		
	eor r28, r28
	ldi r16, $09
	or r28, r16
		
	ldi r16, $7B
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_A:
	cpi r26, $44
	brne key_handler_B
		
	eor r28, r28
	ldi r16, $0A	
	or r28, r16
		
	ldi r16, $77
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_B:
	cpi r26, $48
	brne key_handler_C
		
	eor r28, r28
	ldi r16, $0B
	or r28, r16
		
	ldi r16, $1F
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_C:
	cpi r26, $81
	brne key_handler_D
		
	eor r28, r28
	ldi r16, $0C	
	or  r28, r16
		
	ldi r16, $4E
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_D:
	cpi r26, $82
	brne key_handler_E
		
	eor r28, r28
	ldi r16, $0D	
	or  r28, r16
		
	ldi r16, $3D
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_E:
	cpi r26, $84
	brne key_handler_F
		
	eor r28, r28
	ldi r16, $0E	
	or r28, r16
		
	ldi r16, $4F
	out PORTA, r16
		
	jmp key_handler_end
		
key_handler_F:
	eor r28, r28
	ldi r16, $0F
	or r28, r16
		
	ldi r16, $47
	out PORTA, r16
		
key_handler_end:
	ret
	
row:
	ldi r16,$0F
	out DDRC,r16
	
	ldi r16,$F0
	out PORTC,r16
	
	nop
	ret

column:
	ldi r16,$F0
	out DDRC,r16
	
	ldi r16,$0F
	out PORTC,r16
	
	nop
	ret