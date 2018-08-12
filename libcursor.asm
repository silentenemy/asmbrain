get_int10h_cursor_coordinates:
	push ax
	push bx
	push cx
	mov ah, 03h	; get cursor position
	mov bh, 00h ; page 0
	int 10h
	pop cx
	pop bx
	pop ax
	ret	; DH = row, DL = column

store_cursor_coordinates:
	push dx
	call get_int10h_cursor_coordinates
	mov [cursor_row], dh
	mov [cursor_column], dl
	pop dx
	ret

get_cursor_coordinates:
	mov dh, [cursor_row]
	mov dl, [cursor_column]
	ret	; DH = row, DL = column

set_cursor_coordinates: ; DH = row, DL = column
	push ax
	push bx
	mov ah, 02h
	mov bh, 00h ; page
	mov [cursor_row], dh
	mov [cursor_column], dl
	int 10h
	pop bx
	pop ax
	ret

scroll_up:
	push ax
	push bx
	push cx
	push dx
	mov ah, 06h
	mov al, 1
	mov bh, 0Fh ; 0 - black, F - white
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 79
	int 10h
	pop dx
	pop cx
	pop bx
	pop ax
	ret

scroll_down:
	push ax
	push bx
	push cx
	push dx
	mov ah, 07h
	mov al, 1
	mov bh, 0Fh ; 0 - black, F - white
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 79
	int 10h
	
	mov dx, [code_offset]	; if we are gone off-borders, load the buffer
	cmp dx, 1999 ; 24*80+79
	jl .end

	push es
	push bp

	; write string
	mov dh, 0
	mov dl, 0

	mov bx, [code_offset]
	sub bx, 1999
	mov bp, bx

	mov ax, 840h
	mov es, ax

	mov ah, 13h ; Write string
	mov al, 00000000b	; Write mode
	mov bh, 0	; page 0
	mov bl, 0Fh ; black und white
	mov cx, 80	; length of string
	int 10h
	
	pop bp
	pop es

	.end:
	pop dx
	pop cx
	pop bx
	pop ax
	ret

push_cursor_left:
	push dx
	call get_cursor_coordinates
	cmp dl, 0
	jnz .not_equal
	mov dl, 79
	call set_cursor_coordinates
	call scroll_down
	pop dx
	ret

	.not_equal: dec dl
	call set_cursor_coordinates
	pop dx
	ret

push_cursor_right:
	push dx
	call get_cursor_coordinates
	cmp dl, 79
	jnz .not_equal
	mov dl, 0
	call set_cursor_coordinates
	call scroll_up
	pop dx
	ret

	.not_equal: inc dl
	call set_cursor_coordinates
	pop dx
	ret

newline:
	push dx
	mov dh, 24
	mov dl, 0
	call set_cursor_coordinates
	call scroll_up
	pop dx
	ret
