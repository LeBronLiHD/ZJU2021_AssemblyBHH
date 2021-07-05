.386
data segment use16
num_one dw 0
buffer  db 7, 0, 7 dup(0);input the number
equa	db 20 dup(0);output the formula
dec_ans	db 17 dup(" "), 0Dh, 0Ah, '$';output the decimal result 
hex_ans	db 11 dup(" "), 0Dh, 0Ah, '$';output the hexadecimal result
bin_ans	db 40 dup(" "), 0Dh, 0Ah, '$';output the binary result
msg_1	db 0Dh, 0Ah, '-*-*-  HW3(basicASM) LI Haodong <3190104890> -*-*-', 0Dh, 0Ah, '$'
msg_2	db 'Input the first number  -> $'
msg_3	db 'Input the second number -> $'
msg_e	db 'The equation is         -> $'
msg_4	db 'Result in decimal       -> $'
msg_5	db 'Result in hexadecimal   -> $'
msg_6	db 'Result in binary        -> $'
flag	db 0
data ends

code segment use16
assume cs:code, ds:data
main:
	mov	ax, data
	mov	ds, ax
	call	generate_equation
	mov	dx, 0
	mov	bx, ax
	mov	ax, num_one
	mul	bx	;dx:ax = ax * bx
	call	output_equation
	call	output_dec
	call	output_hex
	call	output_bin
	call	output_all_ans
	mov	ah, 4Ch
	mov	al, 9
	int	21h

output_all_ans:
	mov	ah, 09h
	mov	dx, offset msg_4
	int	21h
	mov	ah, 09h
	mov	dx, offset dec_ans
	int	21h
	mov	ah, 09h
	mov	dx, offset msg_5
	int	21h
	mov	ah, 09h
	mov	dx, offset hex_ans
	int	21h
	mov	ah, 09h
	mov	dx, offset msg_6
	int	21h
	mov	ah, 09h
	mov	dx, offset bin_ans
	int	21h
	ret

generate_equation:
	mov	dx, offset msg_1
	mov	ah, 09h
	int	21h
	mov	si, 0
	call	input_string
	call	convert
	mov	num_one, ax
	call	newline
	mov	equa[si],' '
	inc	si
	mov	equa[si],'*'
	inc	si
	mov	equa[si],' '
	inc	si
	call	input_string   
	call	convert
	mov	equa[si],' '
	inc	si
	mov	equa[si], '='
	inc	si
	mov	equa[si], '$'
	ret

convert:
	mov	bx, 2
	mov	ax, 0
	mov	dx, 0
convert_next:
	mov	dl, buffer[bx]
	cmp	dl, 0Dh
	je	convert_done
	imul	ax, ax, 10
	mov	equa[si], dl
	sub	dl, '0'
	add	ax, dx
	inc	bx
	inc	si
	jmp	convert_next
convert_done:
	ret

output_equation:
	push	ax
	push	dx
	mov	ax, 0
	mov	dx, 0
	call	newline
	mov	dx, offset msg_e
	mov	ah, 09h
	int	21h
	mov	dx, offset equa
	mov	ah, 09h
	int	21h
	pop	dx
	pop	ax
	ret


output_dec:
	push	ax
	push	dx
	mov	ah, 2
	mov	dl, 0Dh
	int	21h
	mov	ah, 2
	mov	dl, 0Ah
	int	21h
	pop	dx
	pop	ax
	push	ax
	push	dx
	xor	cx, cx
	xor	di, di
dec_again:
	push	cx
	mov	cx, 10
	call	divde
	pop	cx
	add	dl, '0'
	push	dx
	mov	dx, bx
	inc	cx
	cmp	ax, 0
	jne	dec_again
dec_pop_again:
	pop	dx
	mov	dec_ans[di], dl
	inc	di
	dec	cx
	jnz	dec_pop_again
	pop	dx
	pop	ax
	ret


output_hex:
	push	ax
	push	dx
	push	ax
	mov	ax, dx
	mov	cx, 4
	mov	bx, 2
	mov	di, 0
hex_again:
	push	cx
	mov	cl, 4
	rol	ax, cl
	push	ax
	and	ax, 000Fh
	cmp	ax, 10
	jb	is_digit
is_alpha:
	sub	al, 10
	add	al, 'A'
	jmp	finish_4bits
is_digit:
	add	al,'0'
finish_4bits:
	mov	hex_ans[di], al
	pop	ax
	pop	cx
	inc	di
	cmp	di, 4
	jz	add_space
	jmp	no_space
add_space:
	mov	hex_ans[di], ' '
	inc	di
no_space:
	dec	cx
	jnz	hex_again
	dec	bx
	cmp	bx, 0
	je	hex_next
	mov	cx, 4
	pop	ax
	jmp	hex_again
hex_next:
	mov	hex_ans[di],'H'
	pop	dx
	pop	ax
	ret


output_bin:
	push	ax
	mov	ax, dx
	mov	cx, 10h
	mov	di, 0
	mov	bx, 2
	mov	si, 4
bin_again:
	push	cx
	mov	cl, 1
	rol	ax, cl
	push	ax
	and	ax, 0001h
	add	al, '0'
	mov	bin_ans[di], al
	pop	ax
	pop	cx
	inc	di
	dec	si
	cmp	si, 0
	jne	bin_continue
	inc	di
	mov	si, 4
bin_continue:
	dec	cx  
	jnz	bin_again
	dec	bx
	cmp	bx, 0
	je	bin_next
	mov	cx, 10h
	pop	ax
	jmp	bin_again
bin_next:
	dec	di
	mov	bin_ans[di], 'B'
	ret


divde:
	; X/N=int(H/N)*65535+[rem(H/N)*65535+L]/N
	push	ax
	mov	ax, dx
	xor	dx, dx
	div	cx
	mov	bx, ax
	pop	ax
	div	cx
	ret


newline:
	mov	ah, 02h
	mov	dl, 0Dh
	int	21h
	mov	ah, 02h
	mov	dl, 0Ah
	int	21h
	ret


input_string:
	push	ax
	mov	ah, 0
	mov	al, flag
	cmp	ax, 0
	jz	first_input
	jmp	second_input
first_input:
	mov	dx, offset msg_2
	mov	ah, 09h
	int	21h
	jmp	first_input_done
second_input:
	mov	dx, offset msg_3
	mov	ah, 09h
	int	21h
first_input_done:
	pop	ax
	mov	ah, 0Ah
	mov	dx, offset buffer
	int	21h
	mov	flag, 1
	ret

code	ends
end	main