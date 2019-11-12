	processor 16f877 		;Indica la versi�n del procesador
	include <p16f877.inc>	;Incluye la librer�a de la versi�n del procesador
 
	org	0			;Carga al vector de RESET la direcci�n de inicio
	goto inicio		;Salta a inicio
	org 05	 		;Direcci�n de inicio del programa del usuario

inicio: 
		bsf STATUS,RP0 ; Nos cambiamos de banco
		bcf STATUS,RP1	
		movlw H'07'   
		movwf ADCON1   ;Configuramos el registro como entrada/salida
		movlw H'FF'    ;Movemos un 255 a w
		movwf TRISA    ;Movemos W al registro TRISA
		movlw H'00'    ;Movemos un 0 a W
		movwf TRISB    ;Movemos W al registro TRISB
		bcf	STATUS,RP0 ;Regresamos al banco 0

AND:
		movlw H'07'		;Movemos un 7 a W
		andwf PORTA,W	;Aplicamos AND a lo que hay en el puerto B
		movwf PORTB		;Mostramos el reflejo de lo que hay en W en el puerto B 
		goto AND 		;Regresamos a la subrutina AND
	end
		