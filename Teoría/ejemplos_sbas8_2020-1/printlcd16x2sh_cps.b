'** Código ajustado de la sub printlcd16x2sh **

dim x1 as string
dim ren as byte
dim col as byte

'ini##dirprocs
     iniens
main  equ $804A
printlcd16x2sh  equ $82A6
     finens
'fin##dirprocs



'*  e:\bibs_aida08\printlcdsh_fwr.bib
'ini##cod


'**** INICIO DE CAPTURA VARIABLES ARGUMENTO DESDE ZONA DEL STACK ****  

        l..str~=0
        tesdir..str%=0  

        iniens

        ldhx $0E,sp 'Captura dir de vararg (tipo string)

        lda $02,x   
        sta l..str~ 
        lda ,x
        sta tesdir..str%
        lda $01,x
        sta tesdir..str%+1 

        finens
       
'.....................................
        mi..ascii%=0
       ' nnstr=""
      x1 = ""                                                                      'nulstr

        iniens
        lda l..str~
        beq fuera..
        finens

       for i..~=1 to l..str~

         iniens 
         ldhx tesdir..str%
         lda ,x
         sta mi..ascii%+1
         aix #$01
         sthx tesdir..str%
         finens

       'nnstr=nnstr+chr$(mi..ascii%)
      x1 = x1 +  chr$(mi..ascii%)

                                              'asigvarstr


        next i..~
fuera..:

        iniens
        ldhx $10,sp 'Captura dir de vararg (tipo ent1by)
        lda ,x
        sta ren                                                 
        finens


        iniens
        ldhx $12,sp 'Captura dir de vararg (tipo ent1by)
        lda ,x
        sta col                                                 
        finens

'**** FIN DE CAPTURA DE VARIABLES ARGUMENTO ****


'ini##cod_original

      'Despliega el string x1 en un LCD conectado a la interfaz propia
      'de éste presente en la tarjeta MINICON_08SH.  
      
      'ren y col representan el renglón y columna a partir de donde se 
      'desea se despliegue el sring x1.
      'Si ren y/o col son inválidos no se efectua ninguna acción.
      
      'Si el string x1 es nulo se inicializa el LCD y se sale.
  
        if x1="" then
        'Si el string x1 es nulo inicializa el LCD y sale. 
        iniens
        jsr inilcd
        finens
        goto fuera
        endif
     
        if ren<1 or ren>2 then
        goto fuera
        endif

        if col<1 or col>16 then
        goto fuera
        endif

        if ren=1 then
        posdesp~=col-129
        else
        posdesp~=col-65
        endif
        
        num$=x1
        gosub despstr



        goto fuera 

        iniens

'''''''''''''''''''''''''''''''''''''''''''''''
'                                             '
'           ruts_sw_lcd_sh32_20mhz            '
' INICIALIZACIÓN DE DESPLEGADO Y RUTINAS      '
' ELEMENTALES DE ESCRITRURA DE COMANDOS,      '
' DATOS Y TEXTO A RENGLÓN.                    '
' PARA LA INTERFAZ DE LCD DE LA TARJETA       '
' MINICON_08SH. (MCU MC9S08SH32).             '
' PARA LCD de 4x20,2x16,1x16                  '
' Supone LCD conectado a líneas pta7 a pta2   '
' del puerto A del MCU.                       '
'                                             '
'(Emplea las localidades de RAM $80,$81 y $82)'
'                                             '
'                                             '
' Adaptada para     fbus=20MHz                '
' Subrutina 'copiadis' adecuada para 16       '
' columnas.                                   '
' Contiene habilitación para caracteres de    '
' lengua española (áéíóúñüÑ).                 '
'                                             '
'       (adecuado para LCD's JHD..)           ' 
'        POR: ANTONIO SALVÁ CALLEJA           '
'             MARZO  DE 2018                  '
'                                             '
''''''''''''''''''''''''''''''''''''''''''''''' 

contcar equ $80
contgcgram equ $81
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

portlcd equ $04 'LCD conectado a PTCD
ddrportlcd equ $05

inilcd:     psha
            lda #$fc
            sta ddrportlcd  '$04 ' ptb7 a ptb2 son salidas
            jsr ret5m 'espera para ejecución autónoma aprox 20 ms > 15 ms
            jsr ret5m
            jsr ret5m
            jsr ret5m
            lda #$30
            bsr escom8
            jsr ret5m
            bsr escom8
            jsr ret100m  'espera de más de 100 milisegundos
            jsr ret5m
            bsr escom8
  
            lda #$20
            bsr escom8 'cambio a ducto de datos de 4 bits

            lda #$28 
            bsr escom4
            lda #$0c 
            bsr escom4 'enciende display
            lda #$01
            bsr escom4 'limpia display
            lda #$06
            bsr escom4

            jsr cargagcgram
'''' fin de inicialización de display ''''''''''
'            jmp brop
            pula
            rts

            
escom8:     psha
            and #$f0 'los cuatro bits más significativos quedan en nibble alto de A
 
            sta portlcd  '$00
            bclr 2,portlcd '$00 'rs<----0
            bset 3,portlcd '$00 'Ed<----1
'            bsr ret500 'espera aprox 2000 microsegundos
'            bsr ret500
'            bsr ret500  
'            bsr ret500

'            bsr ret500
'            bsr ret500  
'            bsr ret500

            mov #$23,contret  'espera aprox 2000 microsegundos
oppp:       bsr ret500
            dec contret
            bne oppp           


            


            bclr 3,portlcd  '$00 'Ed<----0
            pula
            rts

escdat8:    psha
            and #$f0 'los cuatro bits más significativos quedan en nibble alto de A
            sta portlcd  '$00
            bset 2,portlcd '$00 'rs<----1
            bset 3,portlcd '$00 'Ed<----1
'            bsr ret500 'espera aprox 2000 microsegundos
'            bsr ret500
'            bsr ret500
'            bsr ret500

'            bsr ret500
'            bsr ret500  
'            bsr ret500
'            bsr ret500

            mov #$23,contret  'espera aprox 2000 microsegundos
oppp2:      bsr ret500
            dec contret
            bne oppp2 
           

            


            bclr 3,portlcd '$00 'Ed<----0
            bclr 2,portlcd  '$00 'rs<----0
            pula
            rts

escdat4:   psha
           cmp #$7f
           bls sigg1
asciiext:  bsr prasciiext 'Si el caracter es asciiext se tiene que 
'                          cambiar su código por el asociado con lo que se cargó 
'                          en la cgram al inicializarse. Los códigos especiales 
'                          van del 0 al 7 como a continuacón se indica:
'                          
'                          $00-->á
'                          $01-->é
'                          $02-->í
'                          $03-->ó
'                          $04-->ú
'                          $05-->ñ
'                          $06-->ü
'                          $07-->Ñ
                             
sigg1:     bsr escdat8
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

''' subrutinas de retardo auxiliares @ fbus=4MHz '''

' subrutina de retardo de aprox 100 milisegundos
ret100m:    pshx
            ldx #$64   '14
otroret5m:  bsr ret5m
            decx
            bne otroret5m
            pulx
            rts
         

' subrutina de retardo de aprox 5 milisegundos
ret5m:      pshx
            ldx #$64  '14  '0a
otroret500: bsr ret500
            decx
            bne otroret500
            pulx
            rts
       
' Subrutina de retardo de aprox 100 microsegundoa   @ fbus=4Mhz
ret100:      pshx
             nop
             nop
             nop
             ldx #$4c '2d  ' retardo Tr(x)=(18+5x)'Te

vv:          nop
             decx
             bne vv
             pulx
             rts


' Subrutina de retardo de aprox 250 microsegundoa   @ fbus=4MHz
ret500:      pshx
             nop
             nop
             nop
             ldx #$c4   'f2  ' retardo Tr(x)=(18+5x)'Te

vv1:         nop
             decx
             bne vv1
             pulx
             rts

''''''  Subrutina  copiadis
'''     Copia 16 caracteres a renglon de display contenidos a partir de dir 
'''     apuntada por HX.
'''     para primer renglón ACCA debe llegar con $80, 
'''     para segundo renglón ACCA debe llegar con $C0 
'''     para tercer  renglón ACCA debe llegar con $94 
'''     para cuarto renglón ACCA debe llegar con $d4 

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


cargagcgram:  psha
              pshh
              pshx

              lda #$40 'Posiciona para origen de cgram
              jsr escom4 
              mov #$40,contgcgram
              ldhx #aminacen 

otradircg:    lda ,x
              jsr escdat4
              aix #$01
              dec contgcgram
              bne otradircg

              pulx
              pulh
              pula
              rts

prasciiext: cmp #ascamina
            beq fuegamina

            cmp #ascemina
            beq fuegemina

            cmp #ascimina
            beq fuegimina

            cmp #ascomina
            beq fuegomina

            cmp #ascumina
            beq fuegumina

            cmp #asceniemin
            beq fuegeniemin

            cmp #ascumindier
            beq fuegumindier

            cmp #asceniemay
            beq fuegeniemay


            bra salgprasciiext

fuegamina:   lda #$00
             bra salgprasciiext
fuegemina:   lda #$01
             bra salgprasciiext
fuegimina:   lda #$02
             bra salgprasciiext
fuegomina:   lda #$03
             bra salgprasciiext
fuegumina:   lda #$04
             bra salgprasciiext
fuegeniemin: lda #$05
             bra salgprasciiext
fuegumindier: lda #$06
              bra salgprasciiext

fuegeniemay: lda #$07

salgprasciiext: rts




aminacen:    db $02,$04,$0e,$01,$0f,$11,$0f,$00
eminacen:    db $02,$04,$0e,$11,$1f,$10,$0e,$00
iminacen:    db $02,$04,$00,$0c,$04,$04,$0e,$00
ominacen:    db $02,$04,$0e,$11,$11,$11,$0e,$00
uminacen:    db $02,$04,$11,$11,$11,$13,$0d,$00
eniemin:     db $0e,$00,$16,$19,$11,$11,$11,$00
umindier:    db $11,$00,$11,$11,$11,$13,$0d,$00
eniemayacen: db $0e,$00,$11,$19,$15,$13,$11,$00 
 
'amayacen:    db $02,$04,$0e,$11,$1f,$11,$11,$00          
'amayacen2:    db $02,$04,$0e,$11,$11,$1f,$11,$00 
'emayacen:    db $02,$04,$1f,$10,$1c,$10,$1f,$00
'imayacen:    db $02,$04,$0e,$04,$04,$04,$0e,$00
'omayacen:    db $07,$0e,$11,$11,$11,$11,$0e,$00
'umayacen:    db $02,$04,$11,$11,$11,$11,$0e,$00 
'umaydier:    db $11,$00,$11,$11,$11,$11,$0e,$00 


        finens

'Subrutina despstr
'Coloca en el LCD al string num$
'Antes de invocar:
'num$<--string a colocar en LCD
'posdesp~<--byte comando de posición inicial de colocación.
'Usa la variable tipo byte lstr~,la cual retorna con valor cero.
 


despstr:

         lstr~ = len(num$)

          iniens

          lda num$
          psha
          pulh
          ldx num$+1 'h:x<--dirección inicial de num$ en memoria.
          lda posdesp~
          jsr escom4
yuopp:    lda ,x
          jsr escdat4
          aix #$01
          lda lstr~
          deca 
          sta lstr~       
          bne yuopp

          finens

          return

fuera:





'     end_sub
          iniens
           pulx
           pulh
           sthx  var#topmem
           pulx
           pulh
           sthx  var#dirultdesc
           pulx
           pulh
           sthx  var#dirinistr
           pulx
           pulh
           sthx  apun*
           pula
           pulx
           pulh
           rts
          finens

