;**** Este programa supone fbus=20 MHz MHz *****



            org $8000

$include "j:\hcs08\mdam8a06.asm"


            lda #$c0
            ldhx #mitexto
            jsr copiadis
fin:        bra fin



;*              1234567890123456
mitexto:   fcc "  MINICON_08SH  " 
  
