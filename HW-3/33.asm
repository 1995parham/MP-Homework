; INT 1
mov bl, 1
call elevator
iret

; INT 2
mov bl, 2
call elevator
iret

; INT 3
mov bl, 3
call elevator
iret

; INT 4
mov bl, 4
call elevator
iret

; INT 5
mov bl, 5
call elevator
iret

; INT 6
mov bl, 6
call elevator
iret

; INT 7
mov al, 00000100B
out 51H, al
mov cx, 2
call wait_sec
iret

elevator:
	in al, 50H
	cmp al, bl
	jg elevator_down
	jmp elevator_up

elevator_up:
	mov ch, 00H
	mov cl, bl
	sub cl, al
	add cl, cl
	mov al, 00000001B
	out 51H, al
	call wait_sec
	mov al, 00000000B
	out 51H, al
	ret

elevator_down:
	mov ch, 00H
	mov cl, al
	sub cl, bl
	add cl, cl
	mov al, 00000011B
	out 51H, al
	call wait_sec
	mov al, 00000000B
	out 51H, al
	ret
