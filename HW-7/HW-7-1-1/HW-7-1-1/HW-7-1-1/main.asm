;
; HW-7-1-1.asm
;
; Created: 1/15/2016 5:58:20 PM
; Author : Parham Alvani
;


.org $000
reset_label:
	jmp reset_isr

reset_isr:
	ldi r18, LOW(RAMEND)
	out SPL, r18
	ldi r19, HIGH(RAMEND)
	out SPH, r19
	
	; Set port D5 as output
	ldi	r18, (1<<DDD5)
	out	DDRD, r18
	ldi	r18, (0<<PD5)
	out	PORTD, r18

	ldi r18, (0<<ACME)
	out SFIOR, r18
	ldi r18, (0<<ACD)|(0<<ACBG)|(0<<ACO)|(1<ACIE)|(1<<ACIS0)|(1<<ACIS1) 
	out ACSR, r18
	
	sei
	jmp start

start:
	sbis ACSR, ACO	
	SBI PORTD, 5  
	
	sbic ACSR, ACO	
	cbi PORTD, 5	
		
	jmp start
	
