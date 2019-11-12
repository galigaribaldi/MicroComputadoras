processor 16f877		 ;Indica la versi�n del procesador
	include <p16f877.inc>	 ;Incluye la librer�a de la versi�n del procesador
 
	J equ 0x22
	K equ 0x21
	org	0			;Carga al vector de RESET la direcci�n de inicio
	goto inicio 	;Salta a inicio
	org 05	 		;Direcci�n de inicio del programa del usuario
	
inicio: 
		clrf PORTA 		;Limpiamos lo que hay en el puerto A
		bsf STATUS,RP0 	;Nos cambiamos de banco
		bcf STATUS,RP1	
		movlw 00h   	;Configuramos entradas/salidas anal�gicas
		movwf ADCON1
		movwf TRISB		;Movemos un W al registro TRISB
		bcf	STATUS,RP0 	;Regresamos al banco 0  
		movlw b'11000001' ;Seleccionamos la frecuencia de reloj, selecci�n de canal
		movwf ADCON0
		clrf PORTB		;Limpiamos PORTB
		
cad:	
		bsf ADCON0, 2	;Modificamos el bit 2 de ADCON0, comienza la conversi�n
		call retardo	;Para la conversi�n, llama a retardo
		bcf ADCON0, 2	
		movfw ADRESH	;Se guarda la conversi�n
		sublw D'85'		;Resta de la literal con 85
		btfsc STATUS, C	;Si carry est� habilitado, salta a caso1
		goto caso1		;Salto a caso1
		movfw ADRESH	
		sublw D'170'	;Resta de la literal con 170
		btfsc STATUS, C	;Si carry est� habilitado, salta a caso2
		goto caso2		;Salto a caso2
		movlw b'00000111'	;Si no va a ning�n casoo, prende 3 leds
		movwf PORTB
		goto cad
		
caso1:
		movlw b'00000001'	;Mueve la combinaci�n para encender el led 0
		movwf PORTB			;Mueve lo que tiene W al puerto B
		goto cad
		
caso2:
		movlw b'00000011'	;Mueve la combinaci�n para encender los leds 0 y 1
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
