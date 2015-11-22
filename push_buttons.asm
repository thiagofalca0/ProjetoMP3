DSEG    SEGMENT 'DATA'

msg1:    db      "PLAY!", 0Dh,0Ah, 24h
msg2:    db      "PAUSE!", 0Dh,0Ah, 24h
msg3:    db      "STOP!", 0Dh,0Ah, 24h
msg4:    db      "UP!", 0Dh,0Ah, 24h
msg5:    db      "DOWN!", 0Dh,0Ah, 24h

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
	MOV DX, 2040h
	MOV AL, 00h
	OUT DX, AL
	MOV DX, 2080h
	OUT DX, AL	

NEXT:	
	MOV DX, 2080h ; input data entrada dos buttons
	IN  AX, DX    ; 16-bit input
	
	CMP AL,02
	JE  PLAY
	
	CMP AL,02
	JE  PAUSE
	
	CMP AL,04
	JE  STOP
	
	CMP AL,01
	JE  UP
	
	CMP AH,01
	JE  DOWN
	
	
	MOV DX, 2040h ; output data / saida para ASCII LCD display
	OUT DX, AL

	JMP NEXT ; infinit loop


; return to operating system:
    RET
START   ENDP



PLAY PROC
    
        mov     dx, msg1  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....  
    RET          
PLAY ENDP 

PAUSE PROC
    
        mov     dx, msg2  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....  
    RET          
PAUSE ENDP 

STOP PROC
    
        mov     dx, msg3  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....  
    RET          
STOP ENDP

UP PROC
    
        mov     dx, msg4  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....  
    RET          
UP ENDP 

DOWN PROC
    
        mov     dx, msg5  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....  
    RET          
DOWN ENDP 
         

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

