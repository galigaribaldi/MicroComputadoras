processor 16f877 ;Indica la versión del procesador
 include<p16f877.inc>	;Incluye la librería de la versión del procesador

contador equ h'20' ;Ayuda en los corrimientos
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h      ;Constantes para el retardo
cte2 equ 50h
cte3 equ 60h

 org 0 ;Carga el vector de RESET la dirección de inicio
 goto inicio ;Salto incondicional a inicio
 org 5	;Dirección de inicio del programa del usuario

inicio:		clrf	PORTB ;Limpiamos el puerto B
			clrf	PORTA ;Limpiamos el puerto A
			bsf		STATUS,RP0
			bcf		STATUS,RP1  ;Cambiamos a banco 1
			movlw	H'07' ;Movemos un 7 a W
			movwf	ADCON1  ;Registro para Entradas/Salidas Digitales
			movlw	H'FF'	;Movemos el valor FF de la literal a W
			movwf	TRISA    ;Movemos al registro TRISA lo que tiene W
			movlw H'00'	;Movemos lo de la literal a W
			movwf TRISB	;Movemos lo que tiene W a TRISB
			bcf STATUS,RP0 ;Cambiamos a banco 0 

ciclo:		btfsc PORTA,2 ;Preguntamos por el bit 2 del Puerto A
			goto c56   ;Para el caso 5 o 6
			goto c1234 ;Para el caso del 1 al 4

c1234:		btfsc PORTA,1 ;Preguntamos por el bit 1 del Puerto A
			goto c34 ;Para el caso 3 y 4			
			goto c12 ;Para el caso 1 y 2

c12:		btfsc PORTA,0 ;Preguntamos por el bit 0 del puerto A
			goto c2 ;Entramos al caso 2
			goto c1 ;Pasamos al caso 1

c34:		btfsc PORTA,0 ;Preguntamos por el bit 0 del puerto A
			goto c4 ;Pasamos al caso 4
			goto c3 ;Pasamos al caso 3

c56:		btfsc PORTA,0 ;Preguntamos por el bit 0 del puerto A
			goto c6 ;Para el caso 6
			goto c5 ;Para el caso 5

;Todos los leds apagados
c1: 		clrf PORTB ;Limpiamos lo que hay en el puerto B
			goto ciclo ;Regresamos al ciclo

;Todos los leds encendidos
c2:			movlw H'FF'	;Movemos a W el valor FF 
			movwf PORTB ;Moviendo el valor de W al puerto B, se encenderá el led
			goto ciclo

;Corrimiento del bit más significativo a la derecha
c3:			bcf STATUS,0 ;Limpiamos al carry
			movlw H'80'
			movwf PORTB
			movlw H'08'
			movwf contador

;Ciclo para el corrimiento a la derecha
loop1: 		call retardo	;Llamamos al retardo
			rrf PORTB,1		;Recorremos los bits a la derecha
			decf contador	;Decrementamos el contador
			btfsc	STATUS,2 ;Preguntamos por el bit 2 del registro STATUS
			goto ciclo
			goto loop1

;Corrimiento del bit menos significativo a la izquierda
c4: 		bcf STATUS,0
			movlw H'80'
			movwf PORTB
			movlw H'08'
			movwf contador

;Ciclo para el corrimiento a la izquierda
loop2:		call retardo
			rlf PORTB,1
			decf contador
			btfsc	STATUS,2
			goto ciclo
			goto loop2

;Corrimiento del bit más significativo hacia la derecha y a la izquierda
c5:		
;-------- Corrimiento Derecha
			bcf STATUS,0 ;Limpiamos al carry
			movlw H'80'
			movwf PORTB
			movlw H'08'
			movwf contador
	loop3:
				call retardo
				rrf PORTB,1
				decf contador
				btfss	STATUS,2
				goto loop3

;------ Corrimiento Izquierda
			movlw H'08'
			movwf contador
			goto loop2

;Apagar y encender todos los bits, con retardo de 1/2 segundo
c6:			movlw b'11111111'
			movwf PORTB
			call retardo
			movlw b'00000000'
			movwf PORTB
			call retardo
			goto ciclo
			goto c6

;Subrutina utilizada para controlar el tiempo de retardo
retardo  	movlw cte1 ;Carga el valor de cte1 en W
 			movwf valor1 ;Almacena en valor1 lo que hay en W

tres 		movlw cte2
 			movwf valor2

dos 		movlw cte3
 			movwf valor3

uno 		decfsz valor3 ;Decrementa valor3 y compara con cero, si es distinto repite el ciclo
 			goto uno
 			decfsz valor2
 			goto dos
 			decfsz valor1
 			goto tres
			return
end