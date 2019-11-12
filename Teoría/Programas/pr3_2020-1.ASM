












ed1 equ $a3
ed2 equ $00
ed3 equ $0f
ed4 equ $f0 
ptcd equ $04
ptcdd equ $05

			org $0100

		mov #$ff,ptcdd ;ptcd es salida

loop: 	mov #ed1,ptcd
		jsr ret500ms
		jsr ret500ms

		mov #ed2,ptcd
		jsr ret500ms
		
		mov #ed3,ptcd
		jsr ret500ms
		jsr ret500ms
		jsr ret500ms
		jsr ret500ms

		mov #ed4,ptcd
		jsr ret500ms
		jsr ret500ms

		bra loop




ret500ms:    psha
            lda #$14
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

