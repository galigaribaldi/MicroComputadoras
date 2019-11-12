
* Programa ECO1SH32
* Ejecutable en RAM del MCU MC9S08SH32
* Recibe un byte por el puerto serie (SCI)
* despu�s lo transmite por el mismo puerto,
* repit�ndos endefinidamente estas acciones.

* Por: Antonio Salv� Calleja
* Fecha: abril 22,2016
   
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f
  
            org $0100

        ldhx #$0082
        sthx scibdh
        mov #$0c,scic2

ciclo:  bsr rxsci ;Recibe byte.
        bsr txsci ;Tranmite byte recibido.
        bra ciclo

** SUBRUTINA RXSCI DE RECEPCI�N SERIE **
** Al invocarse se pasa a un lazo de espera
** por la recepci�n de un byte en el puerto
** serie del MCU MC9S08SH32.
** Al retornar:
** a <-- byte recibido

rxsci: brclr 5,scis1,rxsci
       lda scid
       rts
  

  

** SUBRUTINA TXSCI DE TRANSMISI�N SERIE **
** por el puerto serie del MCU MC9S08SH32.
** Antes de invocar:
** a <-- byte a transmitir
** Al retornar:
** ya se habra transmitido el byte implicado

txsci: brclr 6,scis1,txsci
       sta scid
       rts

   