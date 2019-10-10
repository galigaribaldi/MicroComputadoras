processor 16f877		 ;Indica la versi�n del procesador
	include <p16f877.inc>	 ;Incluye la librer�a de la versi�n del procesador
 
	J equ 0x20
	K equ 0x21
	can0 equ 0x22
	can1 equ 0x23
	can2 equ 0x24
	org	0			;Carga al vector de RESET la direcci�n de inicio
	goto inicio 	;Salta a inicio
	org 05	 		;Direcci�n de inicio del programa del usuario
	
inicio: 
		clrf PORTA 		;Limpiamos lo que hay en el puerto A
		bsf STATUS,RP0 	;Nos cambiamos de banco
		bcf STATUS,RP1	
		movlw 00h   	;Configuramos entradas/salidas anal�gicas
		movwf TRISB		;Movemos un W al registro TRISB
		bcf	STATUS,RP0 	;Regresamos al banco 0  
		clrf PORTB		;Limpiamos PORTB
		
cad:	
		movlw b'11000001'
		movwf ADCON0
		bsf ADCON0, 2	;Modificamos el bit 2 de ADCON0, comienza la conversi�n
		call retardo	;Para la conversi�n, llama a retardo
		bcf ADCON0, 2	
		movfw ADRESH	;Se guarda la conversi�n
		movwf can0
		movlw b'11001001'
		movwf ADCON0
		bsf ADCON0, 2
		call retardo
		bcf ADCON0, 2
		movfw ADRESH
		movwf can1
		movlw b'11010001'
		movwf ADCON0
		bsf ADCON0, 2
		call retardo
		bcf ADCON0, 2
		movfw ADRESH
		movwf can2
		movfw can0
		subwf can1, w
		btfsc STATUS, C
		goto c1m2
		goto c0m2
		
c0m2: 
		movfw can0
		subwf can2, w
		btfsc STATUS, C
		goto c2m
		goto c0m
		
c1m2: 
		movfw can1
		subwf can2, w
		btfsc STATUS, C
		goto c2m
		goto c1m
		
c0m:
		movlw b'00000001'	;Mueve la combinaci�n para encender el led 0
		movwf PORTB			;Mueve lo que tiene W al puerto B
		goto cad
		
c1m:
		movlw b'00000011'	;Mueve la combinaci�n para encender los leds 0 y 1
		movwf PORTB			;Mueve lo que tiene W al puerto B
		goto cad
		
c2m:
		movlw b'00000111'	;Mueve la combinaci�n para encender los leds 0 y 1
		movwf PORTB			;Mueve lo que tiene W al puerto B
		goto cad
		
retardo:
		movlw D'25'		;Cargamos un 25 decimal
		movwf J			;Movemos el valor de W a J

jloop:
		movwf K			;El valor del registro lo movemos a K
kloop:
		decfsz K, f		;Decrementamos K y lo movemos al registro
		goto kloop		;Salto a subrutina kloop
		decfsz J, f		;Decrementamos J y lo movemos al registro
		goto jloop		;Salto a subrutina jlopp
		return
end
