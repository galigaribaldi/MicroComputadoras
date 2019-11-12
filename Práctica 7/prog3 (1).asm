processor 16f877	;Indica la versión del procesador	
include<p16f877.inc>	;Incluye la libreria de la versión del procesador
			
	valor1 equ h'21'
	valor2 equ h'22'
	valor3 equ h'23'
	cont equ h'24'
	dato equ h'25'
	cte1 equ 20h
	cte2 equ 50h
	cte3 equ 60h
	J equ 0x26
	K equ 0x27
	can0 equ 0x28
    can1 equ 0x29
	can2 equ 0x30
			
	org 0h	;Carga al vector de RESET la dirección de inicio	 
	goto inicio
	org 5h	;Dirección de inicio del programa del usuario 

inicio: 	
			clrf PORTA	;Limpia lo que hay en el puerto A
			clrf PORTB		
			bsf STATUS,RP0 	;Cambia de banco
			bcf STATUS,RP1	
			movlw 00h   	;Configura entradas/salidas analógicas
			movwf ADCON1
			movlw 00h
			movwf TRISB

			bsf TXSTA, BRGH		;Velocidad alta
			clrf TRISB
			movlw D'32'			;Cantidad de bits para ser transmitidos/segundo
			movwf SPBRG
			bcf TXSTA, SYNC		;Modo asíncrono
			bsf TXSTA, TXEN		;Activa la transmisión de datos
			;Hasta aquí va la configuración del puerto serie

			bcf STATUS, RP0		;Regreso al banco 0
			
			bsf RCSTA, SPEN		;Se habilita el puerto serie
			bsf RCSTA, CREN		;Recepción continua modo asíncrono

cad:		movlw b'11000001'
			movwf ADCON0
			bsf ADCON0,2
			call retardo
			bcf ADCON0,2
			movfw ADRESH
			movwf can0

 			movlw b'11001001'
			movwf ADCON0
			bsf ADCON0,2
			call retardo
			bcf ADCON0,2
			movfw ADRESH
			movwf can1

			movlw b'11010001'
			movwf ADCON0
			bsf ADCON0,2
			call retardo
			bcf ADCON0,2
			movfw ADRESH
			movwf can2

			movfw can0
			subwf can1, w
			btfsc STATUS, C
	        goto c1m2
			goto c0m2

c0m2:	 movfw can0
		 subwf can2, w
		 btfsc STATUS, C
         goto c2m
		 goto c0m

c1m2:	 movfw can1
		 subwf can2, w
		 btfsc STATUS, C
         goto c2m
		 goto c1m

c0m:	 movlw A'0'
		 movwf TXREG
		 bsf STATUS,RP0
		 goto transmitir

c1m:	 movlw A'1'
		 movwf TXREG
		 bsf STATUS,RP0
		 goto transmitir

c2m:	 movlw A'2'
		 movwf TXREG
		 bsf STATUS,RP0
		 goto transmitir

transmitir:	btfss TXSTA,TRMT
			goto transmitir
			bcf STATUS,RP0
			goto cad

retardo: movlw D'25'
		 movwf J
jloop: 	 movwf K
kloop:	 decfsz K,f
		 goto kloop
		 decfsz J,f
		 goto jloop
		 return
end		;Directiva de fin del programa