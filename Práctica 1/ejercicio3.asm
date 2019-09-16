 processor 16f877     	;Procesador a utilizar
 include<p16f877.inc> ;Incluir libreria

;Agregar un valor a la localidad 01h, que sea de 1
    org 0           	;Vector de RESET
    goto inicio
    org 5
 
inicio:	movlw h'1'    ;Carga en W en valor inicial de 1
      	movwf h'20'   ;Mueve el valor de W a la Localidad 20h
ciclo:  rlf h'20',1   ;Hace un rotamiento a la Izquierda y guarda en 20h
    	btfss h'20',7 ;Comprueba si el valor que hay en 20h es 80h
    	goto ciclo    ;NO,vulve a hacer corrimiento
    	goto inicio   ;SI, vuelve a iniciar secuencia
		end