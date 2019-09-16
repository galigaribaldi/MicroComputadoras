;este es el ejercicio 2 y 3
processor 16f877
 include<p16f877.inc>

contador 	equ h'20'	;definimos contadotr en 20
valor1 		equ h'21'	;
valor2 		equ h'22'	;
valor3 		equ h'23'	;
cte1 		equ 60h;  cte vale 20*
cte2 		equ 50h  ;cte vale 50
cte3 		equ 60h  ;cte vale 60

 			org 0
			goto inicio  ;brinca a la etiqueta inicio
 			
			org 5
inicio		bsf STATUS,5 ;  rp0 en 1
 			BCF STATUS,6 ;  rp1 en 0
 			MOVLW H'0'  ;cargamos en w un 0 w=0H
 			MOVWF TRISB  ; trisB recibe los ceros, por lo que todo el puerto es de salida
 			BCF STATUS,5 ;asigna el valor de 0 a rp0
 			clrf PORTB	;limpia el registro portb, les pone puros 0
 
loop2 		bsf PORTB,7	; pin 0 del puerto B lo pone en 1
			bsf PORTB,6
			bsf PORTB,5
			bsf PORTB,4
			bsf PORTB,3
			bsf PORTB,2
			bsf PORTB,1
			bsf PORTB,0
 			call retardo	;llamada a la subrutina retardo
 			bcf PORTB,7	; pone el bit 0 del puerto b en 0
			bcf PORTB,6
			bcf PORTB,5
			bcf PORTB,4
			bcf PORTB,3
			bcf PORTB,2
			bcf PORTB,1
			bcf PORTB,0
 			call retardo	;llamada a la subrutina retardo
 			goto loop2; brinca a la etiqueta loop2

retardo 	movlw cte1	;w=cte1, w=20h
 			movwf valor1	;mandamos el valor de w a valor1 que esta en 21h valor1=20h

tres 		movlw cte2 ;w=cte   w=50h
 			movwf valor2 ;valor2=50

dos 		movlw cte3
 			movwf valor3; valor3=60

uno 		decfsz valor3 ; decrementa el valor3 y compara si es 0, si no es cero no brinca y ejecuta siguiente expresion
 			goto uno
 			decfsz valor2	;
 			goto dos
 			decfsz valor1
 			goto tres
			return ; cuando los 3 sean 0 se regresa en donde quedó la llamada retardo
END

;genera una señal cuadrada en el pin 0