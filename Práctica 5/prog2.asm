	processor 16f877		 ;Indica la versión del procesador
	include <p16f877.inc>	 ;Incluye la librería de la versión del procesador
 
	org	0			;Carga al vector de RESET la dirección de inicio
	goto inicio 	;Salta a inicio
	org 05	 		;Dirección de inicio del programa del usuario  

inicio: 
		clrf PORTA 		;Limpiamos lo que hay en el puerto A
		bsf STATUS,RP0 	;Nos cambiamos de banco
		bcf STATUS,RP1	
		movlw 06H   
		movwf ADCON1  	;Configuramos el registro como entrada/salida
		movlw H'FF'   	;Movemos un 255 a W
		movwf TRISA   	;Movemos W al registro TRISA
		clrf TRISB		;Limpia el registro TRISB
		bcf	STATUS,RP0 	;Regresamos al banco 0
		
ciclo: 
		movlw h'07'			;Movemos un 7 a W
		andwf PORTA, W		;Realizamos un AND entre el puerto A y W
		xorlw b'00000100'	;Realizamos un XOR entre w y el valor en binario
		btfsc STATUS, Z		;Preguntamos por la bandera, salta si es cero
		goto caso1			;Salta a caso1
		movlw h'07'
		andwf PORTA, W
		xorlw b'00000010'
		btfsc STATUS, Z
		goto caso2
		movlw h'07'
		andwf PORTA, W
		xorlw b'00000001'
		btfsc STATUS, Z
		goto caso3
		movlw h'07'
		andwf PORTA, W
		xorlw b'00000000'
		btfsc STATUS, Z
		goto caso4
		goto inicio  	;Regresamos a inicio

caso1:
	movlw	b'00001011' ;Motor izquierdo atrás, motor derecho adelante
	movwf	PORTB		;Movemos el resultado anterior al puerto B que son los motores
	goto ciclo

caso2:
	movlw	b'00001111'	;Ambos motores adelante
	movwf	PORTB		;Movemos el resultado anterior al puerto B que son los motores
	goto ciclo

caso3:
	movlw	b'00001110' ;Motor izquierdo adelante, motor derecho atrás
	movwf	PORTB		;Movemos el resultado anterior al puerto B que son los motores
	goto ciclo

caso4:
	movlw	b'00000000' ;Ambos motores en paro cuando no se cubre ningún sensor
	movwf	PORTB		;Movemos el resultado anterior al puerto B que son los motores
	goto ciclo

	end 
		