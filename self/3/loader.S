%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	mov bx, 0x100
	mov si ,message
	mov cx, [len]
	call my_print

	jmp $


my_print:					; vesion 3.0
; print string with gpu
; param: bx: (bh, bl)=(row, col) offset on the screen
; param si: string address
; param cx: length
	; mov cx, dx
	mov ax, 0xa0
	mul bh
	add ax, bl
	mov bx, ax
  loc_0x37:
	mov al, byte [si]
	mov byte [gs:bx], al
	add bx, 1
	mov byte [gs:bx], 0x0a		; color
	add si, 1
	add bx, 1
	loop loc_0x37
	retn
; my_print endp

; data
	message db "Loader ready."
	len dw $ - message