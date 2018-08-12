check_for_keystroke:
	mov ah, 01h
	int 16h
	ret

flush_kbd_buffer:
	mov ah, 0
	int 16h
	ret

handle_code_input:
	push ax

	call check_for_keystroke
	jz .end

	mov bl, 0Fh

	cmp al, 08h		; is this a backspace
	jz .backspace
	cmp al, 0Dh		; is this enter
	jz .enter

	call add_symbol

	.flush: call flush_kbd_buffer

	.end:
	pop ax	
	ret

	.backspace:
		call del_symbol
		jmp .flush

	.enter:
		call newline
		call parse_code
		
		mov bl, 0Bh
		mov al, '~'
		call write_char

		jmp .flush

handle_bf_input:
	.start:
	call check_for_keystroke
	jz .start
	call flush_kbd_buffer

	cmp al, 0Dh
	jne .end
	mov al, 0Ah

	.end:
	ret

