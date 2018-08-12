.load_from_drive:

	; READ THE SECTOR NOW!

	mov ax, 07E0h
	mov es, ax	; buffer segment
	mov bx, 0000h	; buffer offset

	mov ah, 02h	; Set operation to 'read sector'
	mov al, 2	; Read exactly two sectors
	mov dh, 0	; on the first head
	mov ch, 0	; first cylinder
	mov cl, 2	; second sector

	int 13h
	jc .read_error

.init_stack:
	mov esp, 1A400h

.init_video:
	mov ah, 00h ; Set video mode
	mov al, 03h ; to 03h (http://www.columbia.edu/~em36/wpdos/videomodes.txt)
	int 10h

.write_welcome:
	mov dh, 11
	mov dl,	7
	call set_cursor_coordinates

	mov ax, 0
	mov es, ax
	mov bp, welcome_line1

	mov ah, 13h ; Write string
	mov al, 00000001b	; Write mode
	mov bl, 0Bh	; color light cyan
	mov cx, 66	; length of string
	int 10h

	mov dh, 12
	mov dl, 29
	call set_cursor_coordinates
	mov bp, welcome_line2
	mov cx, 22	; length
	int 10h

.print_invitation:
	mov dh, 24
	mov dl, 0
	call set_cursor_coordinates

	mov bl, 0Bh ; cyan
	mov al, '~'
	call write_char

.enter_stage2:
	jmp 0000:7E00h

.read_error:
	mov ax, 0
	mov es, ax
	mov bp, error_line

	mov ah, 13h ; Write string
	mov al, 00000001b	; Write mode
	mov bl, 0Bh	; color light cyan
	mov cx, 18	; length of string
	int 10h

	hlt

.defines:
	include 'libcursor.asm'
	include 'libtext.asm'
	welcome_line1 db "Welcome to ASMBrain, (written in assembler) brainf*ck interpreter!"
	welcome_line2 db "github.com/silentenemy"
	error_line db "Error reading disk"
	cursor_row rb 1
	cursor_column rb 1

.signature:
	times 510 - ($ - $$) db 0
	db 0x55
	db 0xAA
