; asm homework 2
; Output all ASCII char and hex code
; LI Haodong 3190104890
; 2021.04.03
;-------------------------------------------------------------------------------
data segment
msg1 db 0Dh, 0Ah, '**** ASM HW-2 <3190104890> ****', 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, '$'
msg2 db '**** Output all ASCII char and hex code ****', 0Dh, 0Ah, '$'
creatLines db 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, '$'
msgEnd db 0Dh, 0Ah, 'Press any key to see the ASCII table...$'
creatSevenLines db 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, '$'
indexCol dw 0Bh
indexRow dw 18h
tempAH db 00h
data ends
;-------------------------------------------------------------------------------
code segment
assume cs:code, ds:data
dispInfo:
   mov dx, offset creatLines;creat new lines
   mov ah, 09h
   int 21h
   mov dx, offset msg1; print message 1
   mov ah, 09h
   int 21h
   mov dx, offset msg2; print message 2
   mov ah, 09h
   int 21h
   mov dx, offset creatLines;creat new lines
   mov ah, 09h
   int 21h
   mov dx, offset msgEnd
   mov ah, 09h
   int 21h
   mov ah, 1; input mode
   int 21h; wait for typing
   ret
;-------------------------------------------------------------------------------
refreshScreen:
   mov dx, offset creatLines;creat new lines
   mov ah, 09h
   int 21h
   mov dx, offset creatLines;creat new lines
   mov ah, 09h
   int 21h
   mov dx, offset creatSevenLines;creat new lines
   mov ah, 09h
   int 21h
   ret
;-------------------------------------------------------------------------------
TranAL:
   cmp al, 00h; compare with 0
   jb EndOfTran; if < 0, exit
   cmp al, 0Fh; compare with F
   ja EndOfTran; if > F, exit
   cmp al, 09h; compare with 9
   ja NotDigital; if > 9, not digital
   add al, '0'
   jmp EndOfTran
NotDigital:
   add al, 37h; 37h = 'A' - 0Ah
EndOfTran:
   ret
;-------------------------------------------------------------------------------
DispHex: ; display the hex ASCII code of char
         ; we use div instruction to get the hex
   mov ax, bx; ax = bx
   mov cl, 10h; cl = 16
   div cl; al = ax/cl, ah = ax%cl
   mov tempAH, ah; store ah
   call TranAL; transfer al from ASCII to HEX
   mov ah, 0Ah; black - green
   add di, 02h;
   mov word ptr es:[di], ax
   mov al, tempAH; get ah
   call TranAL
   add di, 02h;
   mov word ptr es:[di], ax
   ret
;-------------------------------------------------------------------------------
DispRow:
   mov indexRow, 19h; number of rows = 19h
DispNext:
   mov ax, bx; bx = ASCII number
   mov ah, 0Ch
   mov word ptr es:[di], ax
   push di; push into stack
   call DispHex
   pop di; pop from stack
   add di, 0A0h; move to next line
   add bx, 1; ASCII code +1
   cmp bx, 0FFh; compare the bx with 255
   jbe Continue
   jmp EndOfDisp; if >= 255, we end displaying
Continue:
   sub indexRow, 1; number of rows -1
   jnz DispNext
   ret
;-------------------------------------------------------------------------------
dispASCII:
   mov ax, 0B800h
   mov es, ax; es = B800
   mov di, 0; position of char
   push di; push into stack
   mov bx, 0; ASCII code
   ; mov word ptr es:[di], ax to display char
NextCol:
   call DispRow
   pop di; pop from stack
   add di, 0Eh; the start position of next column
   push di
   sub indexCol, 1; the number of columns -1
   jnz NextCol
   ret
;-------------------------------------------------------------------------------
main:
   mov ax, data; assign the address of data(s) to ax
   mov ds, ax; assign the address of data to ds
   call dispInfo; display basic information
   call refreshScreen; refresh the screen
   call dispASCII; display ASCII code
EndOfDisp:
   mov ah, 1; input mode
   int 21h; wait for typing
   mov ah, 4Ch
   int 21h
code ends
end main