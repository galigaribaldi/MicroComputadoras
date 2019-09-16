;este es el ejercicio 4
processor 16f877
 include<p16f877.inc>

contador 	equ h'24'	;definimos contadotr en 24
valor1 		equ h'21'	;
valor2 		equ h'22'	;
valor3 		equ h'23'	;
cte1 		equ 40h;  cte vale 20*
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
 
loop2 		movlw h'FF'	; cargar en w un ff
			movwf contador; mandar a la variable contador el valor w=7
			movlw h'00'; carga un 0h en W
			movwf PORTB; manda lo de w a port b =0h
 			call retardo	;llamada a la subrutina retardo
ciclo		incf PORTB, 1  ; incrementamos en 1 el valor de PORTB
			call retardo; se hace un retardo
			decf contador; decrementamos el contador
			btfss STATUS, Z; se compara el contador con 0,si es 0 se va a loop 2
			goto ciclo; volvemos a la etiqueta ciclo

			goto loop2  ; cuando sea contador sea 0 se regresa a loop 2 a repetir todo

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