CODE SEGMENT
ASSUME CS:CODE
ORG 2000H
START:
MOV DX, 0FF2BH ;Moving the data to register with port number 0FF2Bh.
MOV AL ,80H ;Making port A & port B output.
OUT DX, AL ;Put 80h on port number 0FF2Bh (Control word register).
MOV BL,0EEH ; Load BL with the initial value for port A
MAIN:
MOV DX, 0FF28H ;The address of port A.
MOV AL,BL
OUT DX,AL ; Output the content of AL (the control pattern) to the port addressed by DX (port A).
PUSH CX ;Save the current value of CX register onto the stack.
MOV CX ,0FFFH ;set the time of delay.
DEL: NOP ;make a delay to let the stepper motor work. 
LOOP DEL
POP CX
ROL BL,1 ;Rotate the bits in BL left by 1 bit. This changes are to rotate the stepper motor by one step.
JMP MAIN ;Jump back to the MAIN label to continuously rotate the stepper motor.
END START
CODE ENDS
