write_char: ; AL = char, BL = color
	push ax
	push bx
	push cx

	cmp al, 0Ah
	je .lf
	cmp al, 08h
	je .backspace

	mov ah, 09h
	mov bh, 0
	mov cx, 1
	int 10h
	call push_cursor_right
	
	.end:
	pop cx
	pop bx
	pop ax
	ret

	.lf:
	call newline
	jmp .end

	.backspace:
	call clear_char
	jmp .end

clear_char:
	push ax
	push bx
	call push_cursor_left
	mov al, ' '
	mov bl, 0Fh
	call write_char
	call push_cursor_left
	pop bx
	pop ax
	ret

