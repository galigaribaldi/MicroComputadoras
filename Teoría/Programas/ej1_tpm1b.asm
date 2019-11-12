
** Programa ejemplo de interrupción por overflow del temporizador 1.
** Se genera una interrupción cada 50 ms, la acción que se efectúa es
** la complementación del puerto C.

** Este programa se hizo el 20/feb/2019


ptcd equ $04
ptcdd equ $05

tpm1sc equ $20
tpm1modh equ $23
tpm1modl equ $24

contaux equ $b0


                    org $8000


                  mov #$ff,ptcdd ;ptcd es salida en todos sus bits

                  mov #$4c,tpm1sc ;toie <-- 1, pe=16, reloj base es reloj de bus
                  mov #$f4,tpm1modh
                  mov #$23,tpm1modl ;Tovf=50 ms
			clr contaux

                  cli

fin:             bra fin

servovf:         lda tpm1sc
                 bclr 7,tpm1sc ;TOF <-- 0
			inc contaux 
			lda contaux 
			cmp #$14 ;compara cuenta con 20
			bne salir
			clr contaux

                 com ptcd

salir:                 rti



                 org $d7e8
                 dw servovf
  





  
            

         