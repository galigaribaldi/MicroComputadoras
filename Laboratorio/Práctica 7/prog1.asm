processor 16f877   	  
include <p16f877.inc> 
         
	valor1 equ h'21'	   
	valor2 equ h'22'	   
	valor3 equ h'23'
	cont equ h'24'
	dato equ h'25
	cte1 equ 20h
	cte2 equ 50h
	cte3 equ 60h
	   
	org 0   		     	 
	goto inicio   		   
	org 5   			   

inicio:	bsf STATUS,RP0    ;Cambiamos al banco 1
	    bcf STATUS,RP1
	    clrf TRISB		 ;Configuramos el puerto B como salida
	 	movlw D'129'
		movwf SPBRG  	;SPBRG=w, velocidad requerida en el data sheet
		bcf TXSTA, SYNC ;Configura el modo asíncrono del registro TXSTA 
		bsf TXSTA, TXEN ;Habilitando la transmisión del registro TXSTA, TXEN=1
		bcf STATUS, RP0	;Regresar al banco 0
		bsf RCSTA, SPEN ;Habilitando el puerto serie SPEN del registro RCSTA, SPEN=1
		bsf RCSTA, CREN	;Habilitando la recepción de datos del registro RCSTA, CREN=1

recibe:		btfss PIR1, RCIF	;Comparar si RCIF es 1
			goto recibe	;Si no ir a recibe
			movf RCREG, w	;Si es 1: w=RCREG
			movwf dato

ciclo: 	clrf PORTB          ;Limpiamos PORTB
	    bcf STATUS, Z    ;Ponemos a 0 a la bandera Z
	    movf dato,0          
	    xorlw A'0'              ;ASCII que realiza la operación lógica xor entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos al caso 1
	    goto caso1	         		
	    movf dato,0
	    xorlw A'1'              ;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos a la subrutina caso2
	    goto caso2	         
	    movf dato,0
	    xorlw A'2'              ;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos a la subrutina caso3
	    goto caso3	         
	    movf dato,0
	    xorlw A'3'              ;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos a la subrutina caso4
	    goto caso4	         
	    movf dato,0
	    xorlw A'4'              ;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos a la subrutina caso5
	    goto caso5	         
	    movf dato,0
	    xorlw A'5'              ;ASCII que realiza la operación lógica entre la entrada del teclado y w
	    btfsc STATUS,Z   ;si z=0 saltamos a la subrutina caso6
	    goto caso6	 
		goto apagado

apagado:	clrf PORTB
			goto recibir

recibir:	movf RCREG,W
			movwf TXREG
			bsf STATUS, RP0
			goto recibe

transmite:	btfss TXSTA, TRMT	;Comparar TRMT con 1
			goto transmite	;Si no es 1, ir a transmite
			bcf STATUS, RP0	;Si es 1: RP0=0
			goto recibe	;Ir a recibe

caso1:	clrf PORTB        ;limpia el puerto B, LED’S apagados
	   	goto recibir	;Saltamos a la subrutina recibir
 
caso2:	movlw h'ff'       ;Movemos un 1 al registro W
	   	movwf PORTB  ; Movemos el contenido de W a PORTB , enciende LED’S
	   	goto recibir	;Saltamos a la subrutina recibir

caso3:	movlw h'07'             ;Movemos H’80’ a W
		movwf cont
		movlw h'80'
		movwf PORTB        ;Movemos el contenido de W a PORTB, fin de secuencia
		call retardo		;Llamamos a la subrutina retardo	

ciclo1:	rrf PORTB,1   	;corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo
		decf cont 
		btfsc STATUS,Z      ;  cuando se esta en cero estado que nos brinda STATUS
		goto recibir	;Saltamos a la subrutina recibir
		goto ciclo1       ;no hemos llegado a cero, seguimos con el ciclo

caso4:	movlw h'07'             ;Movemos h'07' a W
		movwf cont
		movlw h'01'
	   	movwf PORTB        ;Movemos el contenido de W a PORTB, fin de secuencia
	   	call retardo		;Llamamos a la subrutina retardo	
	   
ciclo2:	rlf PORTB,1	;corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo		;Llamamos a la subrutina retardo	
		decf cont 
		btfsc STATUS,Z      
		goto recibir	;Saltamos a la subrutina recibir
		goto ciclo2      ;no hemos llegado a cero, seguimos con el ciclo

caso5:	movlw h'07'
		movwf cont
	    movlw h'80'             ;Movemos h’80’ a W
	    movwf PORTB        ;Movemos el contenido de W a PORTB, fin de secuencia
	    call retardo		;Llamamos a la subrutina retardo	

ciclo3:	rrf PORTB,1   	;corrimiento hacia la derecha de bits de 1 en 1 sobre el puerto B
		call retardo		;Llamamos a la subrutina retardo	
		decf cont	   
		btfsc STATUS,Z
		goto regreso
		goto ciclo3	;no hemos llegado a cero, seguimos con el ciclo

regreso:	movlw h'07'
			movwf cont
			movlw h'01'
			movwf PORTB
			call retardo

ciclo4:	rlf PORTB,1
		call retardo		;Llamamos a la subrutina retardo	
		decf cont	   
		btfsc STATUS,Z
		goto regreso
		goto ciclo4	;no hemos llegado a cero, seguimos con el ciclo

caso6:	movlw h'ff'
		movwf PORTB
	    call retardo		;Llamamos a la subrutina retardo
		clrf PORTB
		call retardo
		goto recibir

retardo:	movlw cte1        ;Movemos el contenido del cte1 a W 
    		movwf valor1	  ;Movemos el contenido de w a la dirección de valor1	

tres:	movlw cte2		  ;Movemos el contenido del cte2 a W
     	movwf valor2	  ;Movemos el contenido de w a a la dirección de valor2

dos:	movlw cte3		  ;Movemos el contenido del cte3 a W	
    	movwf valor3            ;Movemos el contenido de w a a la dirección de valor3

uno:	decfsz valor3	 ;Decrementamos a valor3 y escapa a uno cuando llegue a 0 	
	    goto uno		 ;saltamos a la dirección de uno para iniciar de nuevo
	    decfsz valor2	 ;Decrementamos a valor2 y escapa a dos cuando llegue a 0
	    goto dos		 ;Saltamos a la direccion de dos para iniciar de nuevo	
	    decfsz valor1	 ;decrementa a valor1 y escapa a tres cuando llegue a 0
	    goto tres		 ;saltamos a la direccion de tres para iniciar de nuevo
	    return		;retorno a la subrutina retardo

end	