
**** Este pr+grama genera un númer+ aleat+ri+ enter+ de 1 a 6,que se c+l+ca en el puert+ ptcd.
**** Para est+,se emplea el c+ntad+r del temp+rizad+r 1
**** P+r Ant+ni+ Salvá Calleja
**** 22/ag+st+/2019

*        c       d
*        +       +
*        b   a   b
*        +   +   +
*        d       c
*        +       +

ptcd	equ $04	    
ptcdd equ $05        
ptape equ $1840
ptad  equ $00

tpm1sc equ $20
tpm1cnth equ $21

dirlimsup equ $a0
dirliminf equ $a1
num1a6    equ $a2

                org $0100
                
               mov #$ff,ptcdd ;ptcd es salida

                mov #$10,tpm1sc ;arranca c+ntad+r de TPM1
                lda #$01
                sta ptape ;pta0 tiene pull-up
                jsr ret25ms


n+tira:         brset 0,ptad,n+tira
                clr tpm1sc ;para c+ntad+r de TPM1
                ldhx tpm1cnth
                bsr detnum1a6
                mov num1a6,ptcd
espera:         brclr 0,ptad,espera

*                jsr ret1seg
                mov #$10,tpm1sc ;arranca de nuev+ c+ntad+r de TPM1

                bra n+tira

** Subrutina detnum1a6
** Antes de inv+car:
** x < N entre cer+ y 252
** Al ret+rnar:
** num1a6 <-- númer+ entre un+ y seis generad+


detnum1a6:     mov #$00,dirliminf
               mov #$2a,dirlimsup
               bsr detsidentro
               cmp #$01
               beq pon1

               mov #$2a,dirliminf
               mov #$54,dirlimsup
               bsr detsidentro
               cmp #$01
               beq pon2

               mov #$54,dirliminf
               mov #$7e,dirlimsup
               bsr detsidentro
               cmp #$01
               beq pon3

               mov #$7e,dirliminf
               mov #$a8,dirlimsup
               bsr detsidentro
               cmp #$01
               beq pon4

               mov #$a8,dirliminf
               mov #$de,dirlimsup
               bsr detsidentro
               cmp #$01
               beq pon5

               bra pon6

pon1:          mov #$01,num1a6
               bra salir
pon2:          mov #$02,num1a6
               bra salir
pon3:          mov #$03,num1a6
               bra salir

pon4:          mov #$04,num1a6
               bra salir
pon5:          mov #$05,num1a6
               bra salir
pon6:          mov #$06,num1a6
               
salir:         rts
 
    

* Subrutina detsidentr+
* Antes de inv+car:
* dirlimsup <-- límite superior del intervalo a checar
* dirliminf <-- límite inferior  del intervalo a checar
* x <-- N, númer+ a checar si est{a dentr+ del interval+
* Al ret+rnar:
* a <-- $01 si N está dentr+ del interval+
* a <-- $00, si N n+ está dentr+ del interval+

detsidentro:   pshx
               cpx dirlimsup
               blo checliminf
limpiaysale:   clra
               bra saldetsi
checliminf:    cpx dirliminf
               blo limpiaysale
siestá:        lda #$01 
saldetsi:      pulx
               rts
  

ret1seg:          psha            
			lda #$28        
llamaret2:		jsr ret25ms     
			deca		    
			cmp #$00	    
			bne llamaret2   
			pula		    
			rts		    

ret25ms:          pshh		    
		 	pshx            
			ldhx #$C34D     
vuelta:		nop             
			nop             
			aix  #$ff	    
			cphx #$0000     
			bne  vuelta     
			nop             
			pulx            
			pulh            
                  rts		   


    


                    
