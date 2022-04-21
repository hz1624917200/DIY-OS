%include "boot.inc"
SECTION MBR vstart=0x7c00
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax 
	mov sp, 0x7c00
	mov ax, 0xb800	; auxiliary section register
	mov gs, ax
	mov ecx, 0		; initialize ecx

; Clear Screen use 0x06 sub-func in interrupt 0x10(Video Service)
; function description: scroll up the window
; INPUTS:
; AH function_index = 0x06
; AL = rows to scroll up, 0: clear
; BH = scroll up color property
; (CL, CH) = Top Left Corner of window
; (DL, DH) = Lower Right Corner of window
; No return
	mov ax, 0x0600		; also can mov ah, 6; mov ax, 0
	mov bx, 0x0700		; BH: Light Gray on Black
	mov cx, 0			; Top Left (0, 0)
	mov dx, 0x184f		; Lower Right: (80, 25) ((79, 14))
						; in VGA Text Module, only 80c in one line, max 25 lines
	int 0x10

	mov bx, 0
	mov si, message
	mov dx, [len_message]
	call my_print

	mov eax, LOADER_START_SECTOR		; Start Sector of Loader
	mov bx, LOADER_BASE_ADDR			; Loader base address
	mov cx, 4							; Sector count = 4
	call rd_disk_m_16

	; jmp $			; for debug
	jmp LOADER_BASE_ADDR

my_print: 
; print string with gpu
; param: bx: offset on the screen
; param si: string address
; param dx: length
	mov cx, dx
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


rd_disk_m_16:
; param eax = LBA Sector number
; bx = destination address
; cx = sector count
	mov esi, eax		; backup eax
	
	mov dx, 0x1f2		; sector count
	mov al, cl
	out dx, al

	mov eax, esi

	mov dx, 0x1f3			; set LBA address low 24b
  loc_72:
	out dx, al
	add dx, 1
	shr eax, 8
	cmp dx, 0x1f5
	jbe loc_72

	and al, 0x0f			; set LBA address high 4b
	or al, 0xe0
	out dx, al

	add dx, 1
	mov al, 0x20			; read command
	out dx, al

  .not_ready:
	nop
	nop
	in al, dx
	and al, 0x88			; 4: ready; 7: busy
	cmp al, 0x08
	jnz .not_ready

	and cx, 0xf
	shl cx, 8				; words to read, *512 / 2

	mov dx, 0x1f0			; data port
  .go_on_read:
	in ax, dx
	mov [bx], ax
	add bx, 2
	loop .go_on_read

	retn


; data
	message db "Hello, world. This is a MBR."
	len_message db $ - message
	; times 510-($-$$) db 0
	db 510 - ($-$$) dup (0)
	db 0x55, 0xaa
