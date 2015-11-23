;Carlos Duarte 15/11/2015
;cebduarte@gmail.com
;---
;Thiago Falcao 19/11/2015
;falcaofono@gmail.com
;---
;Rogerio Peixoto 21/11/2015
;rcbpeixoto@gmail.com
.stack
.data                     
  
  mp3_1 DB "1:get luck      $" 
  mp3_2 DB "2:lean on       $"
  mp3_3 DB "3:sadeness      $" 
  mp3_4 DB "4:orinoco flow  $" 
  mp3_5 DB "5:seven nation a$"
  mp3_6 DB "6:vapor barato  $" 
  mp3_7 DB "7:estacao da luz$" 
  mp3_8 DB "8:moreninha lind$"
  mp3_9 DB "9:baiao de dois $" 
  mp3_10 DB "10: cristal queb$" 
  
  mp3_runn_msg DB "Tocando         $" 
  mp3_stop_msg DB "Parado          $"  
  mp3_pause_msg DB "Pausado         $"
  mp3_play_msg DB "0:00            $" 
  mp3_play_clean DB "                $"
    
.code
main:
    
  MOV AX, @data
  MOV DS, AX
  MOV ES, AX    
  
  ;core program
  
  MOV BX, 1 ;musica inicial
  
  MOV AL, 0 ;acumulador da duracao  
  MOV AH, 0 ;minuto
  MOV CL, 0 ;segundo 1
  MOV CH, 0 ;segundo 2
  
  CALL MP3_STOP
                                    
  mp3_play_run:            
    
    PUSH AX
    
    MOV DX, 2080h ;input data = entrada dos buttons
    IN  AX, DX    ;16-bit input
    
    ;0 - up
    ;8 - down
    ;1 - play/pause
    ;2 - stop   
    
    CMP AL, 0
    JE mp3_play_checkAH
    
    CMP AL, 1
    JE mp3_play_up
    
    CMP AL, 2
    JE mp3_play_play
    
    CMP AL, 4
    JE mp3_play_down

    mp3_play_checkAH:
    
    CMP AH, 1
    JE mp3_play_stop
    
    POP AX
    
    CMP AL, 0
    JE mp3_play_continue_nopause
    
    PUSH BX
    MOV BX, OFFSET mp3_pause_msg    ;offset da string para escrita no lcd
    CALL LCD_OUTPUT_LINE2
    POP BX
    
    mp3_play_continue_nopause:
        
    CALL MP3_SHOW
    
    JMP mp3_play_continue
    
    ;---
     
    mp3_play_up:
    
    POP AX
    
    MOV AX, 0
    MOV CX, 0
    
    CMP BX, 1
    JLE mp3_play_setBX11
    
    SUB BX, 1    
    CALL MP3_SHOW
      
    JMP mp3_play_continue
    
    ;---
    
    mp3_play_play:      
    
    POP AX
    
    CMP CH, 9
    JL mp3_play_incCH
    MOV CH, -1                  
    INC CL ;segundo 1
    mp3_play_incCH:   
    INC CH ;segundo 2   
    
    CMP CL, 6
    JL mp3_play_pasCL
    MOV CL, 0
    INC AH ;minuto  
    mp3_play_pasCL:
    
    CALL MP3_DURATION                          
    INC AL
        
    CMP AL, 7 ;duracao da musica
    JL mp3_play_continue
    
    CMP BX, 10
    JL mp3_play_down_auto
    
    MOV BX, 0
    JMP mp3_play_down_auto
    
    ;---
    
    mp3_play_down:
    
    POP AX
        
    CMP BX, 10
    JGE mp3_play_setBX0           
    
    mp3_play_down_auto:
    
    MOV AX, 0
    MOV CX, 0
    
    ADD BX, 1    
    CALL MP3_SHOW
      
    JMP mp3_play_continue 
      
    ;---
    
    mp3_play_stop:
    
    POP AX
    
    MOV AX, 0
    MOV CX, 0
        
    CALL MP3_STOP
    
    JMP mp3_play_continue       
    
    mp3_play_setBX11:
      
      MOV BX, 11
      JMP mp3_play_continue
      
    mp3_play_setBX0:
      
      MOV BX, 0
      JMP mp3_play_continue        
          
    mp3_play_continue:               
       
  JMP mp3_play_run  
                          
  ;exit
  
  MOV AX, 4c00h 
  INT 21h     
  
  ;region procedures   
   
  MP3_SHOW PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX       
    
    CALL MP3_SELECTOR
    CALL LCD_OUTPUT_LINE1                                                       
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
  
    RET  
    
  ENDP 
               
  MP3_STOP PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX
       
    MOV BX, OFFSET mp3_stop_msg    ;offset da string para escrita no lcd
    CALL LCD_OUTPUT_LINE2    
    
    MOV BX, OFFSET mp3_play_clean    ;offset da string para escrita no lcd
    CALL LCD_OUTPUT_LINE3
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
  
    RET  
    
  ENDP     
  
  MP3_DURATION PROC
        
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV DI, OFFSET mp3_play_msg             
    CLD 
    
    PUSH AX 
    
    ADD AH, 48   
    MOV AL, AH
    STOSB   
    
    MOV AL, ':'
    STOSB   
    
    ADD CL, 48   
    MOV AL, CL
    STOSB   
        
    ADD CH, 48   
    MOV AL, CH
    STOSB   
    
    POP AX   
    
    PUSH BX    
    
    MOV BX, OFFSET mp3_runn_msg
    CALL LCD_OUTPUT_LINE2      
    
    MOV BX, OFFSET mp3_play_msg
    CALL LCD_OUTPUT_LINE3      
    
    POP BX

    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
  
    RET  
    
  ENDP
           
  LCD_OUTPUT_LINE1 PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX           
              
    MOV DX, 2040h           ;define a posicao do primeiro caracter do lcd             
    CALL LCD_OUTPUT_WRITE
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
      
    RET
      
  ENDP              
      
  LCD_OUTPUT_LINE2 PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX       
              
    MOV DX, 2050h           ;define a posicao do primeiro caracter do lcd             
    CALL LCD_OUTPUT_WRITE
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
      
    RET
      
  ENDP    
  
  LCD_OUTPUT_LINE3 PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX     
              
    MOV DX, 2060h           ;define a posicao do primeiro caracter do lcd             
    CALL LCD_OUTPUT_WRITE
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
      
    RET
      
  ENDP               
           
  LCD_OUTPUT_WRITE PROC
                
    
    LBL_LCD_WRITING:       
                            
      MOV AL, [BX]          ;obtem o caracter informado para escrita no lcd      
      CMP AL, '$'           ;se for $ acabou a string para escrita
      JE LBL_LCD_WRITED
      
      OUT DX, AL            ;output do lcd
      INC BX                ;pula para proximo caracter da string para escrita
      INC DX                ;define a proxima posicao de caracter no lcd
      
      CMP AL, '$'           ;se nao for $ tem mais caracter para escrita
      JNE LBL_LCD_WRITING                 
      
    
    LBL_LCD_WRITED:
       
      
    RET
      
  ENDP  
    
  MP3_SELECTOR PROC
 
    ;LIFO dos registradores para uso do chamador (empilha)
 
    PUSH AX                         
    PUSH CX
    PUSH DX           
 
    CMP BX,1
    JE mp3_1_offset
 
    CMP BX, 2 
    JE mp3_2_offset
 
    CMP BX, 3 
    JE mp3_3_offset
 
    CMP BX, 4 
    JE mp3_4_offset
 
    CMP BX, 5 
    JE mp3_5_offset
 
    CMP BX, 6 
    JE mp3_6_offset
 
    CMP BX, 7 
    JE mp3_7_offset
 
    CMP BX, 8 
    JE mp3_8_offset
 
    CMP BX, 9 
    JE mp3_9_offset
 
    CMP BX, 10 
    JE mp3_10_offset
     
    mp3_1_offset:
    MOV BX, offset mp3_1
    JMP exit_mp3_selector
    
    mp3_2_offset:
    MOV BX, offset mp3_2
    JMP exit_mp3_selector
    
    mp3_3_offset:
    MOV BX, offset mp3_3
    JMP exit_mp3_selector
    
    mp3_4_offset:
    MOV BX, offset mp3_4
    JMP exit_mp3_selector
    
    mp3_5_offset:
    MOV BX, offset mp3_5
    JMP exit_mp3_selector
    
    mp3_6_offset:
    MOV BX, offset mp3_6
    JMP exit_mp3_selector
    
    mp3_7_offset:
    MOV BX, offset mp3_7
    JMP exit_mp3_selector
    
    mp3_8_offset:
    MOV BX, offset mp3_8
    JMP exit_mp3_selector
    
    mp3_9_offset:
    MOV BX, offset mp3_9
    JMP exit_mp3_selector
    
    mp3_10_offset:
    MOV BX, offset mp3_10         
    
    exit_mp3_selector: 
    
    ;LIFO dos registradores para uso do chamador (desempilha)
 
    POP DX
    POP CX   
    POP AX
    
    RET
 
  ENDP           
            
END main      