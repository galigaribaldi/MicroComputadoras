processor 16f877 		;Indica la versión del procesador
 include<p16f877.inc>	;Incluye la librería de la versión del procesador
 
 org 0h			;Para el vector RESET en la dirección de inicio
 goto inicio	;Salta a inicio
 org 5h			;Dirección de inicio del programa del usuario
 
 inicio:	clrf PORTA			;Limpia lo que haya en el puerto A
 			bsf STATUS, RP0
 			bcf STATUS, RP1		;Cambia a banco 1
 			movlw 06H
 			movwf ADCON1		;Registro para entradas/salidas DIGITALES
 			movlw h'ff'
 			movwf TRISA
 			clrf TRISB
 			bcf STATUS, RP0		;Cambia a banco 0
 			
 ciclo:		movlw h'00'
 			xorwf PORTA			;Operación XOR
 			btfsc STATUS, Z
 			goto caso0
 			movlw h'02'
 			xorwf PORTA
 			btfsc STATUS, Z
 			goto caso1
 			movlw h'04'
 			xorwf PORTA
 			btfsc STATUS, Z
 			goto caso2
 			movlw h'08'
 			xorwf PORTA
 			btfsc STATUS, Z
 			goto caso3
 			movlw h'10'
 			xorwf PORTA
 			btfsc STATUS, Z
 			goto caso4
 			
 caso0:		movlw b'00000000'	;Motor OFF, Paro
 			movwf PORTB
 			goto ciclo
 			
 caso1:		movlw b'00000011'	;Motor Derecho ON, Horario
 			movwf PORTB
 			goto ciclo
 			
 caso2:		movlw b'00000010'	;Motor Derecho ON, Antihorario
 			movwf PORTB
 			goto ciclo
 			
 caso3:		movlw b'00001100'	;Motor Izquierdo ON, Horario
 			movwf PORTB
 			goto ciclo
 			
 caso4:		movlw b'00001000'	;Motor Izquierdo ON, Antihorario
 			movwf PORTB
 			goto ciclo
 			
 end