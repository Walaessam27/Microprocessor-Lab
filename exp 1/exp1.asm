CODE SEGMENT
ASSUME CS:CODE 
ORG 100H 
START:
mov al , 90H ;Making port A input and port B output.
mov dx , 0FF2Bh ;Moving the data to register with port number 0FF2Bh.
out dx , al ;Put 90h on port number 0FF2Bh (Control word register).
lp: ;Infinite loop to be sure when changing the input at any time, the output appears. 
mov dx , 0FF28H ;The address of port A.
in ax , dx ;Taking the value from the switches (port A). 
mov dx , 0FF29H ;The address of port B.
out dx , ax ;Sending the value in ax to I/o port address in dx (Leds). 
jmp lp ;reading input again and again.
END START
CODE ENDS