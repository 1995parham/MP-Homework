/*
 * _2_alef.asm
 *
 *   Created: 5/15/2015 09:23:45 AM
 *   Author: Parham Alvani
 */ 
 
 .org	$000
		JMP RESET

RESET:
	LDI r16 , LOW(RAMEND)  
	OUT SPL , r16  
	LDI r17 , HIGH(RAMEND)  
	OUT SPH , r17  

