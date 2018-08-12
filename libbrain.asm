parse_code:
	.init:
		push ax
		push bx
		push ecx
		push edx

		mov ecx, code_start	; temp code pointer
		movzx edx, [code_offset]
		add edx, code_start
		
	.parse:
		call check_for_keystroke	; Check for Ctrl-C
		jz .no_ctrl_c				; Break if necessary
		call flush_kbd_buffer
		cmp al, 03h
		je .ctrl_c_end

		.no_ctrl_c:
		cmp ecx, edx
		jge .end

		cmp byte [ecx], '+'
		je .increment

		cmp byte [ecx], '-'
		je .decrement

		cmp byte [ecx], '>'
		je .next

		cmp byte [ecx], '<'
		je .prev

		cmp byte [ecx], '.'
		je .print

		cmp byte [ecx], ','
		je .read

		cmp byte [ecx], '['
		je .left_bracket

		cmp byte [ecx], ']'
		je .right_bracket

	.finish_cycle:
		inc ecx
		jmp .parse

	.ctrl_c_end:
		mov bl, 0Bh
		mov al, '^'
		call write_char
		mov al, 'C'
		call write_char

	.end:
		pop edx
		pop ecx
		pop bx
		pop ax

		mov [code_offset], 1
		call wipe_data_cells
		mov [data_offset], 0
		mov word [brackets], 0

		call newline
		ret

	; --- OPERATIONS --- ;
	
	.increment:
		call inc_data_cell
		jmp .finish_cycle

	.decrement:
		call dec_data_cell
		jmp .finish_cycle

	.next:
		call next_data_cell
		jmp .finish_cycle

	.prev:
		call prev_data_cell
		jmp .finish_cycle

	.print:

		call get_data_cell
		mov bl, 0Bh
		call write_char
		jmp .finish_cycle

	.read:

		call handle_bf_input
		cmp al, 03h
		je .ctrl_c_end
		call set_data_cell
		jmp .finish_cycle

	.left_bracket:
		call get_data_cell
		cmp al, 0
		jne .left_bracket_end

		inc word [brackets]
		.left_bracket_jump_to_rb:

			inc ecx

			cmp byte [ecx], '['
			je .left_bracket_found_lb

			cmp byte [ecx], ']'
			je .left_bracket_found_rb

			jmp .left_bracket_jump_to_rb

		.left_bracket_end:
			jmp .finish_cycle

		.left_bracket_found_lb:
			inc word [brackets]
			jmp .left_bracket_jump_to_rb

		.left_bracket_found_rb:
			dec word [brackets]
			cmp word [brackets], 0
			jne .left_bracket_jump_to_rb

			dec ecx
			jmp .left_bracket_end

	.right_bracket:
		call get_data_cell
		cmp al, 0
		je .right_bracket_end

		inc word [brackets]
		.right_bracket_jump_to_lb:
			dec ecx

			cmp word [brackets], 0
			je .right_bracket_end

			cmp byte [ecx], '['
			je .right_bracket_found_lb

			cmp byte [ecx], ']'
			je .right_bracket_found_rb

			jmp .right_bracket_jump_to_lb

		.right_bracket_end:
			jmp .finish_cycle

		.right_bracket_found_lb:
			dec word [brackets]
			jmp .right_bracket_jump_to_lb

		.right_bracket_found_rb:
			inc word [brackets]
			jmp .right_bracket_jump_to_lb
