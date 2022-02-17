SECTION MBR			; using sreg, rather than vstart
	mov ax, 0x7c0	; edit segment register manually, instead of hard code vstart
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax 
	mov sp, 0x7c00
	;mov ecx, 0		; initialize ecx

; Clear Screen use 0x06 sub-func in interrupt 0x10(Video Service)
; function description: scroll up the window
; INPUTS:
; AH function_index = 0x06
; AL = rows to scroll up
; BH = scroll up property
; (CL, CH) = Top Left Corner of window
; (DL, DH) = Lower Right Corner of window
; No return
	mov ax, 0x0600     ; also can mov ah, 6; mov ax, 0
	mov bx, 0x0700
	mov cx, 0          ; Top Left (0, 0)
	mov dx, 0x184f     ; Lower Right: (80, 25) ((79, 14))
					   ; in VGA Text Module, only 80c in one line, max 25 lines
	int 0x10

;; get cursor position
;; AH function index = 0x03
;; bh page number of cursor
;; return
;; ch: start row; cl: end row;
;; dh: row pos; dl: col pos;
	;mov ah, 3
	;mov bh, 0

	;int 0x10

; print string
; function index = 0x13
	; set string
	mov bp, message		; es:bp = message to print
						; es is set as cs at line 4
	mov dx, 0			; move banner to top left corner
						;; we are using cursor pos in dx, abandon cx
	mov cx, [len]		; string length
	mov ax, 0x1301		; ah = 0x13, function index
						; al = 0x01, write mode
	mov bx, 0x0c		; bh = 0, page index
						; bl = 0x02; font color, green on black
	int 0x10

	jmp $				; pulse program

	message db "Hello, world.", 0x0a, 0x0d, "This is a MBR."
	len db $ - message
	db 510-($-$$) dup (0)
	db 0x55, 0xaa
