EOF = 065  

data segment 'data' 
    FNAME DB '2.txt',0
    BUFFER DB 0  
    s dw 1024 dup(0)
    num dw 5 dup(0) 
    flag db 0  
    ERROR1 DB 'File not found',07H,0        ;提示信息   
    ERROR2 DB 'Reading error',07H,0
data ends

code segment 'code'
    assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax 
    mov di,0
    mov bp,0
    mov si,0
    mov dx,offset FNAME
    mov ax,3D00H
    int 21H
    jnc open_ok

open_ok:
    mov bx,ax
  
cont:
    call readch
    cmp al,EOF
    jz type   
    cmp al,48 
    jl L1
    cmp al,57
    jg L1
    mov di,1
    push ax
    add bp,1 
    jmp cont

 L1: 
    mov cx,0
    cmp di,1
    jz L2
    mov di,0
    jmp cont

L2:
    cmp bp,0
    jg L3
    add si,2
    mov di,0
    jmp cont

L3: 
    sub bp,1
    pop dx
    sub dx,48    
    mov ax,1 
    push cx 
    push dx
    mov dx,1
    jmp L4

L4: 
    cmp cx,0
    jng L5
    mov dx,10
    mul dx
    sub cx,1
    jmp L4
    
L5: 
    pop dx  
    mul dx
    mov cx,s[si]
    add cx,ax
    mov s[si],cx
    pop cx 
    add cx,1 
    
    jmp L2  
    
    
type:
    cmp flag,0
    jng t1      
    jmp type_ok
t1:
    mov flag,1
    jmp L1
    
   
type_ok:
    mov di,0
    mov bx,0
    sub si,2
    jmp sort

sort:   
    mov bx,di 
    cmp di,si 
    jl L6    
    mov bp,0 
    mov di,0  
   
    jmp play

L6: 
    cmp bx,si
    jnl L8       
    add bx,2   
    mov cx,s[bx]
    cmp s[di],cx
    jg L7
    jmp L6     
L7:
    mov cx,s[di]  
    mov bp,s[bx]
    mov s[di],bp
    mov s[bx],cx 
    jmp L6
    
L8:
    add di,2
    jmp sort    
    
play:   
    mov bx,8
    cmp di,si
    jng p1 
    mov ah,4CH
    int 21H                                 
    
    
p1: 
    
    
    mov ax,s[di]
    mov dx,0 
    mov cx,10  
    div cx
    mov num[bx],dx  
    mov s[di],ax 
    cmp bx,0
    jng p2
    sub bx,2 
    jmp p1

p2: 
    mov bx,0
    jmp p3
    
p3:
    cmp num[bx],0
    jg p4 
    add bx,2
    jmp p3
    
p4:
    cmp bx,8
    jg p5
    mov dx,num[bx]  
    add dl,48    
    mov ah,02H
    int 21H 
    add bx,2  
    jmp p4 
    
 p5:
    mov dl,32
    mov ah,02H
    int 21H
    add di,2
    jmp play
    
    
 
    
READCH        PROC   
                MOV CX,1   
                MOV DX,OFFSET BUFFER                ;置缓冲区地址   
                MOV AH,3FH                                        ;置功能调用号   
                INT 21H                                                ;读   
                JC READCH2                                        ;读出错，转   
                CMP AX,CX                                        ;判文件是否结束   
                MOV AL,EOF                                        ;设文件已经结束,置文件结束符       
        JB READCH1                                        ;文件确已结束，转   
        MOV AL,BUFFER                                ;文件未结束，取所读字符   
READCH1:CLC   
READCH2:RET   
READCH ENDP        
 
code    ends
    end start
