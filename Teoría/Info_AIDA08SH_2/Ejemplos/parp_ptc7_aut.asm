ptcd  equ $04
ptcdd equ $05
sopt1 equ $1802 
               org $8000
******* BLOQUE 1 **********
                lda #$21   ;Deshabilita COP y pin PTA5/IRQ/TCLK/RESET,
                sta sopt1  ;funciona únicamente como reset.

******* BLOQUE 2 (CÓDIGO PARA EJECUCIÓN AUTÓNOMA) *******
                bset 7,ptcdd ; ptc7 es salida
ciclo:          bset 7,ptcd ; ptc7 <-- 1
                bsr ret25ms
                bclr 7,ptcd ; ptc7 <-- 0
                bsr ret25ms
                bra ciclo
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

******* BLOQUE 3 (COLOCACIÓN DE DIRECCÖN DE ORIGEN)*******
                org $d7fe ;Coloca VRA 
                dw  $8000


