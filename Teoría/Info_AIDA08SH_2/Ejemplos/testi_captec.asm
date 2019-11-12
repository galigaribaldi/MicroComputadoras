* Programa MENSATERM_SH32
* Ejecutable en RAM del MCU MC9S08SH32
* Captura teclas oprimidas en terminal.

* Si se oprimió la tecla 1 despliega "Fue la tecla 1"
* Si se oprimió la tecla 2 despliega "Fue la tecla 2"
* Si se oprimió la tecla 3 despliega "Fue la tecla 3"
* Si se oprimió una teccla diferente de las anteriores despliega "Tecla inválida"

* Por: Antonio Salvá Calleja
* Fecha: septiembre 26,2018

**** Equ's del sci1 *******
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f

********************************



              org $0100

; Inicializa puerto serie
              ldhx #$0082  ;BR=130 para 
              sthx scibdh  ;9600 bps, @Fbus=20 MHz
              mov #$0c,scic2  ;habilita tx y rx
;.........................................
              
ciclot:        bsr rxsci
               cmp #$31
               beq fueuno
               cmp #$32
               beq fuedos
               cmp #$33
               beq fuetres
               bra fuetecinv

               



fueuno:        ldhx #textf1
               bsr desptexto
               bra ciclot

fuedos:        ldhx #textf2
               bsr desptexto
               bra ciclot

fuetres:       ldhx #textf3
               bsr desptexto
               bra ciclot

fuetecinv:     ldhx #text_tinv
               bsr desptexto
               bra ciclot


***********************************************
txsci:         brclr 6,scis1,txsci
               sta scid
               rts

rxsci:         brclr 5,scis1,rxsci
               lda scid
               rts

desptexto:     pshh
               pshx
             
otrocar:       lda ,x
               cmp #$04 ;Checa por fin de texto
               beq fuera
               bsr txsci
               aix #$01 ;h:x <-- h:x + 1
               bra otrocar
fuera:         pulx
               pulh
               rts


textf1:        fcc "Fue la tecla 1"
               db $0d,$04

textf2:        fcc "Fue la tecla 2"
               db $0d,$04

textf3:        fcc "Fue la tecla 3"
               db $0d,$04

text_tinv:     fcc "Tecla inválida"
               db $0d,$04




