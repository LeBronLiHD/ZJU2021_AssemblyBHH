; BASIC ASM Hw 1
; LI Haodong
; 3190104890
;-------------------------------------------------------------------------------
data segment
s db 100 dup(0); store the input string
t db 100 dup(0); depulicate 100 '\0', an empty string
data ends
;-------------------------------------------------------------------------------
code segment
assume cs:code, ds:data
main:
   mov ax, data; assign the address of data(s) to ax
               ; or: mav, ax s
   mov ds, ax; assign the address of data to ds
   mov si, 0; the subscript of INPUT array
inputContinue:
   mov ah, 1; 01h for input
   int 21h; al = getchar() API
   cmp al, 0Dh; judge if it is a enter char
   je inputEnd; if equal, end input process
   mov s[si], al; store the input char to string s
   add si, 1; subscript ++
   jmp inputContinue
inputEnd:
   mov s[si], 0;mark the end of a string
;-------------------------------------------------------------------------------
; now we finish the inputing string, we start transfer s to t
   mov bx, offset s; get the address of s
   mov di, 0; the subscript of string t
   mov si, 0; the subscript of string s
TranNext:
   mov dl, [bx+si]
   add si, 1; subscript ++
   cmp dl, 0; judge if it is the end of string
   je TranEnd
   cmp dl, 20h; judge if it is a blankspace char
   je TranNext; if equal, we delete the char
   cmp dl, 61h; compare the input char with 'a'
   jb TranSkip; if the ASCII code less than 'a'
   cmp dl, 7Ah; compare the input char with 'z'
   ja TranSkip; if the ASCII code higher than 'z'
   sub dl, 20h; transfer from lowercase to uppercase
TranSkip:
   mov t[di], dl; store the input char to string t
   add di, 1; subscript ++
   jmp TranNext
TranEnd:
   mov t[di], 0; mark the end of string t
   mov ah, 2; 02h for output
   mov dl, 0Dh; give the ASCII code of enter to dl
   int 21h; output enter char
;-------------------------------------------------------------------------------
; and then we start output string t
   mov ah, 2
   mov dl, 0Ah
   int 21h; creat a new line
   mov bx, offset t;get the address of t
   mov di, 0; the subscript of the string to print
outputContinue:
   mov dl, [bx+di]
   cmp dl, 0; if the current char is the end of array
   je outputEnd
   mov ah, 2
   int 21h; output the string store in DL
   add di, 1
   jmp outputContinue
outputEnd:
   mov ah, 4Ch; creat a new line
   int 21h
code ends
end main