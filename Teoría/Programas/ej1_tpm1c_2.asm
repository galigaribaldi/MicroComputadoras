
** Programa ejemplo de interrupción por overflow del temporizador 1.
** Se genera una interrupción cada 50 ms.
** Se efectua una accion cada 50 ms o cada 2 seg, esto gobernado por sendos botones
** colocados respectivamente en pta0 y pta1.
** Si se oprime el boton conectado a pta0, la accion será cada 50 ms
** Si se oprime el boton conectado a pta1, la accion sera cada 2 seg
** La accion consiste en la complementacion del puerto c 


ptcd equ $04
ptcdd equ $05
ptape equ $1840
ptad equ $00
ptadd equ $01

tpm1sc equ $20
tpm1modh equ $23
tpm1modl equ $24


contaux equ $b0
topecont equ $b1



                    org $8000

			bset 7,ptadd ;pta7 es salida
                  mov #$ff,ptcdd ;ptcd es salida en todos sus bits
                  lda #$03
                  sta ptape ;pta0 y pta1 tienen pull up
                  mov #$28,topecont ;periodicidad por defecto es 2s


                  

                  mov #$4c,tpm1sc ;toie <-- 1, pe=16, reloj base es reloj de bus
                  mov #$f4,tpm1modh
                  mov #$23,tpm1modl ;Tovf=50 ms
			clr contaux

                  cli

checbot:         brclr 0,ptad,ac_50ms
                 brclr 1,ptad,ac_2seg
                 bra checbot

ac_50ms:         mov #$01,topecont
                 clr contaux
                 bra checbot

ac_2seg:         mov #$28,topecont
                 clr contaux
                 bra checbot

                 
servovf:         lda tpm1sc
                 bclr 7,tpm1sc ;TOF <-- 0
			inc contaux 
			lda contaux 
			cmp topecont ;compara con tope de cuenta requerido
			bne salir
			clr contaux

                 com ptcd
			lda ptad
			eor #$80
			sta ptad


salir:                 rti



                 org $d7e8
                 dw servovf
  





  
            

         