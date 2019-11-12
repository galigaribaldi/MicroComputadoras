ptad equ $00
ptadd equ $01
ptbd  equ $02
ptbdd equ $03
ptcd  equ $04
ptcdd equ $05

                 org $0100

               
                mov #$ff,ptcdd

                clra

ciclo:          sta ptcd
                inca

                bsr ret10p
                
                bra ciclo

  
ret:        pshh
            pshx
            ldhx #$ffff
vv:         nop
            nop
            aix #$ff
            cphx #$0000
            bne vv
            pulx
            pulh
            rts

ret10p:     psha
            lda #$0a
otroret:    bsr ret
            deca
            bne otroret
            pula
            rts






  