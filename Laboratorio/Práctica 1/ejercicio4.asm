processor 16f877     		;Procesador a utilizar
include<p16f877.inc> 		;Libreria
 
  org 0                		;Vector de RESET
  goto inicio
  org 5
  
limpia:		clrf h'20'     ;Limpia la localidad 20h
inicio:		incf h'20',1   ;Incrementa el valor que haya en 20h
       		movlw h'9'     ;Carga en W el valor de 9h
       		xorwf h'20',w  ;Realiza XOR del contenido de W con el contenido de 20h 
       		btfss STATUS,Z ;Verifica si el resultado de XOR=0 (z=1)
       		goto inicio    ;No entonces repite el ciclo, Si entonces llega a 9
diez:		movlw h'7'     ;Carga en W el valor de 7
       		addwf h'20'    ;Suma W y loc h'20' para obtener el numero siguiente 
						   ;y seguir la secuencia de números decimales
inc:		movlw h'20'    ;Carga el valor de 20h en W
       		xorwf h'20',w  ;Realiza XOR del contenido de W con el contenido de 20h
       		btfsc STATUS,Z ;Verifica si el resultado de XOR!=0 (z=0)
       		goto  limpia   ;No, entonces llegamos al 20 y vuelve a empezar la cuenta
       		incf h'20'     ;Si, incrementa 
       		movlw h'19'    ;Carga el valor de 19h en W
       		xorwf h'20',w  ;Realiza XOR  del contenido de W con el contenido de 20h
       		btfsc STATUS,Z ;Verifica si el resultado de XOR!=0 (z=0)
       		goto diez      ;No, va a diez 
       		goto inc       ;Si, repite el ciclo
end  