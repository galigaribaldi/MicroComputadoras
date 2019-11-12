
ptcd equ $04
ptcdd equ $05


                 org $0100

            lda #$ff
            sta ptcdd ;ptcd es salida
            clra

ciclo:      sta ptcd
            inca
            jsr ret1seg
            bra ciclo

ret1seg:    psha
            lda #$28
otro:       jsr ret25ms
            deca
            cmp #$00
            bne otro
            pula
            rts




ret25ms:    pshh
            pshx
            ldhx #$c34d
vuelta:     nop
            nop
            aix #$ff
            cphx #$0000
            bne vuelta
            nop
            pulx
            pulh
            rts


           
 

 