CODE SEGMENT
ASSUME CS:CODE
ORG 2000H
; CODE INITIALIZATIONS ARE WRITTEN HERE
START:
; YOUR CODE IS WRITTEN HERE


mov dx , 0ff2bh
mov al , 80h
out dx , al

mov dx, 0ff2AH
mov al, 00h
out dx, al

mov dx, 8001H
mov al, 0
out dx, al

mov dx, 8001H
mov al, 32H
out dx, al

mov dx, 8001H
mov al, 0DFH
out dx, al

mov cx, 0FFH
delay:
nop
loop delay

startRead:
              
mov dx, 8001H
mov al, 82h         ;Choose the 7-Segment display (81h)
out dx, al
mov dx, 8000H
mov al, 0ffh        ;print null there
out dx, al                                           


mov cx, 0FH
delay56:
nop
loop delay56

mov bx, 0           ;To read 5 numbers   (Degree 3 + Speed 2)
checkPress:
mov dx, 8001H       
in al, dx
and al, 7H          ;to choose only 3 LSBs (0000 0111)
cmp al, 0
je checkPress       ;if no button was pressed, al register will be 0H, so we jump to check again

lea si, displayValues
add si, bx 
mov dx, 8001H
mov al, [si]         ;Choose the 7-Segment display [display + bx]
out dx, al 
 
mov dx, 8000H       
in  al, dx

mov cx, 10
lea si, keys        ;SI will hold keys offset

checkButton:   
push cx

and al, 3FH         ;We use mask to ignore the 2 MSBs
cmp al, [si]
jne ignoreDisplay   ;if the entered key isn't equals to the SI we ignore the value's display

push bx             ;because bx is saving checkPress's counter value 
                                                            
mov dx, 10
sub dx, cx                                          
push dx
          
lea bx, values      ;BX will hold values offset
add bx, dx  
mov dx, 8000H
mov al, [bx]        ;if we reached here then we display the value stored in [BX]
out dx, al

pop dx          
pop cx              ;to get the value saved in bx back to cx         
lea bx, enteredValue;BX will hold enteredValue offset
add bx, cx
mov [bx], dl        ;save the value stored in dx 0-9

mov bx, cx
inc bx
cmp bx, 5
je startMotorMain

ignoreDisplay:
inc si              ;mov SI to the next array's Offset
pop cx
loop checkButton    ;to loop on checkButton 10 times
          
jmp checkPress      ;always jmp back to checkPress

startMotorMain:

mov cx, 3
lea si, enteredValue
mov bx, 0
mov ax, 0
storingDegree:   
    mov bl, [si]
    mov dx, 10
    mul dx
    
    add ax, bx
    inc si
loop storingDegree

push ax            ;store ax (degree value)
         
mov cx, 2
mov ax, 0
storingSpeed:
    mov bl, [si]
    mov dx, 10
    mul dx
    
    add ax, bx
    inc si
loop storingSpeed                      

mov cx, ax
mov dx, 0
mov ax, 0ffffh
div cx
mov cx, ax

mov bl , 11h

pop ax 

lea si, speed
mov [si], cx

lea si , oldDegree
mov dx, [si]
lea si , oldDegree
mov [si], ax
cmp ax, dx
ja  right

left:    
sub dx ,ax
mov ax, dx
mov dx, 0
mov cx, 10
mul cx
mov cx, 7
div cx                                                                 
mov cx ,ax ;to get the quotient to cx (Number of steps we need to move)

left2: 
push cx
rol bl ,1
mov al , bl
mov dx , 0ff28h
out dx ,al
lea si , speed
mov cx , [si]
delay2:
nop
loop delay2
pop cx
loop left2

jmp startRead


right:
sub ax, dx
mov dx, 0
mov cx, 10
mul cx
mov cx, 7
div cx                                                                 
mov cx ,ax ;to get the quotient to cx (Number of steps we need to move)

right2:   
push cx
ror bl ,1
mov al , bl
mov dx , 0ff28h
out dx ,al
lea si , speed
mov cx , [si]
delay3:
nop
loop delay3
pop cx
loop right2

jmp startRead

keys db 09H, 1H, 11h, 21h, 8h, 18h, 28h, 0h, 10h, 20h
values db 0ch, 9fh, 4ah, 0bh, 99h, 29h, 28h, 8fh, 8h, 9h
displayValues db 85h,84h, 83h, 82h, 81h
enteredValue db 0,0,0,0,0
oldDegree    dw 0
speed        dw 0

END START
CODE ENDS