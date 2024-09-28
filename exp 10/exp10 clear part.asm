clear part
MOV pag ,0b8h
mov cx,8
lp4:
MOV yr,40h
push cx
mov cx,8
lp3:
mov si,offset charempty
call dispComm
loop lp3
inc pag
pop cx
loop lp4