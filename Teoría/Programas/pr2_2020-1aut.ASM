
ptcd equ $04
ptcdd equ $05

sopt1  equ $1802

                 org $8000

            lda #$21
            sta sopt1 ;Deshabilita COP (Watch dog)


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

           org $d7fe
           dw $8000



           
 

 