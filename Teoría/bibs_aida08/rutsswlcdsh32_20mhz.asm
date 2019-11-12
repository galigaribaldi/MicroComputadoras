***********************************************
*                                             *
*           ruts_sw_lcd_sh32_20mhz            *
* INICIALIZACIÓN DE DESPLEGADO Y RUTINAS      *
* ELEMENTALES DE ESCRITRURA DE COMANDOS,      *
* DATOS Y TEXTO A RENGLÓN.                    *
* PARA LA INTERFAZ DE LCD DE LA TARJETA       *
* MINICON_08SH. (MCU MC9S08SH32).             *
* PARA LCD de 4x20,2x16,1x16                  *
* Supone LCD conectado a líneas pta7 a pta2   *
* del puerto A del MCU.                       *
*                                             *
*(Emplea las localidades de RAM $80,$81 y $82)*
*                                             *
*                                             *
* Adaptada para     fbus=20MHz                *
* Subrutina 'copiadis' adecuada para 16       *
* columnas.                                   *
* Contiene habilitación para caracteres de    *
* lengua española (áéíóúñüÑ).                 *
*                                             *
*       (adecuado para LCD's JHD..)           * 
*        POR: ANTONIO SALVÁ CALLEJA           *
*             MARZO  DE 2018                  *
*                                             *
*********************************************** 

contcar equ $80
cont#cgram equ $81
contret  equ $82


ascamina    equ $e1
ascemina    equ $e9
ascimina    equ $ed
ascomina    equ $f3
ascumina    equ $fa
asceniemin  equ $f1
ascumindier equ $fc

ascamaya    equ $c1
ascemaya    equ $c9
ascimaya    equ $cd
ascomaya    equ $d3
ascumaya    equ $da
asceniemay  equ $d1
ascumaydier equ $dc

portlcd equ $04 ;LCD conectado a PTCD
ddrportlcd equ $05

inilcd:     psha
            lda #$fc
            sta ddrportlcd  ;$04 ; ptb7 a ptb2 son salidas
            jsr ret5m ;espera para ejecución autónoma aprox 20 ms > 15 ms
            jsr ret5m
            jsr ret5m
            jsr ret5m
            lda #$30
            bsr escom8
            jsr ret5m
            bsr escom8
            jsr ret100m  ;espera de más de 100 milisegundos
            jsr ret5m
            bsr escom8
  
            lda #$20
            bsr escom8 ;cambio a ducto de datos de 4 bits

            lda #$28 
            bsr escom4
            lda #$0c 
            bsr escom4 ;enciende display
            lda #$01
            bsr escom4 ;limpia display
            lda #$06
            bsr escom4

            jsr carga#cgram
**** fin de inicialización de display **********
*            jmp brop
            pula
            rts

            
escom8:     psha
            and #$f0 ;los cuatro bits más significativos quedan en nibble alto de A
 
            sta portlcd  ;$00
            bclr 2,portlcd ;$00 ;rs<----0
            bset 3,portlcd ;$00 ;Ed<----1
*            bsr ret500 ;espera aprox 2000 microsegundos
*            bsr ret500
*            bsr ret500  
*            bsr ret500

*            bsr ret500
*            bsr ret500  
*            bsr ret500

            mov #$23,contret  ;espera aprox 2000 microsegundos
oppp:       bsr ret500
            dec contret
            bne oppp           


            


            bclr 3,portlcd  ;$00 ;Ed<----0
            pula
            rts

escdat8:    psha
            and #$f0 ;los cuatro bits más significativos quedan en nibble alto de A
            sta portlcd  ;$00
            bset 2,portlcd ;$00 ;rs<----1
            bset 3,portlcd ;$00 ;Ed<----1
*            bsr ret500 ;espera aprox 2000 microsegundos
*            bsr ret500
*            bsr ret500
*            bsr ret500

*            bsr ret500
*            bsr ret500  
*            bsr ret500
*            bsr ret500

            mov #$23,contret  ;espera aprox 2000 microsegundos
oppp2:      bsr ret500
            dec contret
            bne oppp2 
           

            


            bclr 3,portlcd ;$00 ;Ed<----0
            bclr 2,portlcd  ;$00 ;rs<----0
            pula
            rts

escdat4:   psha
           cmp #$7f
           bls sig#1
asciiext:  bsr prasciiext ;Si el caracter es asciiext se tiene que 
;                          cambiar su código por el asociado con lo que se cargó 
;                          en la cgram al inicializarse. Los códigos especiales 
;                          van del 0 al 7 como a continuacón se indica:
;                          
;                          $00-->á
;                          $01-->é
;                          $02-->í
;                          $03-->ó
;                          $04-->ú
;                          $05-->ñ
;                          $06-->ü
;                          $07-->Ñ
                             
sig#1:     bsr escdat8
           clc
           rola
           rola
           rola
           rola
           bsr escdat8
           pula
           rts

escom4:    psha
           bsr escom8
           clc
           rola
           rola
           rola
           rola
           bsr escom8
           pula
           rts

*** subrutinas de retardo auxiliares @ fbus=4MHz ***

* subrutina de retardo de aprox 100 milisegundos
ret100m:    pshx
            ldx #$64   ;14
otroret5m:  bsr ret5m
            decx
            bne otroret5m
            pulx
            rts
         

* subrutina de retardo de aprox 5 milisegundos
ret5m:      pshx
            ldx #$64  ;14  ;0a
otroret500  bsr ret500
            decx
            bne otroret500
            pulx
            rts
       
* Subrutina de retardo de aprox 100 microsegundoa   @ fbus=4Mhz
ret100:      pshx
             nop
             nop
             nop
             ldx #$4c ;2d  ; retardo Tr(x)=(18+5x)*Te

vv:          nop
             decx
             bne vv
             pulx
             rts


* Subrutina de retardo de aprox 250 microsegundoa   @ fbus=4MHz
ret500:      pshx
             nop
             nop
             nop
             ldx #$c4   ;f2  ; retardo Tr(x)=(18+5x)*Te

vv1:         nop
             decx
             bne vv1
             pulx
             rts

******  Subrutina  copiadis
***     Copia 16 caracteres a renglon de display contenidos a partir de dir 
***     apuntada por HX.
***     para primer renglón ACCA debe llegar con $80, 
***     para segundo renglón ACCA debe llegar con $C0 
***     para tercer  renglón ACCA debe llegar con $94 
***     para cuarto renglón ACCA debe llegar con $d4 

copiadis:  pshx
           pshh
           psha
           bsr escom4
           lda #$10
           sta contcar
otra:      lda ,x
           bsr escdat4
           aix #$01
           dec contcar
           bne otra
           pula
           pulh
           pulx
           rts


carga#cgram:  psha
              pshh
              pshx

              lda #$40 ;Posiciona para origen de cgram
              jsr escom4 
              mov #$40,cont#cgram
              ldhx #aminacen 

otradircg:    lda ,x
              jsr escdat4
              aix #$01
              dec cont#cgram
              bne otradircg

              pulx
              pulh
              pula
              rts

prasciiext: cmp #ascamina
            beq fue#amina

            cmp #ascemina
            beq fue#emina

            cmp #ascimina
            beq fue#imina

            cmp #ascomina
            beq fue#omina

            cmp #ascumina
            beq fue#umina

            cmp #asceniemin
            beq fue#eniemin

            cmp #ascumindier
            beq fue#umindier

            cmp #asceniemay
            beq fue#eniemay


            bra sal#prasciiext

fue#amina:   lda #$00
             bra sal#prasciiext
fue#emina:   lda #$01
             bra sal#prasciiext
fue#imina:   lda #$02
             bra sal#prasciiext
fue#omina:   lda #$03
             bra sal#prasciiext
fue#umina:   lda #$04
             bra sal#prasciiext
fue#eniemin: lda #$05
             bra sal#prasciiext
fue#umindier: lda #$06
              bra sal#prasciiext

fue#eniemay: lda #$07

sal#prasciiext: rts




aminacen:    db $02,$04,$0e,$01,$0f,$11,$0f,$00
eminacen:    db $02,$04,$0e,$11,$1f,$10,$0e,$00
iminacen:    db $02,$04,$00,$0c,$04,$04,$0e,$00
ominacen:    db $02,$04,$0e,$11,$11,$11,$0e,$00
uminacen:    db $02,$04,$11,$11,$11,$13,$0d,$00
eniemin:     db $0e,$00,$16,$19,$11,$11,$11,$00
umindier:    db $11,$00,$11,$11,$11,$13,$0d,$00
eniemayacen: db $0e,$00,$11,$19,$15,$13,$11,$00 
 
;amayacen:    db $02,$04,$0e,$11,$1f,$11,$11,$00          
*amayacen2:    db $02,$04,$0e,$11,$11,$1f,$11,$00 
;emayacen:    db $02,$04,$1f,$10,$1c,$10,$1f,$00
;imayacen:    db $02,$04,$0e,$04,$04,$04,$0e,$00
;omayacen:    db $07,$0e,$11,$11,$11,$11,$0e,$00
;umayacen:    db $02,$04,$11,$11,$11,$11,$0e,$00 
;umaydier:    db $11,$00,$11,$11,$11,$11,$0e,$00 


*brop:      nop


  