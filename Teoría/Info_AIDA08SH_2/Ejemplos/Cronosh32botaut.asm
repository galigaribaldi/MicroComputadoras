
***************** PROGRAMA CRONOSH32BOTAUT ***********************
************** Ejecutable en el MCU MC9S08SH32 *******************
********** habilitado como dispositivo CHIPBAS8SH ****************
** Este programa se puede ejecutar de manera aut�noma o bajo modo monitor

* Realiza un cron�metro que despliega en el LCD
* Horas,minutos,segundos y cent�simas. Para ello se emplea
* el temporizador 1 configurado de modo que se genera una
* interrupci�n por overflow del contador cada 10 ms.

* Se cuenta con botones de: arranque,paro y puesta a cero;
* estos est�n asociados con sendos bits del puerto A de la 
* siguiente forma:
* Bot�n de arranque est� ligado al bit pta0.
* Bot�n de paro est� ligado al bit pta1.
* Bot�n de puesta a cero est� ligado al bit pta2.

* Las cuatro figuras de tiempo que se despliegan en el LCD
* a partir del rengl�n uno y la columna uno.

* Programa escrito por: Antonio Salv� Calleja.
* Fecha: 6/abril/2016.


asciip    equ $2e
ascii2p   equ $3a
conthor   equ $90
contmin   equ $91
contseg   equ $92
cont100   equ $93
tpm1sc    equ $20
tpm1modh  equ $23
modc      equ $61a7 
pardig    equ $95
pardig2   equ $96

ptad  equ $00
ptadd equ $01
ptape equ $1840

sopt1 equ $1802
inicio equ $8000
 

          org inicio

          lda #$21
          sta sopt1 ;Deshabilita COP

          lda #$07  ;Pta2,pta1 y pta0
          sta ptape ;tienen 'pull-ups' internos.

$include "j:\hcs08\mdam8a06.asm"
          
          lda #$82
          jsr escom4
          lda #ascii2p
          jsr escdat4
          lda #$85
          jsr escom4
          lda #ascii2p
          jsr escdat4
          lda #$88
          jsr escom4
          lda #asciip
          jsr escdat4
          

          ldhx #modc
          sthx tpm1modh
          mov #$0b,tpm1sc ;toie<--0,clksb:clksa <--01, pe=8,tovf=10 ms.
          clr conthor
          clr contmin
          clr contseg
          clr cont100

         
          cli

lazo:     brclr 0,ptad,arranque
          brclr 1,ptad,paro
          brclr 2,ptad,ceros
          bsr desptemp
          bra lazo

arranque: bset 6,tpm1sc ;toie <-- 1
          bra lazo

paro:     bclr 6,tpm1sc ;toie <-- 0
          bra lazo

ceros:    clr conthor
          clr contmin
          clr contseg
          clr cont100
          bra lazo

**** Subrutina de interrupci�n **** 
sertof:   lda tpm1sc
          bclr 7,tpm1sc ;tof <-- 0

          inc cont100
          lda cont100
          cmp #$64
          bne salir
          clr cont100
          inc contseg
          lda contseg
          cmp #$3C
          bne salir
          clr contseg
          inc contmin
          lda contmin
          cmp #$3C
          bne salir
          clr contmin
          inc conthor
          lda conthor
          cmp #$18
          bne salir
          clr conthor
salir:    rti

desptemp: psha

despcent: lda #$89
          jsr escom4
          lda cont100
          bsr auxdesp
         

despseg:  lda #$86
          jsr escom4
          lda contseg
          bsr auxdesp

despmin:  lda #$83
          jsr escom4
          lda contmin
          bsr auxdesp


desphor:  lda #$80
          jsr escom4
          lda conthor
          bsr auxdesp

          pula
          rts


auxdesp:  bsr con_a
          lda pardig
          jsr escdat4
          lda pardig2
          jsr escdat4
          rts

* Subrutina con_a
* Convierte un entero positivo menor que 100
* a su representaci�n en decimal en
* caracteres ascii.
* Antes de invocar:
* a <-- N < 100
* Al retornar:
* pardig  <-- ascii de d�gito izquierdo en decimal
* pardig2 <-- ascii de d�gito derecho en decimal

con_a:    pshh
          pshx
          psha
          clrh
          ldx #$0A
          div
          add #$30
          sta pardig
          pshh
          pula
          add #$30
          sta pardig2
          pula
          pulx
          pulh
          rts

ret50m:   pshh
          pshx
          ldhx #$270E
vuelta:   nop
          nop
          aix #$FF
          cphx #$0000
          bne vuelta
          pulx
          pulh
          rts

          org $d7e8  ;Colocaci�n del vector de interrupci�n
          dw sertof  ;propio del evento de overflow del temporizador 1

          org $d7fe  ;Colocaci�n del vector de reset de usuario (VRA)
          dw inicio  


         


