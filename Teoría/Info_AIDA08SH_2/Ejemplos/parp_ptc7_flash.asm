ptcd  equ $04
ptcdd equ $05
    
               org $8000
              
                bset 7,ptcdd ; ptc7 es salida.

ciclo:          bset 7,ptcd ; ptc7 <-- 1
                bsr ret25ms
                bclr 7,ptcd ; ptc7 <-- 0
                bsr ret25ms
                bra ciclo

;Subrutina de retardo, Tr = (25+10Xr)Tb
ret25ms:        pshh
                pshx
                ldhx #$c34d
vuelta:         nop
                nop
                aix #$ff
                cphx #$0000
                bne vuelta
                pulx
                pulh
                rts

                


