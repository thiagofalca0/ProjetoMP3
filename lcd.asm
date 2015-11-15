;carlos duarte 15/11/2015
;cebduarte@gmail.com
.stack
.data  
  mp3_1 DB "Musica 1 oia$"
  mp3_2 DB "Musica 2 upa$"
  mp3_3 DB "Musica 3 eita$"   
.code
main:
    
  MOV AX, @data
  MOV DS, AX       
  
  ;core program
    
  MOV BX, OFFSET mp3_3       ;offset da string para escrita no lcd
  CALL LCD_OUTPUT            ;chamada para escrita no lcd         
                      
  ;exit to operating system
  
  MOV AX, 4c00h 
  INT 21h     
  
  ;#region procedures
  
  LCD_OUTPUT PROC
    
    ;LIFO dos registradores para uso do chamador (empilha)
    
    PUSH AX                         
    PUSH BX
    PUSH CX
    PUSH DX           
              
    MOV DX, 2040h           ;define a posicao do primeiro caracter do lcd             
    
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
    
    
    ;LIFO dos registradores para uso do chamador (desempilha)
    
    POP DX
    POP CX
    POP BX   
    POP AX
      
    RET
      
  ENDP
      
  ;#endregion    
            
END main      