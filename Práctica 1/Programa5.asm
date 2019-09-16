  processor 16f877     ;Procesador a utilizar
  include<p16f877.inc> ;Libreria
  
cte1 equ h'20'

  org 0           ;Vector de RESET
  goto inicio
  org  5

inicio
  movlw h'20'
  movwf FSR       ;FSR apunta al elemento siguiente
  movf cte1,w      ;W contiene el elemento inicial
Comprobar
  btfsc FSR,6     ;comprueba si es la direccion 40h
  goto cuarenta        ;finaliza si es cierto
  subwf INDF,w   ;sino, Realiza INDF-W
  btfss STATUS,C ;Verifica si el resultado fue positivo
  goto Actualiza     ;Si sí , entonces el siguiente es menor
  goto continua  ;sino,entonces el Primero es menor
Actualiza
  movf INDF,w   ;W contiene al Menor 
  incf FSR,1     ;FSR apunta al siguiente
  movwf h'41'    ;Guarda menor en h'41'
  movwf cte1      ;Guarda el menor
  goto Comprobar    ;Sigue comparando
continua
  incf FSR,1     ;Apunta al siguiente
  movf cte1,w     ;Carga el menor en W
  goto Comprobar    ;Sigue comparando
cuarenta
  subwf INDF,w   ;sino, Realiza INDF-W
  btfss STATUS,C ;Verifica si el resultado fue positivo
  call Actua40     ;Si sí , entonces el siguiente es menor
  call conti40  ;sino,entonces el Primero es menor
  goto FIN

			
Actua40

  movf INDF,w   ;W contiene al Menor 
  incf FSR,1     ;FSR apunta al siguiente
  movwf h'41'    ;Guarda menor en h'41'
  movwf cte1      ;Guarda el menor
  return

conti40
incf FSR,1     ;Apunta al siguiente
  movf cte1,w     ;Carga el menor en W
  return

FIN
end