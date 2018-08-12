format binary

org 7C00h
include 'boot.asm'

org 7E00h

init:
	.init_mem:
	mov al, '~'
	call add_symbol_to_memory

main:
	call handle_code_input
	jmp main

includes:
	;include 'libcursor.asm'	; included in boot.asm
	;include 'libtext.asm'		; included in boot.asm
	include 'libkbd.asm'
	include 'libmem.asm'
	include 'libbrain.asm'

defines:
	
	virtual
		code_offset dw 0	; 0-8FFFh
		data_offset dw 0	; 0-8FFFh
		brackets dw 0		; for counting brackets and loops
	end virtual

	virtual at 00008400h
		code_start:
	end virtual

	virtual at 00011400h
		data_start:
	end virtual

