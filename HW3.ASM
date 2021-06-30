.386
data segment use16
  buf db 7, 0, 7 dup(0);input the number
  s   db 20 dup(0);output the formula
  p   db 40 dup(" "), 0Dh, 0Ah, '$';output the decimal result 
  m   db 40 dup(" "), 0Dh, 0Ah, '$';output the hexadecimal result
  n   db 40 dup(" "), 0Dh, 0Ah, '$';output the binary result
data ends

code segment use16
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   mov si, 0
   call input
   call convert
   push ax
   call newline
   mov s[si],'*'
   inc si
   call input   
   call convert
   mov s[si], '='
   inc si
   mov s[si], '$'
   mov dx, 0
   mov bx, ax
   pop ax
   mul bx;ax is multipled by bx
         ;the result:dx:ax = high 16 digits : low 16 digits
   call output
   call outputdec
   call outputH
   call outputB
   mov ah, 4Ch
   int 21h
;------Convert------------------------------
;Goal: To convert strings to numbers
;Way : Use the multiplication
;Parameter: buf, s
convert:
   mov bx, 2
   mov ax, 0
   mov dx, 0
  next:
   mov dl, buf[bx]
   cmp dl, 0Dh
   je done
   imul ax, ax, 10
   mov s[si], dl
   sub dl, '0'
   add ax, dx
   inc bx
   inc si
   jmp next
  done:
   ret
;------End of Convert----------------------


;------Output------------------------------
output:
   push ax
   push dx
   mov ax, 0
   mov dx, 0
   call newline
   mov dx, offset s
   mov ah, 09h
   int 21h
   pop dx
   pop ax
   ret
;------End of Output-----------------------


;------Outputdec---------------------------
;Goal: To output the decimal result
;Way : Use the division
;Example:  123 -> 123%10 -> 3
;          12  -> 12%10  -> 2    
;          1   -> 1%10   -> 1 
;          stack: 123
outputdec:
   push ax
   push dx
   mov ah, 2
   mov dl, 0Dh
   int 21h
   mov ah, 2
   mov dl, 0Ah
   int 21h
   pop dx
   pop ax
   push ax
   push dx
   xor cx, cx
   xor di, di
again:
   push cx
   mov cx, 10
   call divdw
   pop cx
   add dl, '0'
   push dx
   mov dx, bx
   inc cx
   cmp ax, 0
   jne again
pop_again:
   pop dx
   mov p[di], dl
   inc di
   dec cx
   jnz pop_again
   mov ah, 09h
   mov dx, offset p
   int 21h
   pop dx
   pop ax
   ret
;------End of Outputdec--------------------

;------OutputH-----------------------------
;Goal: To output the hexademical result
;Way : Use the shift
;Example: 7FFFh -> FFF7h And 000Fh -> 7
;         FFF7h -> FF7Fh And 000Fh -> F
;         FF7Fh -> F7FFh And 000Fh -> F
;         F7FFh -> 7FFFh And 000Fh -> F
;         result: 7FFFh
outputH:
   push ax
   push dx
   push ax
   mov ax, dx
   mov cx, 4
   mov bx, 2
   mov di, 0
again1:
   push cx
   mov cl, 4
   rol ax, cl
   push ax
   and ax, 000Fh
   cmp ax, 10
   jb is_digit
is_alpha:
   sub al, 10
   add al, 'A'
   jmp finish_4bits
is_digit:
   add al,'0'
finish_4bits:
   mov n[di], al
   pop ax
   pop cx
   inc di
   dec cx
   jnz again1
   dec bx
   cmp bx, 0
   je next1
   mov cx, 4
   pop ax
   jmp again1
next1:
   mov n[di],'h'
   mov ah, 9
   mov dx, offset n
   int 21h
   pop dx
   pop ax
   ret
;------End of OutputH------------------


;------OutputB-------------------------
;Goal: To output the binary result
;Way : Use the shfit
;Example: 1011B -> 0111B And 0001h -> 1
;         0111B -> 1110B And 0001h -> 0
;         1110B -> 1101B And 0001h -> 1
;         1101B -> 1011B And 0001h -> 1
;         result: 1101B
outputB:
   push ax
   mov ax, dx
   mov cx, 10h
   mov di, 0
   mov bx, 2
   mov si, 4
again2:
   push cx
   mov cl, 1
   rol ax, cl
   push ax
   and ax, 0001h
   add al, '0'
   mov m[di], al
   pop ax
   pop cx
   inc di
   dec si
   cmp si, 0
   jne continue
   inc di
   mov si, 4
 continue:
   dec cx  
   jnz again2
   dec bx
   cmp bx, 0
   je next2
   mov cx, 10h
   pop ax
   jmp again2
next2:
   dec di
   mov m[di], 'B'
   mov ah, 9
   mov dx, offset m
   int 21h
   ret
;------End of OutputB------------------


;------Divdw---------------------------
;Goal: To solve the problem---overflow
;Way : Use the formula
;      X/N=int(H/N)*65535+[rem(H/N)*65535+L]/N
;Parameter :dividend: dx:ax = high 16 digits : low 16 digits
;           divisor : cx
;
;Return    :quotient : bx = high 16 digits ax =  low 16 digits
;          :remainder: dx
divdw:
   push ax
   mov ax, dx
   xor dx, dx
   div cx
   mov bx, ax
   pop ax
   div cx
   ret
;------End of Divdw--------------------


;------Newline-------------------------
;Use int 21h ah=02h
;Output '\n'
newline:
   mov ah, 02h
   mov dl, 0Dh
   int 21h
   mov ah, 02h
   mov dl, 0Ah
   int 21h
   ret
;------End of Newline-------------------


;------Input---------------------------- 
input:
   mov ah, 0Ah
   mov dx, offset buf
   int 21h
   ret
;------End of Input---------------------
code ends
end main