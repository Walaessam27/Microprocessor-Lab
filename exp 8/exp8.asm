CODE SEGMENT 
ASSUME CS:CODE
ORG 2000H 
 
START:
MOV DX, 0FF2BH ;Moving the data to register with port number 0FF2Bh.
MOV AL, 90H ;Making port A input and port B output.
OUT DX, AL ;Put 90h on port number 0FF2Bh (Control word register).
MOV BL, 0 ; Initialize BL register to 0 to initialize the speed.
MOV AL, BL ; Move the value of BL (motor speed control value) into AL.
MOV DX, 0FF80H ; Load DX with the DAC's port address.
OUT DX, AL ; Output the initial speed control value to the DAC, the speed = 0.
LBL:
CALL DELA ; Call the delay.
MOV DX, 0FF28H ; Load DX with the input port A address (where push buttons are connected).
IN AL, DX ; Read the state of the buttons into AL.
PUSH BX ; Save BX on the stack to use it temporarily.
MOV BL, AL ; Move the buttons' state into BL for processing.
OR AL, 7FH ; Set the MSB of AL to 0, making sure we compare only relevant bits.
CMP AL, 7FH ; Compare AL to 7FH to check if the increase button is pressed.
JE INCREASE ; If yes, jump to INCREASE label.
MOV AL, BL ; Move the original buttons' state back into AL.
OR AL, 0BFH ; Set bit 6 to 0, leaving other bits unchanged for comparison.
CMP AL, 0BFH ; Compare AL to 0BFH to check if the decrease button is pressed.
JE DECREASE ; If yes, jump to DECREASE label.
JMP LBL ; If no buttons are pressed, jump back to LBL and repeat the loop
INCREASE:
POP BX ; Restore the original BX value.
CMP BL, 250 ; Check if the speed is at the maximum allowed value.
JE LBL ; If yes, just loop back without increasing speed.
ADD BL, 10 ; Otherwise, increase the speed by 10.
MOV AL, BL ; Move the new speed value into AL.
MOV DX, 0FF80H ; DAC's port address.
OUT DX, AL ; Output the new speed to the DAC.
JMP LBL ; Jump back to the main loop.
DECREASE:
POP BX ; Restore the original BX value.
CMP BL, 0 ; Check if the speed is already = 0.
JE LBL ; If yes, loop back without decreasing speed.
SUB BL, 10 ; Otherwise, decrease the speed by 10.
MOV AL, BL ; Move the new speed value into AL.
MOV DX, 0FF80H ; DAC's port address
OUT DX, AL ; Output the new speed to the DAC.
JMP LBL ; Jump back to the main loop.
DELA:
PUSH CX ; Save CX on the stack.
MOV CX, 0FFFH ; Load CX with a count for a delay.
L1: NOP ; Just a delay.
LOOP L1 ; Decrease CX by 1 and loop.
POP CX ; Restore the original value of CX.
RET 
END START
CODE ENDS 