gdt_start:
	gdt_null: ; mandatory null descriptor
		dd 0x0
		dd 0x0
		; dd: double word, of 4 bytes
		
	gdt_code: ; code segment descriptor
		; base =0x0 , limit =0xfffff ,
		; 1 st flags : ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
		; type flags : ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
		; 2 nd flags : ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100 b
		
		dw 0xffff ; Limit ( bits 0 -15)
		dw 0x0 ; Base ( bits 0 -15)
		db 0x0 ; Base ( bits 16 -23)
		db 10011010b ; 1 st flags , type flags
		db 11001111b ; 2 nd flags , Limit ( bits 16 -19)
		db 0x0 ; Base ( bits 24 -31)
	
	gdt_data: ; the data segment descriptor
		; same as code but for type flags
		; type flags : ( code )0 ( expand down )0 ( writable )1 ( accessed )0 -> 0010 b
		dw 0xffff ; Limit ( bits 0 -15)
		dw 0x0 ; Base ( bits 0 -15)
		db 0x0 ; Base ( bits 16 -23)
		db 10010010b ; 1 st flags , type flags
		db 11001111b ; 2 nd flags , Limit ( bits 16 -19)
		db 0x0 ; Base ( bits 24 -31)
		
gdt_end:
; gdt end signifies the end of gdt -> now we can calculate the size of the gdt

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; size of gdt is less than true size
	dd gdt_start ; start address of gdt
	
; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0x0 -> NULL ; 0 x08 -> CODE ; 0x10 -> DATA )

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
