; --- BRAINF*CK CODE

add_symbol_to_memory: ; AL = symbol
	push ebp
	mov bp, [code_offset]
	add ebp, code_start
	mov byte [ebp], al
	inc [code_offset]
	pop ebp
	ret

del_symbol_from_memory:
	push ebp
	dec [code_offset]
	mov bp, [code_offset]
	add ebp, code_start
	mov byte [ebp], 0
	pop ebp
	ret

add_symbol: ; AL = symbol
	cmp al, 0
	jz .end

	push cx
	mov cx, [code_offset]
	cmp cx, 00008FFFh
	pop cx
	je .end

	push bx
	call add_symbol_to_memory
	mov bl, 0Fh
	call write_char
	pop bx

	.end:
	ret

del_symbol:
	cmp [code_offset], 1
	je .end

	call del_symbol_from_memory
	call clear_char

	.end:
	ret

get_symbol:
	push ebp
	mov bp, [code_offset]
	add ebp, code_start
	mov al, [ebp]
	pop ebp
	ret	; AL = symbol

; --- DATA CELLS

next_data_cell:
	cmp [data_offset], 8FFFh
	je .end
	inc [data_offset]
	.end:
	ret

prev_data_cell:
	cmp [data_offset], 0
	je .end
	dec [data_offset]
	.end:
	ret

get_data_cell:
	push ebp
	mov bp, [data_offset]
	add ebp, data_start
	mov al, [ebp]
	pop ebp
	ret ; AL = data

set_data_cell: ; AL = data
	push ebp
	mov bp, [data_offset]
	add ebp, data_start
	mov byte [ebp], al
	pop ebp
	ret

inc_data_cell:
	push ebp
	mov bp, [data_offset]
	add ebp, data_start
	inc byte [ebp]
	pop ebp
	ret

dec_data_cell:
	push ebp
	mov bp, [data_offset]
	add ebp, data_start
	dec byte [ebp]
	pop ebp
	ret

wipe_data_cells:
	push ebp
	push eax
	mov ebp, data_start
	movzx eax, [data_offset]
	add eax, data_start
	.start:
	mov byte [ebp], 0
	inc ebp
	cmp ebp, eax
	jl .start
	pop eax
	pop ebp
	ret
