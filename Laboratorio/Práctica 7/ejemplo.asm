processor 16f877	;Indica la versión del procesador
include <p16f877.inc>	;Incluye la libreria de la versión del procesador

	org 0	;Carga al vector de RESET la dirección de inicio
	goto inicio
	org 5	;Dirección de inicio del programa del usuario

inicio:		bsf STATUS, RP0		;RP0=1
			bcf STATUS, RP1		;RP1=0
			bsf TXSTA, BRGH 	;BRGH=1
			movlw D'129'   	;w=129 decimal
			movwf SPBRG  	;SPBRG=w, velocidad requerida en el data sheet
			bcf TXSTA, SYNC ;Configura el modo asíncrono del registro TXSTA 
			bsf TXSTA, TXEN ;Habilitando la transmisión del registro TXSTA, TXEN=1
			clrf TRISB	;Habilitando el puerto B
			bcf STATUS, RP0	;Regresar al banco 0
			bsf RCSTA, SPEN ;Habilitando el puerto serie SPEN del registro RCSTA, SPEN=1
			bsf RCSTA, CREN	;Habilitando la recepción de datos del registro RCSTA, CREN=1
		
recibe:		btfss PIR1, RCIF	;Comparar si RCIF es 1
			goto recibe	;Si no ir a recibe
			movf RCREG, w	;Si es 1: w=RCREG
			movwf TXREG	;TXREG=w
            movwf PORTB 	;Movemos w al puerto B
			bsf STATUS, RP0	;RP0=1
		
transmite:	btfss TXSTA, TRMT	;Comparar TRMT con 1
			goto transmite	;Si no es 1, ir a transmite
			bcf STATUS, RP0	;Si es 1: RP0=0
			goto recibe	;Ir a recibe
			
end	;Directiva de fin del programa