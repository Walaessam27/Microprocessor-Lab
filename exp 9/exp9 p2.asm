CODE SEGMENT
ASSUME CS:CODE
ORG 2000H
START:
MOV DX, 0FF2BH ;Moving the data to register with port number 0FF2Bh.
MOV AL ,80H ;Making port A & port B output.
OUT DX, AL ;Put 80h on port number 0FF2Bh (Control word register).
L:
MOV SI,OFFSET ARRAY ; Loads the offset address of the ARRAY into SI.
MOV CX, 8 ;represent the number of steps in a half step sequence.
MAIN:
MOV DX, 0FF28H ;The address of port A.
MOV AL,[SI]
OUT DX,AL ; Sends the step value to the motor control port, to move the stepper motor.
PUSH CX
MOV CX ,0FFFH ;Set up a delay counter.
DEL: NOP ;no operation loop to make delay 
LOOP DEL
POP CX
INC SI ;Increments SI to point to the next step value in the ARRAY.
LOOP MAIN 
JMP L
ARRAY DB 0EH, 0CH, 0DH, 09H, 0BH, 03H, 07H, 06H ; An array for the half sequence for the stepper motor.
END START
CODE ENDS
