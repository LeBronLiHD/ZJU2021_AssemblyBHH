.386
data segment use16
    inp db 100
       db 0
       db 100 dup(?);存储输入内容
    num db 0;输入的字符数
    pnum dw 0;存储指针指向的位置
    out_item dd 100h dup(0);输出队列
    op_item db 100h dup(0);符号队列
    op db '((+-*/';存储符号优先级
    fetch_num dd 0
    judge_op db 2 dup(0);存储需要判断的两个运算符
    judge_num db 0;
    nout dw 0;
    nopp dw 0;
    pf dw 4 dup(0);
    
    bi db 33 dup(0);存储二进制
    de db 12 dup(0);十进制
    he db 8 dup(0);十六进制
data ends

code segment use16
assume cs:code,ds:data
;--------------------------------
;把字符串转换成数字
fetch_a_num:
    mov ax,0
    ;mov bx,pnum
    again:
        cmp inp[bx],47
        jbe fetch_done;
        cmp inp[bx],58
        jae fetch_done;判断是否是数字
        mov ecx,0
        mov cl,inp[bx]
        sub cl,48;转换为数字
        mov edx,10
        mul edx;乘10
        add eax,ecx
        add bx,1;
        jmp again
fetch_done:
    ;mov pnum,bx
    mov fetch_num,eax
    ret
;----------------------------------
;judeg the priority
is_lower_privilege:
    mov di,0
    mov si,0;
    mov judge_num,0
    cmpa:
        mov al,judge_op[0]
        cmp op[di],al
        je cmpc
        add di,1
        cmp op[di],al;判断符号是否在这个优先级
        je cmp1
        add di,1
        jmp cmpa
    cmp1:
        sub di,1;
    cmpc:
        mov cl,judge_op[1]
        cmp op[si],cl
        je ac_judge
        add si,1
        cmp op[di],cl;判断符号是否在这个优先级
        je cmp2
        add si,1
        jmp cmpc
    cmp2:
        sub si,1;
ac_judge:
    cmp di,si
    jae lower;比前一个优先级低
    jmp judge_done
lower:
    add judge_num,1;返回1
judge_done:    
    ret
;--------------------------------------- 
;transfer into number 
get_op_order:
    mov ebx,0;judge_op[0]存储需要判断的符号
    push ax
    mov al,judge_op[0]
    op_loop:
        cmp op[bx],al
        je get_op_done
        add bx,1
        jmp op_loop
get_op_done:
    sub bx,2
    pop ax;找打符号在数组中存储的位置
    ret  
;-----------------------------------------
;inorder to postorder转化为逆波兰
reverse_polish_notation:
    ;mov bx,pnum;
post_loop:
    mov bx,pnum;bx为当前指针
    mov al,num
    add al,1
    cmp bl,al;判断是否指到末尾
    ja clear
    cmp inp[bx],32;去除空格
    je add_ind;
    cmp inp[bx],48;判断符号还是数字
    jb is_option
    cmp inp[bx],57
    ja is_option
is_number:
    call fetch_a_num
    mov pnum,bx
    mov di,nout
    shl di,2
    add nout,1
    mov out_item[di],eax;数字放入out_item中
    jmp post_loop
is_option:
    cmp inp[bx],40
    je is_kh;括号
    cmp inp[bx],41
    je is_fkh;反括号
    jmp four_option;+-*\
is_kh: 
    mov si,nopp
    add nopp,1
    mov al,inp[bx]
    mov op_item[si],al;将括号放入op_item
    jmp add_ind
is_fkh:
    sub nopp,1
    mov si,nopp
    cmp op_item[si],40
    je add_ind
    mov di,nout
    shl di,2
    add nout,1
    mov al,op_item[si]
    mov judge_op[0],al;将上一个括号与该反括号间符号放入op_item
    call get_op_order
    or ebx,80000000h;符号第一位为1
    mov out_item[di],ebx
    jmp is_fkh
four_option:
    cmp nopp,0
    jle next
    mov si,nopp
    sub si,1
    mov al,op_item[si]
    mov judge_op[0],al
    mov bx,pnum
    mov al,inp[bx]
    mov judge_op[1],al
    call is_lower_privilege;判断优先级
    cmp judge_num,0
    je next
    sub nopp,1
    mov si,nopp
    mov al,op_item[si]
    mov judge_op[0],al
    call get_op_order
    or ebx,80000000h
    mov di,nout
    shl di,2
    add nout,1
    mov out_item[di],ebx;前一个符号优先级高，将其放入out_item中
    jmp four_option
next:
    mov bx,pnum;op_item[i]=op_item[i+1]
    mov al,inp[bx]
    mov si,nopp
    add nopp,1
    mov op_item[si],al
    add pnum,1
    jmp post_loop
add_ind:
   add pnum,1
   jmp post_loop
clear:
    cmp nopp,0;将剩余符号全部放入out_item
    jle post_done
    mov di,nout
    shl di,2
    add  nout,1
    sub nopp,1
    mov si,nopp
    mov al,op_item[si]
    mov judge_op[0],al
    call get_op_order
    or ebx,80000000h;
    mov out_item[di],ebx
    jmp clear
post_done:
    ret
;-------------------------------------------
;add
addd:
    push dx
    add eax,ecx
    pop dx
    ret
;------------------------------------------
subb:
    push dx
    sub eax,ecx
    pop dx
    ret
;--------------------------------------------
mult:
    push dx
    mul ecx
    pop dx
    ret
;--------------------------------------------
divd:
    push dx
    div ecx
    pop dx
    ret
;--------------------------------------------
compute:
    mov ax,offset addd
    mov pf[0],ax
    mov ax,offset subb
    mov pf[2],ax
    mov ax,offset mult
    mov pf[4],ax
    mov ax,offset divd
    mov pf[6],ax;*pf={add,sub,mul,div}
    mov dx,0;dx=i
loop1:
    cmp nout,1;循环直到out_item里只有一个数
    jle com_done
loop2:
    mov di,dx;读到符号
    shl di,2
    mov ebx,out_item[di]
    and ebx,80000000h
    cmp ebx,0
    jne com_next
    add dx,1
    jmp loop2
com_next:
    mov di,dx
    shl di,2
    mov ebx,out_item[di]
    and ebx,7FFFFFFFh;符号
    mov si,dx
    sub si,1
    mov di,si
    shl di,2
    mov ecx,out_item[di];ecx=c
    sub si,1
    mov di,si
    shl di,2
    mov eax,out_item[di];eax=a
    mov di,bx
    shl di,1
    call pf[di];根据符号计算前两个数的结果
    mov di,si
    shl di,2
    mov out_item[di],eax
memcpy:
    mov si,dx;将数组后续内容往前移动两个位置
    sub si,1;si i-1~nout-3
loop3:
    mov bx,nout
    sub bx,3
    cmp si,bx
    jg loop1_next
    mov bx,si
    add bx,2
    mov di,bx
    shl di,2
    mov eax,out_item[di]
    mov di,si
    shl di,2
    mov out_item[di],eax
    add si,1
    jmp loop3
loop1_next:
    sub nout,2
    sub dx,1
    jmp loop1
com_done:
    ret
;------------------------------------------
print_bi:
    mov eax,out_item[0]
    mov bi[32],18;末尾添B
    mov di,31
    push eax
bi_loop1:
    xor edx,edx
    mov ebx,2
    div ebx
    cmp eax,0;edx:eax/ebx=eax...edx
    je output_bi
    mov bi[di],dl
    sub di,1
    jmp bi_loop1
output_bi:
    mov bi[di],dl
    mov di,0
printbi:
    mov dl,bi[di];依次输出bi中字符
    add dl,48
    mov ah,2h
    int 21h
    add di,1
    cmp di,33
    jb printbi
    pop eax
    ret
;-------------------------------------------
print_de:
    push eax
    push ebx
    push edx
    xor edx,edx
    mov ebx,10
    div ebx;edx:eax/ebx=eax...edx
    cmp eax,0
    je output_de
    call print_de;递归
output_de:
    mov ah,2h;输出当前数字
    add dl,48
    int 21h
    pop edx
    pop eax
    pop ebx
    ret
;------------------------------------------
print_hex:
    mov eax,out_item[0]
    mov he[8],56
    mov di,7
    push eax
hex_loop1:
    xor edx,edx
    mov ebx,16
    div ebx;edx:eax/ebx=eax...edx
    cmp eax,0
    je output_hex
    call hex_judge
    mov he[di],dl
    sub di,1
    jmp hex_loop1
output_hex:
    call hex_judge
    mov he[di],dl
    mov di,0
printhex:
    mov ah,2h
    mov dl,he[di]
    add dl,48
    int 21h
    add di,1
    cmp di,9
    jb printhex
    pop eax
    ret
;-------------------------------------------
hex_judge:
    cmp dl,9;将数字转换为16进制表示
    jbe hex_done
    add dl,39
hex_done:
    ret
;-------------------------------------------
main:
    mov ax,data;
    mov ds,ax
input:
    mov ah,0Ah
    mov dx,offset inp
    int 21h;
    mov ah,2
    mov dl,0Dh
    int 21h;
    mov ah,2
    mov dl,0Ah
    int 21h;输入字符串
    xor cx,cx;
    mov cl,inp[1];inp[1]存储字符总个数
    mov num,cl;
    mov pnum,offset inp+2;pnum指向字符串头
input_done:
    call reverse_polish_notation
    call compute
    mov eax,out_item[0]
    call print_de;十进制
    mov ah,2
    mov dl,0Dh
    int 21h;输出回车
    mov ah,2
    mov dl,0Ah
    int 21h;输出换行
    call print_bi;二进制
    mov ah,2
    mov dl,0Dh
    int 21h;输出回车
    mov ah,2
    mov dl,0Ah
    int 21h;输出换行
    call print_hex;十六进制
    mov ah,2
    mov dl,0Dh
    int 21h;输出回车
    mov ah,2
    mov dl,0Ah
    int 21h;输出换行
    mov ah,4Ch
    int 21h;
    

code ends
end main