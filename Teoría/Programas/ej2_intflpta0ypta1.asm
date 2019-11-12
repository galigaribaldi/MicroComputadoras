ptcd		      equ $04	    ;iguala ptcd al valor en memoria 0x0004
ptcdd		      equ $05         ;iguala ptcdd al valor en memoria 0x0005
ptape             equ $1840
ptasc             equ $1844
ptaps             equ $1845
ptaes             equ $1846 
ptad              equ $00

		      org $8000       ;dirección inicial de carga del programa (RAM)
		      lda #$ff        ;a <-- $ff
		      sta ptcdd       ;se activa el puerto C como salida

                  
                  lda #$02
                  sta ptasc ;ptaie <-- 1


                  lda #$03
                  sta ptaps       ;Flanco de bajada en pta0 o pta1 detona interrupción
;                                  esto porque ptaes de dejará en su default

                  sta ptape       ;pta0 y pta1 tienen pull-up
                  


                  cli

                  clra
lazo:             sta ptcd
                  inca
                  jsr ret1seg
                  bra lazo

servfl:            lda ptasc
                   ora #$04
                   sta ptasc       ;ptaack <-- 0,ptaif <-- 0

                   brclr 0,ptad,fuepta0
fuepta1:           mov #$ff,ptcd
                   bra retar
fuepta0:           mov #$aa,ptcd
retar:             jsr ret1seg
                  
                  rti





ret1seg:                psha            ;manda el acumulador a al SP
			lda #$28        ;a <-- $28
llamaret2:		jsr ret25ms     ;salta a ret25ms
			deca		    ;a = a-1
			cmp #$00	    ;comprara con $00
			bne llamaret2   ;a no igual $00 salta a llamaret2
			pula		    ;jala el acumulador a del SP
			rts		    ;regresa a subrutina

ret25ms:          pshh		    ;manda el acumulador h al SP
		 	pshx            ;manda el acumulador x al SP
			ldhx #$C34D     ;valor de retardo para 25 ms
vuelta:		nop             ;tiempo muerto
			nop             ;tiempo muerto
			aix  #$ff	    ;hix = hix-1
			cphx #$0000     ;compara con $00
			bne  vuelta     ;hix no igual $00 salta a vuelta
			nop             ;tiempo muerto
			pulx            ;jala el acumulador x del SP
			pulh            ;jala el acumulador h del SP
                  rts		    ;regresa a subrutina

                  org $d7d6
                  dw servfl
 

                


