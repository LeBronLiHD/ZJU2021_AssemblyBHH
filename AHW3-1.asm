; LI Haodong
; asm HW3
.386
data segment use16
	buffer	db 100, 0, 100 dup(0)
	equa	db 100 dup(0)
	polish	db 100 dup(0)
	po_op	db 50 dup(0)
	s_num	dw 50 dup(0)
	s_ope	db 50 dup(0)
	compute	dw 100 dup(00h)
	cnt_com	dw 0
	answer	dw 0
	c_ope	db 50 dup(0)
	NNN	dw 0
	t_num	db 5 dup(0)
	bin_a	db 33 dup(0)
	dec_a	db 15 dup(0)
	hex_a	db 9 dup(0)
	number	dw 0
	initmsg	db 0Dh, 0Ah, '-*-*-*- ASM Hw3 3190104890 -*-*-*-', 0Dh, 0Ah, 0Dh, 0Ah, '$'
	msg_1	db 'Input your string -> $'
	msg_2	db 'String you typed  -> $'
	msg_3	db 'Infix expression  -> $'
	msg_4	db 'Reverse polish    -> $'
	msg_5	db 'Operation stack   -> $'
	msg_6	db 'Number stack(dec) -> $'
	msg_7	db 'Compute(debug)    -> $'
	msg_8	db 0Dh, 0Ah, 0Dh, 0Ah, 'Result (in dec) = $'
	msg_9	db 0Dh, 0Ah, 'Result (in bin) = $'
	msg_A	db 0Dh, 0Ah, 'Result (in hex) = $'
	msg_dbg	db ' <LLL> $'
	msg_b	db ' $'
	Er_msg	db 'ERROR: Input string is empty!$'
	cntEqua	dw 0
	cnt_K	dw 0
	com_O	dw 0
data ends

stack1 segment stack use16
	db	100 dup(0)
stack1 ends

num_stack segment stack use16
	db	50 dup(0)
num_stack ends

ope_stack segment stack use16
	db	50 dup(0)
ope_stack ends

code segment use16
	assume cs:code, ds:data, ss:stack1
;===================================== Begin Of Main() =======================
main:
	mov	ax, data
	mov	ds, ax
	call	input_string
	call	new_line
	call	output_string
	call	delete_space
	call	display_equa
	call	convert_polish
	call	display_polish
	call	convert_compute
	call	compute_debug
	call	compute_exexute
	call	display_answer
	call	terminate
;===================================== End Of Main() =======================

display_answer:		; ============== Function: display_answer
	call	answer_dec
	mov	dx, offset msg_8
	mov	ah, 09h
	int	21h
	mov	dx, offset dec_a
	mov	ah, 09h
	int	21h
	call	answer_bin
	mov	dx, offset msg_9
	mov	ah, 09h
	int	21h
	mov	dx, offset bin_a
	mov	ah, 09h
	int	21h
	call	answer_hex
	mov	dx, offset msg_A
	mov	ah, 09h
	int	21h
	mov	dx, offset hex_a
	mov	ah, 09h
	int	21h
	call	new_line
	ret

answer_dec:		; ============== Function: answer_dec
	mov	ax, answer
	mov	bx, 0
	mov	cx, 0Ah
	mov	si, 0
dec_again:
	div	cl
	mov	dl, ah
	add	dl, '0'
	mov	dh, 0
	mov	ah, 0
	push	dx
	inc	bx
	cmp	ax, 0
	jnz	dec_again
dec_out_again:
	pop	dx
	mov	dh, 0
	mov	dec_a[si], dl
	inc	si
	dec	bx
	cmp	bx, 0
	jnz	dec_out_again
	mov	dec_a[si], '$'
	ret

answer_bin:		; ============== Function: answer_bin
	mov	ax, answer
	mov	ah, 0
	mov	di, 0
	mov	si, 4
	mov	cl, 01h
bin_again:
	rol	al, cl
	push	ax
	and	ax, 01h
	add	al, '0'
	mov	bin_a[di], al
	inc	di
	pop	ax
	dec	si
	cmp	si, 0
	jnz	bin_continue
	cmp	di, 09h
	jz	bin_continue
	mov	bin_a[di], ' '
	inc	di
	mov	si, 04h
bin_continue:
	cmp	di, 09h
	jz	bin_done
	jmp	bin_again
bin_done:
	mov	bin_a[di], 'B'
	inc	di
	mov	bin_a[di], '$'
	ret

answer_hex:		; ============== Function: answer_hex
	mov	ax, answer
	mov	ah, 0
	mov	di, 0
	mov	cl, 04h
hex_again:
	rol	al, cl
	push	ax
	and	ax, 0Fh
	add	al, '0'
	mov	hex_a[di], al
	inc	di
	pop	ax
	cmp	di, 02h
	jnz	hex_again
	mov	hex_a[di], 'H'
	inc	di
	mov	hex_a[di], '$'
	ret

compute_exexute:	; ============== Function: compute_exexute
	mov	bx, cnt_com
execute_again:
	mov	si, 0
	cmp	bx, 01h
	jz	execute_done
execute_again_again:
	mov	dx, compute[si]
	mov	dh, 0
	inc	si
	cmp	dx, '+'
	jz	add_and_refersh
	cmp	dx, '-'
	jz	sub_and_refersh
	cmp	dx, '*'
	jz	mul_and_refersh
	cmp	dx, '/'
	jz	div_and_refersh
	cmp	dx, '$'
	jz	execute_again
	jmp	execute_again_again
execute_done:
	mov	dx, compute[si]
	mov	dh, 0
	mov	[answer], dx
	ret

add_and_refersh:	; ============== Function: add_and_refersh
	push	cx
	push	si
	push	ax
	dec	si
	mov	byte ptr compute[si], 0
	dec	si
	mov	cx, compute[si]
	mov	byte ptr compute[si], 0
	dec	si
	mov	ax, compute[si]
	mov	byte ptr compute[si], 0
	add	ax, cx
	mov	ah, 0
	mov	byte ptr compute[si], al
	call	refresh_bx
	pop	ax
	pop	si
	pop	cx
	sub	bx, 02h ; total number
	jmp	execute_again

sub_and_refersh:	; ============== Function: sub_and_refersh
	push	cx
	push	si
	push	ax
	dec	si
	mov	byte ptr compute[si], 0
	dec	si
	mov	cx, compute[si]
	mov	byte ptr compute[si], 0
	dec	si
	mov	ax, compute[si]
	mov	byte ptr compute[si], 0
	sub	ax, cx
	mov	ah, 0
	mov	byte ptr compute[si], al
	call	refresh_bx
	pop	ax
	pop	si
	pop	cx
	sub	bx, 02h
	jmp	execute_again

mul_and_refersh:	; ============== Function: mul_and_refersh
	;mov al, 5h
	;mov bl, 10h
	;mul bl		; ax = al * bl
	push	si
	push	bx
	push	ax
	dec	si
	mov	byte ptr compute[si], 0
	dec	si
	mov	bx, compute[si]
	mov	byte ptr compute[si], 0
	dec	si
	mov	ax, compute[si]
	mov	byte ptr compute[si], 0
	mul	bl
	mov	ah, 0
	mov	byte ptr compute[si], al
	call	refresh_bx
	pop	ax
	pop	bx
	pop	si
	sub	bx, 02h
	jmp	execute_again

div_and_refersh:	; ============== Function: div_and_refersh
	push	cx
	push	si
	push	ax
	dec	si
	mov	byte ptr compute[si], 0
	dec	si
	mov	cx, compute[si]
	mov	byte ptr compute[si], 0
	dec	si
	mov	ax, compute[si]
	mov	byte ptr compute[si], 0
	mov	ch, 0
	div	cl
	mov	ah, 0
	mov	byte ptr compute[si], al
	call	refresh_bx
	pop	ax
	pop	si
	pop	cx
	sub	bx, 02h
	jmp	execute_again

refresh_bx:		; ============== Function: refresh_bx
	push	si
	mov	si, 0
refresh_bx_again:
	mov	dx, compute[si]
	inc	si
	cmp	dx, '$'
	jz	refresh_bx_done
	cmp	dx, 0
	jz	refresh_zero
	jmp	refresh_bx_again
refresh_zero:
	dec	si
	push	si
refresh_zero_again:
	inc	si
	mov	dx, compute[si]
	mov	dh, 0
	cmp	dx, 0
	jz	refresh_zero_again
	mov	byte ptr compute[si], 0
	pop	si
	mov	byte ptr compute[si], dl
	jmp	refresh_bx_again
refresh_bx_done:
	pop	si
	ret

compute_debug:		; ============== Function: compute_debug
	call	new_line
	mov	dx, offset msg_7
	mov	ah, 09h
	int	21h
	mov	dx, offset compute
	mov	ah, 09h
	int	21h
	ret

display_polish:		; ============== Function: display_polish
	mov	dx, offset msg_4
	mov	ah, 09h
	int	21h
	mov	dx, offset polish
	mov	ah, 09h
	int	21h
	ret

convert_compute:	; ============== Function: convert_compute
	mov	bx, offset equa
	mov	cx, offset equa
	mov	si, 0
	mov	di, 0
compute_again:
	mov	dl, [bx]
	inc	bx
	cmp	dl, 0Dh
	jz	compute_done
	cmp	dl, '0'
	jb	compute_ope
	cmp	dl, '9'
	ja	compute_ope
	push	bx
	sub	bx, 01h
	sub	bx, cx
	mov	t_num[bx], dl
	pop	bx
	mov	NNN, 01h
	jmp	compute_again
compute_ope:
	mov	cx, bx
	push	ax
	mov	ax, NNN
	cmp	ax, 0
	jz	no_number
	pop	ax
	push	bx
	push	ax
	push	dx
	push	cx
	call	convert_num
	pop	cx
	pop	dx
	pop	ax
	pop	bx
	mov	ax, number
	mov	compute[si], ax
	inc	si
	push	si
	call	clear_t_num
	pop	si
com_continue:
	mov	NNN, 0
	mov	c_ope[di], dl
	inc	di
	cmp	dl, '('
	jz	compute_again
	cmp	dl, ')'
	jz	com_right_k
	cmp	di, 01h
	jz	compute_again
	push	di
	sub	di, 02h
	mov	al, c_ope[di]
	call	com_cmp_ope
	pop	di
	mov	c_ope[di], 0
	mov	ax, com_O
	sub	di, ax
	sub	di, 01h
	mov	c_ope[di], dl
	inc	di
	jmp	compute_again
no_number:
	pop	ax
	jmp	com_continue
no_number_done:
	pop	ax
	jmp	com_continue_done
com_right_k:
com_right_again:
	sub	di, 01h
	mov	dl, c_ope[di]
	cmp	dl, ')'
	jz	com_right_again
	cmp	dl, '('
	jz	compute_again
	mov	dh, 0
	mov	compute[si], dx
	mov	c_ope[di], 0
	inc	si
	jmp	com_right_again
compute_done:
	push	ax
	mov	ax, NNN
	cmp	ax, 0
	jz	no_number_done
	pop	ax
	push	bx
	push	ax
	push	dx
	push	cx
	call	convert_num
	pop	cx
	pop	dx
	pop	ax
	pop	bx
	mov	ax, number
	mov	compute[si], ax
	inc	si
	push	si
	call	clear_t_num
	pop	si
com_continue_done:
	cmp	di, 0
	jnz	com_not_empty
compute_ret:
	mov	compute[si], '$'
	mov	[cnt_com], si
	ret
com_not_empty:
	mov	ax, cntEqua
	sub	ax, 01h
	cmp	ax, si
	jz	compute_ret
	sub	di, 01h
	mov	dl, c_ope[di]
	mov	dh, 0
	cmp	dl, 0
	jz	compute_ret
	mov	compute[si], dx
	inc	si
	cmp	di, 0
	jz	compute_ret
	jmp	com_not_empty

com_cmp_ope:		; ============== Function: com_cmp_ope
			; parameter: al, dl
	push	di
com_cmp_again:
	cmp	dl, '+'
	jz	c_low_priority
	cmp	dl, '-'
	jz	c_low_priority
	; dl is * or /
	cmp	dl, '*'
	jz	c_high_priority
	cmp	dl, '/'
	jz	c_high_priority
c_high_priority:
	cmp	al, '*'
	jz	c_high_output_al
	cmp	al, '/'
	jz	c_high_output_al
	jmp	com_cmp_done
c_high_output_al:
	mov	ah, 0
	mov	compute[si], ax
	inc	si
	mov	c_ope[di], 0
	cmp	di, 0
	jz	com_cmp_done
	sub	di, 01h
	;mov	dl, al
	mov	al, c_ope[di]
	jmp	com_cmp_again
c_low_priority:
	cmp	al, '('
	jz	com_cmp_done ; al is + or - or * or / or 0
	cmp	al, 0
	jz	com_cmp_done
	jmp	c_low_output_al
c_low_output_al:
	mov	ah, 0
	mov	compute[si], ax
	inc	si
	mov	c_ope[di], 0
	cmp	di, 0
	jz	com_cmp_done
	sub	di, 01h
	;mov	dl, al
	mov	al, c_ope[di]
	jmp	com_cmp_again
com_cmp_done:
	pop	ax
	;inc	ax
	sub	ax, di
	mov	com_O, ax
	ret

clear_t_num:		; ============== Function: clear_t_num
	mov	si, 0
clear_again:
	mov	t_num[si], 0
	inc	si
	cmp	si, 05h
	jz	clear_done
	jmp	clear_again
clear_done:
	mov	number, 0
	ret

convert_polish:		; ============== Function: convert_polish
	; if number, push into num_stack
	; if operation, push into ope_stack
	call	operation_push
	call	debug_ope
	call	prepare_display
	ret

prepare_display:	; ============== Function: prepare_display
	mov	bx, offset equa
	mov	si, 0
	mov	di, 0
prepare_again:
	mov	dl, [bx]
	inc	bx
	cmp	dl, 0Dh
	jz	prepare_done
	cmp	dl, '0'
	jb	prepare_o
	cmp	dl, '9'
	ja	prepare_o
	mov	polish[si], dl
	inc	si
	jmp	prepare_again
prepare_o:
	mov	po_op[di], dl
	inc	di
	cmp	dl, '('
	jz	prepare_again
	cmp	dl, ')'
	jz	right_k
	cmp	di, 01h
	jz	prepare_again
	push	di
	sub	di, 02h
	mov	al, po_op[di]
	call	compare_ope
	;add	di, 02h
	pop	di
	mov	po_op[di], 0
	mov	ax, com_O
	sub	di, ax
	;inc	di
	sub	di, 01h
	mov	po_op[di], dl
	inc	di
	;sub	di, 01h
	jmp	prepare_again
right_k:
right_again:
	sub	di, 01h
	mov	dl, po_op[di]
	cmp	dl, ')'
	jz	right_again
	cmp	dl, '('
	jz	prepare_again
	mov	polish[si], dl
	mov	po_op[di], 0
	inc	si
	jmp	right_again
prepare_done:
	cmp	di, 0
	jnz	pre_not_empty
prepare_ret:
	mov	polish[si], '$'
	ret
pre_not_empty:
	mov	ax, cntEqua
	sub	ax, 01h
	cmp	ax, si
	jz	prepare_ret
	sub	di, 01h
	mov	dl, po_op[di]
	mov	polish[si], dl
	inc	si
	cmp	di, 0
	jz	prepare_done
	jmp	pre_not_empty

compare_ope:		; ============== Function: compare_ope
			; parameter: al, dl
	push	di
compare_again:
	cmp	dl, '+'
	jz	low_priority
	cmp	dl, '-'
	jz	low_priority
	; dl is * or /
	cmp	dl, '*'
	jz	high_priority
	cmp	dl, '/'
	jz	high_priority
high_priority:
	cmp	al, '*'
	jz	high_output_al
	cmp	al, '/'
	jz	high_output_al
	jmp	compare_done
high_output_al:
	mov	polish[si], al
	inc	si
	mov	po_op[di], 0
	cmp	di, 0
	jz	compare_done
	sub	di, 01h
	;mov	dl, al
	mov	al, po_op[di]
	jmp	compare_again
low_priority:
	cmp	al, '('
	jz	compare_done ; al is + or - or * or / or 0
	cmp	al, 0
	jz	compare_done
	jmp	low_output_al
low_output_al:
	mov	polish[si], al
	inc	si
	mov	po_op[di], 0
	cmp	di, 0
	jz	compare_done
	sub	di, 01h
	;mov	dl, al
	mov	al, po_op[di]
	jmp	compare_again
compare_done:
	pop	ax
	;inc	ax
	sub	ax, di
	mov	com_O, ax
	ret

operation_push:		; ============== Function: operation_push
	mov	bx, offset equa
	mov	si, 0
	mov	cx, offset equa
	mov	dx, offset msg_6
	mov	ah, 09h
	int	21h
op_again:
	mov	dl, [bx]
	cmp	dl, 0Dh
	jz	op_done
	cmp	dl, '0'
	jb	is_operation
	cmp	dl, '9'
	ja	is_operation
	push	bx
	sub	bx, cx
	mov	t_num[bx], dl
	pop	bx
	inc	bx
	jmp	op_again
is_operation:
	mov	s_ope[si], dl
	inc	si
	inc	bx
	push	bx
	call	convert_num
	pop	bx
	push	si
	call	refresh_num
	pop	si
	mov	cx, bx
	jmp	op_again
op_done:
	push	bx
	call	convert_num
	pop	bx
	push	si
	call	refresh_num
	pop	si
	mov	s_ope[si], '$'
	call	new_line
	ret

convert_num:		; ============== Function: convert_num
	mov	ax, 0
	mov	bx, offset t_num
convert_again:
	mov	cl, [bx]
	inc	bx
	cmp	cl, '0'
	jb	convert_done
	cmp	cl, '9'
	ja	convert_done
	sub	cl, '0'
	mov	edx, 0Ah
	mul	edx
	add	eax, ecx
	jmp	convert_again
convert_done:
	mov	number, ax
	ret

refresh_num:		; ============== Function: refresh_num
	mov	si, 0
	push	bx
	mov	bx, 0
refresh_again:
	mov	dl, t_num[si]
	mov	ah, 02h
	cmp	dl, '0'
	jb	refresh_continue
	mov	bx, 09h
	int	21h
refresh_continue:
	mov	t_num[si], 0
	inc	si
	cmp	si, 05h
	jz	refresh_done
	jmp	refresh_again
refresh_done:
	mov	dx, offset msg_b
	mov	ah, 09h
	cmp	bx, 0
	jz	refresh_nonum
	int	21h
	pop	bx
	ret
refresh_nonum:
	pop	bx
	ret

debug_ope:		; ============== Function: debug_ope
	mov	dx, offset msg_5
	mov	ah, 09h
	int	21h
	mov	dx, offset s_ope
	mov	ah, 09h
	int	21h
	call	new_line
	ret

display_equa:		; ============== Function: display_equa
	mov	dx, offset msg_3
	mov	ah, 09h
	int	21h
	mov	bx, offset equa
display_again:
	mov	ah, 02h
	mov	dl, [bx]
	cmp	dl, 0Dh
	jz	display_done
	int	21h
	inc	bx
	jmp	display_again
display_done:
	call	new_line
	ret

delete_space:		; ============== Function: delete_space
	mov	cx, 0
	mov	ax, 0
	mov	cl, buffer[1]
	inc	cl
	mov	si, 0
	mov	bx, offset buffer + 2
delete_again:
	mov	dl, [bx]
	inc	bx
	cmp	dl, ' '
	je	delete_again
	mov	equa[si], dl
	cmp	dl, '('
	je	delete_K
	cmp	dl, ')'
	je	delete_K
	inc	si
	cmp	dl, 0Dh
	je	delete_done
	loop	delete_again
delete_K:
	add	ax, 01h
	inc	si
	cmp	dl, 0Dh
	je	delete_done
	loop	delete_again
delete_done:
	sub	si, ax
	mov	cntEqua, si
	ret

output_string:		; ============== Function: output_string
	mov	cx, 0
	mov	cl, buffer[1]
	jcxz	output_warning
	mov	dx, offset msg_2
	mov	ah, 09h
	int	21h
	mov	dx, 0
	mov	bx, offset buffer + 2
output_again:
	mov	ah, 2
	mov	dl, [bx]
	int	21h
	inc	bx
	cmp	dl, 0Dh
	je	output_done
	loop	output_again
output_done:
	call	new_line
	ret

terminate:		; ============== Function: terminate
	mov	ah, 4Ch
	mov	al, 09h
	int	21h

output_warning:		; ============== Function: output_warning
	mov	dx, offset Er_msg; print error
	mov	ah, 09h
	int	21h
	jmp	terminate

input_string:		; ============== Function: input_string
	mov	dx, offset initmsg
	mov	ah, 09h
	int	21h
	mov	dx, offset msg_1
	mov	ah, 09h
	int	21h
	mov	ah, 0Ah
	mov	dx, offset buffer
	int	21h
	ret

new_line:		; ============== Function: new_line
	mov	ah, 2
	mov	dl, 0Dh
	int	21h
	mov	ah, 2
	mov	dl, 0Ah
	int	21h
	ret

code ends
	end main
