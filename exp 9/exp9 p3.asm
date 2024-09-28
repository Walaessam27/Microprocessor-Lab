CODE SEGMENT
ASSUME CS:CODE
ORG 1000H
START: MOV DX,0FF2BH
MOV AL,82H ;Configure 8255: Port A = output, Port B = input, Port C = not used.
OUT DX,AL ;Send configuration to 8255 control register.
MOV BL,0EEH ;load Initial pattern.
LP1: MOV DX,0FF29H ;Load address of Port B (input port) into DX.
IN AL,DX ;Read the state of Port B into AL.
AND AL,00000110B ;Mask for keeping only bits corresponding to buttons.
CMP AL,02H ;Check if btn1 is pressed (expecting 00000010B).
JE ST ;If btn1 is pressed, jump to code block for 360° clockwise rotation.
CMP AL,04H ;Check if btn2 is pressed (expecting 00000100B).
JE ST1 ;If btn2 is pressed, jump to code block for 90° clockwise rotation.
JMP LP1 ; ;If nothing is pressed, loop back and check again.
ST: MOV CX,2048 ; 360° ➔ 2048 step.
LPP: ROR BL,1 ;Rotate in BL to the right, for clockwise movement.
MOV AL,BL ;Move BL into AL for output.
MOV DX,0FF28H ;Load address of Port A (output port) into DX.
OUT DX,AL
PUSH CX
MOV CX,0FFFH ;Short delay loop count.
DELL: NOP ;Delay loop No Operation.
LOOP DELL
POP CX
LOOP LPP ;Repeat rotation steps until full rotation is achieved.
JMP LP1 ;Return to check the buttons again.
ST1: MOV CX,512 ;360° ➔ 2048 step so 90° ➔ 512 step.
LPP1: ROL BL,1 ;Rotate in BL to the left, for counterclockwise movement.
MOV AL,BL ;Move BL into AL for output.
MOV DX,0FF28H ;Load address of Port A (output port) into DX.
OUT DX,AL
PUSH CX
MOV CX,0FFFH ;Short delay loop count.
DELL2: NOP ;Delay loop No Operation.
LOOP DELL2
POP CX
LOOP LPP1 ;Repeat rotation steps until 90° rotation is achieved.
JMP LP1 ;Return to check the buttons again.
MOTH DB 0EH, 0CH, 0DH, 09H, 0BH, 03H, 07H, 06H ; for half step
MOTF DB 0EH, 0DH, 0BH, 07H ; for full step
END START 
CODE ENDS