* Programa MENSATERM_SH32
* Ejecutable en RAM del MCU MC9S08SH32
* Despliega repetitivamente en el emulador
* de terminal el mensaje:

* Hola alumnos desde el dispositivo el MCU MC9S08SH32.
* Habilitado como dispositivo CHIPBAS8SH.

* Por: Antonio Salvá Calleja
* Fecha: agosto 24,2016

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
               ldhx #textmens
otrocar:       lda ,x
               cmp #$04 ;Checa por fin de texto
               beq ciclot
               bsr txsci
               aix #$01 ;h:x <-- h:x + 1
               bra otrocar

               
***********************************************
txsci:         brclr 6,scis1,txsci
               sta scid
               rts

rxsci:         brclr 5,scis1,rxsci
               lda scid
               rts

textmens:      fcc "Hola mundo desde el MCU MC9S08SH32."
               db $0d,$0a ; Para hacer un salto de linea y fregresa al renglon
               fcc "Sí funciona esta cosa :'v."
               db $0d,$0a,$0d,$0a,$04 ;Fin de texto

             

