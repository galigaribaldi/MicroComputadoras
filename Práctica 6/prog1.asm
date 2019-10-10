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
		movwf PORTB		;Se manda la conversi�n al puerto B
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
