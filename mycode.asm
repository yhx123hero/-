data segment 'data'
s db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
data ends

code segment 'code'
    assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax
    mov cx,0 
    mov di,0
    
L1:
    cmp cx,6
    jl L2
    jnl L4 
L2:
    cmp di,cx
    jng show
    jg L3
L3:
    inc cx 
    mov di,0
    mov dl,10
    mov ah,02H
    int 21H
    mov dl,13
    mov ah,02H
    int 21H
    jmp L1
L4:
    mov ax,4c00H
    int 21H
L5: 
    mov dl,10
    div dl
    mov bl,ah
    mov dl,al
    add dl,48
    mov ah,02H
    int 21H
    mov dl,bl
    add dl,48
    mov ah,02H
    int 21H
    inc di
    jmp L6
L6:
    mov dl,32
    mov ah,02H
    int 21H
    jmp L2        
show:    
    mov ax,cx
    mov si,6
    mul si
    add ax,di
    mov si,ax 
    mov al,s[si]
    cmp al,10
    jnl L5
    mov dl,al
    add dl,48
    mov ah,02H
    int 21H
    inc di
    jmp L6   
code    ends
    end start