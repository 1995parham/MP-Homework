;
; HW-7-1-2.asm
;
; Created: 1/15/2016 6:11:58 PM
; Author : Parham Alvani
;


 .org $000
 reset_label:
	jmp reset_isr
 .org $01C
 adc_label:
	jmp adc_isr
 
adc_isr:

	in r18, ADCL
	in r19, ADCH

	andi r18, $FF
	andi r19, $FF

	out	PORTC, r18
	out	PORTD, r19

	reti

reset_isr:
	ldi r18, LOW(RAMEND)
	out SPL, r18
	ldi r19, HIGH(RAMEND)
	out SPH, r19

	; Set prot C output ports
	ldi	r18, (1<<DDC0)|(1<<DDC1)|(1<<DDC2)|(1<<DDC3)|(1<<DDC4)|(1<<DDC5)|(1<<DDC6)
	out	DDRC, r18
	eor r18, r18
	out PORTC, r18
	
	; Set port D output ports
	ldi	r18, (1<<DDD0)|(1<<DDD1)|(1<<DDD2)|(1<<DDD3)|(1<<DDD4)|(1<<DDD5)|(1<<DDD6)
	out	DDRD, r18
	eor r18, r18
	out PORTD, r18

	; Set Analog Digital Convertor
	ldi	r18, (1<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX4)|(0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0)
	out ADMUX, r18
	ldi r18, (1<<ADEN)|(1<<ADSC)|(1<<ADIE)|(0<<ADPS2)|(0<<ADPS1)|(0<<ADPS0)|(1<<ADATE)
	out ADCSRA, r18
	ldi	r18, (0<<ADTS0)|(0<<ADTS1)|(0<<ADTS2)
	out	SFIOR, r18

	sei
	jmp start


start:
	jmp start

