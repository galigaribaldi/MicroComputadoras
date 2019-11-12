
** PROGRAMA EJ1CONVAD_8B_SH32 **
** Ejecutable desde RAM
** Efectúa cíclicamente la conversión 
** analogica a digital del canal ADP6 del
** MCU MC9S08SH32.
** La resolución es de 8 bits.
** El resultado de la conversión se despliega en el LCD,
** Conectado a la interfaz propia de éste presente
** en la tarjeta MINICON_08SH.

** Por: Antonio Salvá Calleja
** Fecha: marzo 4 de 2016
 

dig4 equ $c0
dig3 equ $c1
dig2 equ $c2
dig1 equ $c3
dig0 equ $c4
dir_resasc  equ $00c0


adcsc1  equ $10
adcsc2  equ $11
adcrh   equ $12
adcrl   equ $13
adccvh  equ $14
adccvl  equ $15
adccfg  equ $16
apctl1  equ $17
apctl2  equ $18


numcan  equ $06
byte_apctl1 equ $20 ;(byte_apctl1=2^numcan)


             org $0100
$INCLUDE "j:\hcs08\mdam8a06.asm"

; adccfg se deja en su default lo que hace que:
; adclck=busclock, conversión de 8 bits, tiempo corto de muestreo,
; configuración de alta velocidad.

;Inicializa bufer de resultado en RAM
             ldhx #dir_resasc
             lda #$20
otroesp:     sta ,x
             aix #$01
             cphx #dir_resasc+16
             bne otroesp
;...............................................................

           

iniconv:     lda #numcan
             ldx #byte_apctl1

             bsr conv8bit
             bsr c2bascii

             lda #$80
             ldhx #dir_resasc
             jsr copiadis
             bra iniconv






* Subrutina conv8bit
* Antes de invocar:
* a <-- número de canal a convertir
* x <-- Palabra a cargar en apctl1 acorde con 
*       número de canal a convertir.
* Al retornar:
* h:x <-- resultado de la conversión
 
conv8bit:   stx apctl1
            sta adcsc1
checoco:    brclr 7,adcsc1,checoco
            ldhx adcrh
            rts

** Subrutina c2bascii
** Convierte a decimal un número
** de 16 bits menor que 2560.
** Antes de invocar:
** h:x <-- N (número a convertir a decimal).
** Al retornar:
** dig3 <-- ascii de digito de millares
** dig2 <-- ascii de digito de centenas
** dig1 <-- ascii de digito de decenas
** dig0 <-- ascii de digito de unidades

c2bascii:    pshx
             pula ;h:a<---word a convertir
             ldx #$0a
             div
             psha ;cociente a stack 
             pshh
             pula
             add #$30 ;a<--ascii de digito de unidades
             sta dig0
             pula

             clrh
             ldx #$0a
             div
             psha ;cociente a stack 
             pshh
             pula
             add #$30 ;a<--ascii de digito de decenas
             sta dig1
             pula

             clrh
             ldx #$0a
             div
             psha ;cociente a stack 
             pshh
             pula
             add #$30 ;a<--ascii de digito de centenas
             sta dig2
             pula

             add #$30 ;a<--ascii de digito de millares
             sta dig3
 
             lda #$20
             sta dig4
             rts

