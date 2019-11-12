** Subrutina ret_n_ms
** Genera una espera de N milisegundos
** Fbus debe ser 20 MHz
** 0 <= N <= 65535
** (Si N=0 la espera sería 65.536 segundos)
** Antes de invocar:
** baN al stack, baN es el byte alto de N expresado en hexadecimal 
** bbN al stack, bbN es el byte bajo de N expresado en hexadecimal
** Después de retornar se debe sumar 2 al SP, esto es muy importante

ret_n_ms:   pshh
            pshx
            psha
            ldx $06,sp
            lda $07,sp
            psha
            pulh 
otroret1ms: jsr ret1ms
            aix #$ff
            cphx #$0000
            bne otroret1ms
            pula
            pulx
            pulh
            rts

ret1ms:     pshh
            pshx
            ldhx #$07cd
vuelta:     nop
            nop
            aix #$ff
            cphx #$0000
            bne vuelta
            pulx
            pulh
            rts
