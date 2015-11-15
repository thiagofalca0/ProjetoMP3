TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

; TODO: add your data here!!!!

DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
 	PUSH    DS
 	MOV     AX, 0
 	PUSH    AX

; set segment registers:
 	MOV     AX, DSEG
 	MOV     DS, AX
 	MOV     ES, AX

; initialization
	MOV DX, 2070h
	MOV AL, 00h
	OUT DX, AL
	MOV DX, 2080h
	OUT DX, AL	

NEXT:	
	MOV DX, 2080h ; input data from switches
	IN  AX, DX    ; 16-bit input
	
	MOV DX, 2070h ; output data to LEDs
	OUT DX, AL

	JMP NEXT ; infinit loop






; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

