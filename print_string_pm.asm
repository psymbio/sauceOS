[bits 32]
; defining consts
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null - terminated string pointed to by EDX
print_string_pm:
	pusha
	mov edx , VIDEO_MEMORY ; Set edx to the start of vid mem.

print_string_pm_loop:
	mov al, [ebx] ; ebx on al
	mov ah, WHITE_ON_BLACK ; attriutes on ah
	
	cmp al, 0 ; if al == 0 end of string so we can jump to done
	je print_string_pm_done
	
	mov [edx], ax ; store char and attri at current char cell
	add ebx, 1 ; increment ebx to next char in string
	add edx, 2 ; move to next char cell to video mem
	
	jmp print_string_pm_loop
	
print_string_pm_done:
	popa
	ret
