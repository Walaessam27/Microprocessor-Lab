CODE SEGMENT
ASSUME CS:CODE
PA EQU 0FF28H ; PA Data port
PCTL EQU 0FF2BH ; 8255 Command port
RSN EQU 00H ; PC0 bit set/reset mode of 8255 (PC)
RS EQU 01H ;set
RWN EQU 02H ; PC1
RW EQU 03H ;set
EN EQU 04H ; PC2 Enable = 0
E EQU 05H ;;set Enable = 1
CS1N EQU 08H ; PC4
CS1 EQU 09H ;set
CS2N EQU 0Ch ; PC6
CS2 EQU 0Dh ;set
ORG 22E0h
JMP START
YR db ? ; column address
pag db ? ; page address
ZR db 0c0H ; always first row of page (don't change)
val db ? ; value of command or data
START:
; configure 8255
mov dx,0ff2bh
mov al,80h
out dx,al
; initialize LCD (Display ON command) for both halves (call sendComm procedure)
; left half
call selectleft
mov al,03fh
mov val,al
call SendComm
; delay
call DELAY2MS
mov al,03fh
mov val,al
call sendcomm
call DELAY2MS
MAIN:
; select first column and first page
Mov yr,40h
mov pag,0b8h
; select left half of LCD and set cursor
call selectleft
call setCursor
; get offset of character to be displayed and call sendData procedure
; this can be repeated to print an many characters as required
mov si,offset CHARH
call dispComm
mov si,offset CHARE
call dispComm
mov si,offset CHARL
call dispComm
mov si,offset CHARL
call dispComm
mov si,offset CHARO
call dispComm
jmp $ ; stay at current location
; procecure to display a single character (8 columns)
; loop through the columns of the character and call sendData
dispComm:
mov cx,8
l:
mov al,[si]
mov val,al
call senddata
inc si
loop l
RET
; Procedure to send a command to LCD (command value is in variable called val)
SendComm:
mov al, val
mov dx,pa
out dx,al
mov al, rsn
mov dx,pctl
out dx,al
mov al, RWN
mov dx,pctl
out dx,al
mov al, EN
mov dx,pctl
out dx,al
call DELAY2MS
mov al, E
mov dx,pctl
out dx,al
call DELAY2MS
mov al, EN
mov dx,pctl
out dx,al
call DELAY2MS
RET
; Procedure to send a Data (single column) to LCD (data value is in variable called val)
SendData:
mov al, val
mov dx,pa
out dx,al
mov al, rs
mov dx,pctl
out dx,al
mov al, RWN
mov dx,pctl
out dx,al
mov al, EN
mov dx,pctl
out dx,al
call DELAY2MS
mov al, E
mov dx,pctl
out dx,al
call DELAY2MS
mov al, EN
mov dx,pctl
out dx,al
call DELAY2MS
RET
; set cursor of LCD to a certain page line and a certain column.
; LCD half should be already selected
setCursor:
mov al,yr
mov val,al
call sendcomm
mov al,pag
mov val,al
call sendcomm
mov al,zr
mov val,al
call sendcomm
; set column (send YR value as command
; set page (send PAG (x address) value as command)
; set row (send ZR value as command
RET
; enable left half of the LCD (CS1 = 1, CS2 = 0)
SELECTLEFT:
mov al,cs1
mov dx,PCTL
out dx,al
mov al,cs2n
mov dx,PCTL
out dx,al
RET
; enable right half of the LCD (CS1 = 0, CS2 = 1)
SELECTRIGHT:
mov al,cs2
mov dx,PCTL
out dx,al
mov al,cs1n
mov dx,PCTL
out dx,al
RET
DELAY2MS:
push cx
MOV CX,78H
LOOP $ ; current position
pop cx
RET
CharEmpty: DB 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h ; empty block of 8x8 pixels
CHARH: DB 7Fh,8h,8h,8h,7Fh,00h,00h,00h
CHARE: DB 7fh,49h,49h,49h,41h,00h,00h,00h
CHARL: DB 7fh,40h,40h,40h,40h,00h,00h,00h
CHARO: DB 3EH,41H,41H,41H,3EH,00H,00H,00H
CHARFULL: DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; all black
CODE ENDS
END START