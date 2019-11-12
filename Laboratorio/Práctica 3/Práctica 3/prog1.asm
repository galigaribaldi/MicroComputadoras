processor 16f877 ;Indica la versión del procesador
include<p16f877.inc> ;Incluye la librería de la versión del procesador

 org 0 ;Para el vector reset a la dirección de inicio
 goto inicio ;Salta a inicio
 org 5	;Dirección de inicio del programa del usuario 

inicio:		clrf	PORTB ;Limpiamos lo que haya en puerto B
			clrf	PORTA ;Limpiamos lo que haya en puerto A
			bsf		STATUS,RP0 	
			bcf		STATUS,RP1  ;Cambiamos a banco 1
			movlw	H'06'
			movwf	ADCON1  ;Registro para Entradas/Salidas DIGITALES
			movlw	H'FF' 
			movwf	TRISA    
			movlw 	H'00'		;Movemos un 0 
			movwf 	TRISB
			bcf 	STATUS,RP0 ;Cambiamos a banco 0

ciclo:		btfsc 	PORTA,0 ; Si es cero, salta a apagar y seleccionamos el bit de derecha a izquierda
			goto 	encender  ;Si es uno, salta a encender
			goto 	apagar

apagar:		clrf 	PORTB  ;Limpiamos lo que hay en el puerto B
			goto 	ciclo ;Se cicla lo que hay en puerto B para que permanezca en ese estado

encender:	movlw 	H'FF' ;Para el último bit del puerto B
			movwf 	PORTB ;Movemos lo que hay en w
			goto 	ciclo ;Saltamos al ciclo

end