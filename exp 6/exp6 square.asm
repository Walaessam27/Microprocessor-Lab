CODE SEGMENT
ASSUME CS:CODE 
ORG 2000H
START: ; Label for beginning of the program.
L: ; Label for the loop start.
MOV DX, 0FF80H ; Load the DX with the address of the DAC.
MOV AL, 0FFH ; Load the AL register with 0xFF Outing 0ffH to implement the high-level.
OUT DX, AL ; Output AL to the port addressed by DX (DAC).
CALL DEL
MOV DX, 0FF80H ; Again, Load the DX with the address of the DAC.
MOV AL, 0H ; Load the AL register with 0xFF Outing 0ffH to implement the low-level.
OUT DX, AL ; Output AL to the port addressed by DX (DAC).
CALL DEL ; call delay procedure.
JMP L ; Jump back to the start of the loop to repeat.
DEL PROC
PUSH CX ; Save the current value of CX register on the stack.
MOV CX, 0FFFFH ; Load the CX register with 0xFFFF to use as a delay counter.
DEL: NOP ; creating a delay
LOOP DEL ; Decrease CX by 1 and loop back to DEL if CX is not zero.
POP CX ; Restore the value of CX from stack.
RET
END START 
CODE ENDS