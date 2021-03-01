; use BIOS to read sectors into memory
[org 0x7c00]
[bits 16]

; section .data
	; constants
	; VAL equ 0x1234

; section .bss
	; mutatable variables
	; VAR: resb 8


section .text
	global main

main:
	; we don't want interupts to be called when we are in the segment register
	; use cli and sti for safety
	cli
	; so that it doesn't weirdly segment stuf when we load into 0x7c00
	jmp 0x0000:ZeroSeg
	ZeroSeg:
		; mov ax, 0
		; the above is another way to do it
		; just do it the xor way because it requires two bytes
		; wheareas mov requires three bytes
		xor ax, ax
		; move all the segment registers to ax
		mov ss, ax
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		; move stack pointer to main
		mov sp, main
		; clear direction flag: set direction flag to zero
		; controls the order in which strings are read
		; that we read from the lowest memory address to the highest memory address
		cld
	sti

	; reset disk because BIOS might not do it
	push ax
	xor ax, ax
	int 0x13
	pop ax

	mov si, STR
	call printf
	mov al, 1
	mov cl, 2
	call read_disk
	; mov dx, 0x1234
	mov dx, [0x7c00 + 510]
	; call printh
	call printh
	jmp test
	mov bp, 0x9000 ; set the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call printf
	call switch_to_pm
	jmp $

	%include "printf.asm"
	%include "read_disk.asm"
	%include "printh.asm"
	%include "testa20.asm"
	%include "print_string_pm.asm"
	%include "switch_to_pm.asm"
	%include "gdt.asm"

STR: db 'Welcome to sauceOS:)', 0x0a, 0x0d, 0
DISK_ERR_MSG: db 'There was an error loading the disk.', 0x0a, 0x0d, 0
SCND_SCTR: db 'Second sector successfully initialized.', 0x0a, 0x0d, 0
MSG_REAL_MODE: db 'Started in 16-bit Real Mode', 0x0a, 0x0d, 0
MSG_PROT_MODE: db 'Successfully landed in 32-bit Protected Mode', 0x0a, 0x0d, 0

; padding and the magic number
times 510-($-$$) db 0
dw 0xaa55

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	jmp $
; checking if we can access the second sector now
test:
	mov si, SCND_SCTR
	call printf


; solve disk error pad out the second sector
times 512 db 0
