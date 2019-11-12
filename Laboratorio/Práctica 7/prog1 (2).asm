processor 16f877	;Indica la versión del procesador	  
include <p16f877.inc>	;Incluye la libreria de la versión del procesador
         
	valor1 equ h'21'	   
	valor2 equ h'22'	   
	valor3 equ h'23'
	cont equ h'24'
	dato equ h'25'
	cte1 equ 20h
	cte2 equ 50h
	cte3 equ 60h
	
	org 0	;Carga al vector de RESET la dirección de inicio	 
	goto inicio   		   
	org 5	;Dirección de inicio del programa del usuario   

inicio:	bsf STATUS,RP0    ;Cambiamos al banco 1
	    bcf STATUS,RP1
		bsf TXSTA, BRGH
	    clrf TRISB		 ;Configuramos el puerto B como salida
	 	movlw D'32'	
		movwf SPBRG  	;SPBRG=w, velocidad requerida en el data sheet
		bcf TXSTA, SYNC ;Configura el modo asíncrono del registro TXSTA 
		bsf TXSTA, TXEN ;Habilitando la transmisión del registro TXSTA, TXEN=1
		bcf STATUS, RP0	;Regresar al banco 0
		bsf RCSTA, SPEN ;Habilitando el puerto serie SPEN del registro RCSTA, SPEN=1
		bsf RCSTA, CREN	;Habilitando la recepción de datos del registro RCSTA, CREN=1

recibe:		btfss PIR1, RCIF	;Comparar si RCIF es 1
			goto recibe			;Si no, ir a recibe
			movf RCREG, W		;Si es 1: w=RCREG
			movwf dato

ciclo: 	clrf PORTB	;Limpiamos PORTB
	    bcf STATUS, Z	;Ponemos en 0 a la bandera Z
	    movf dato,0          
	    xorlw A'0'	;ASCII que realiza la operación lógica xor entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta al caso 1
	    goto caso1	         		
	    movf dato,0
	    xorlw A'1'	;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta a la subrutina caso2
	    goto caso2	         
	    movf dato,0
	    xorlw A'2'	;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta a la subrutina caso3
	    goto caso3	         
	    movf dato,0
	    xorlw A'3'	;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta a la subrutina caso4
	    goto caso4	         
	    movf dato,0
	    xorlw A'4'	;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta a la subrutina caso5
	    goto caso5	         
	    movf dato,0
	    xorlw A'5'	;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z	;Si z=0 salta a la subrutina caso6
	    goto caso6	 
		goto apagado

apagado:	clrf PORTB
			goto recibir

recibir:	movf RCREG,W	;Si es 1: w=RCREG
			movwf TXREG		;TXREG=w
			bsf STATUS, RP0	;RP0=1
			;goto recibe		;Ir a recibe

transmite:	btfss TXSTA, TRMT	;Comparar TRMT con 1
			goto transmite		;Si no es 1, ir a transmite
			bcf STATUS, RP0		;Si es 1: RP0=0
			goto recibe			;Ir a recibe

caso1:	clrf PORTB		;Limpia el puerto B, leds apagados
	   	goto recibir	;Salta a la subrutina recibir
 
caso2:	movlw h'ff'		;Mueve un 1 al registro W
	   	movwf PORTB		;Mueve el contenido de W a PORTB , enciende leds
	   	goto recibir	;Salta a la subrutina recibir

caso3:	movlw h'07'		;Mueve H’80’ a W
		movwf cont
		movlw h'80'
		movwf PORTB		;Mueve el contenido de W a PORTB, fin de secuencia
		call retardo	;Llama a la subrutina retardo	

ciclo1:	rrf PORTB,1		;Corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo
		decf cont 
		btfsc STATUS,Z	;Cuando se esta en cero estado que nos brinda STATUS
		goto recibir	;Salta a la subrutina recibir
		goto ciclo1		;No se ha llegado a cero, sigue con el ciclo

caso4:	movlw h'07'		;Mueve h'07' a W
		movwf cont
		movlw h'01'
	   	movwf PORTB		;Mueve el contenido de W a PORTB, fin de secuencia
	   	call retardo	;Llama a la subrutina retardo	
	   
ciclo2:	rlf PORTB,1		;Corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo	;Llama a la subrutina retardo	
		decf cont 
		btfsc STATUS,Z      
		goto recibir	;Salta a la subrutina recibir
		goto ciclo2		;No se ha llegado a cero, sigue con el ciclo

caso5:	movlw h'07'		;Mueve h'07' a W
		movwf cont
	    movlw h'80'		;Mueve h’80’ a W
	    movwf PORTB     ;Mueve el contenido de W a PORTB, fin de secuencia
	    call retardo	;Llama a la subrutina retardo	

ciclo3:	rrf PORTB,1   	;Corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo	;Llama a la subrutina retardo	
		decf cont	   
		btfsc STATUS,Z
		goto regreso
		goto ciclo3		;No se ha llegado a cero, sigue con el ciclo

regreso:	movlw h'07'	;Mueve h'07' a W
			movwf cont
			movlw h'01'	;Mueve h'01' a W
			movwf PORTB	;Mueve el contenido de W a PORTB
			call retardo	;Llama a la subrutina retardo

ciclo4:	rlf PORTB,1
		call retardo	;Llama a la subrutina retardo	
		decf cont	   
		btfsc STATUS,Z
		goto recibir	;Salta a la subrutina regreso
		goto ciclo4		;No se ha llegado a cero, sigue con el ciclo

caso6:	movlw h'ff'
		movwf PORTB
	    call retardo		;Llama a la subrutina retardo
		clrf PORTB
		call retardo		;Llama a la subrutina retardo
		goto recibir		;Salta a la subrutina recibir

retardo:	movlw cte1		;Mueve el contenido del cte1 a W 
    		movwf valor1	;Mueve el contenido de w a la dirección de valor1	

tres:	movlw cte2			;Mueve el contenido del cte2 a W
     	movwf valor2		;Mueve el contenido de w a a la dirección de valor2

dos:	movlw cte3			;Mueve el contenido del cte3 a W	
    	movwf valor3 		;Mueve el contenido de w a a la dirección de valor3

uno:	decfsz valor3		;Decrementa a valor3 y escapa a uno cuando llegue a 0 	
	    goto uno			;Salta a la dirección de uno para iniciar de nuevo
	    decfsz valor2		;Decrementa a valor2 y escapa a dos cuando llegue a 0
	    goto dos			;Salta a la direccion de dos para iniciar de nuevo	
	    decfsz valor1		;Decrementa a valor1 y escapa a tres cuando llegue a 0
	    goto tres			;Salta a la direccion de tres para iniciar de nuevo
	    return				;Retorno a la subrutina retardo

end		;Directiva de fin del progtama