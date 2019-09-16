processor 16f877;
include <p16f877.inc>

K equ H'26'
L equ H'27'
M equ H'28'
   org 0;carga la dirección 0
   goto inicio
   org 5
inicio: movf K, W
   addwf L, W
   movwf M ; lo que tiene w lo guarda en L
   goto inicio ; vuelve al inicio
   end

; suma lo que tiene w(5) con k