CODE SEGMENT 
ASSUME CS:CODE 
ORG 2000H 
START: ; Label OF the beginning.
L: ; Label for the loop start
MOV SI, OFFSET ANG ; Load SI with the offset address of the ANG array (where sine values are stored)
MOV DX, 0FF80H ; Load DX with the DAC port address 0FF80h.
MOV CX, 36 ; Initialize CX register with 36, the count of values to send to the DAC.
LBL: ; Label for the inner loop.
MOV AL, [SI] ; Move the sine value pointed by SI into AL
OUT DX, AL ; Output the value in AL to the DAC port (DX)
INC SI ; Increment SI to point to the next value angles.
LOOP LBL ; Decrement CX and loop back to LBL if CX is not zero.
JMP L ; Jump to make Infinite loop.
; storing sine wave values, these values are calculated by 127 + 127 * sin(angle in radians)
; Angles increase by 10 degrees from 0 to 350 (36 points)
ANG DB
127,149,170,190,208,224,236,246,252,254,252,254,252,246,236,224,208,190,170,149,127,104,83,63,45,29,17
,7,1,0,1,7,17,29,45,63,83,104,127
END START 
CODE ENDS