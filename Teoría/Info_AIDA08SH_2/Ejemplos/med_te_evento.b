''********** Programa med_te_evento *************
'Mide el tiempo que transcurre entre la opresión 
'de dos botones denominados B0 y B1 ligados 
'respectivamente con los bits pta0 y pta1 del MCU.
'B0 es el botón de arranque del contador de tiempo.
'B1 es el botón de paro del contador de tiempo.
'Se usa la interupción de sobreflujo del temporizador 1
'del MCU de modo que el requerimiento de interrupción 
'asociado se de cada milisegundo.

'Por: Antonio Salvá Calleja
'Fecha: 22/abril/2016

' ***** CÓDIGO DE INICIALIZACIÓN *****
 
'Declaraciones de variables globales especiales de usuario.
defvarbptr ptad &h0
defvarbptr ptape &h1840
defvarbptr tpm1sc &h20
defvarbptr tpm1modh &h23
defvarbptr tpm1modl &h24
'................................................
'Declaración de la variable global contms que
'será el contador de milisegundos.
dim contms as integer
'.................................................

 ptape=&h3 'pta0 y pta1 tienen 'pull-up'
 
 tpm1sc=&h08 'pe=1,toie=0
 tpm1modh=&h4e 'Tovf = 1 ms
 tpm1modl=&h1f
 

     iniens 
     cli     'Se habilitan globalmente interrupciones
     finens

   end_codini 'Fin de código de inicialización

   def_sub main()

     iniens
ptad@ equ $00
tpm1sc@ equ $20
      jsr lee#car
     finens


     while 1
     contms=0

     print "En espera de inicio de evento"
     print

     iniens
espb0: brset 0,ptad@,espb0
       bset 6,tpm1sc@ 'toie <-- 1
     finens

     print "Inició evento"

     iniens
espb1: brset 1,ptad@,espb1
       bclr 6,tpm1sc@ 'toie <-- 0
     finens

     print "Finalizó evento"

     if contms<0 then
     'Si hubo saturación en el tiempo,
     'se notifica esto al usuario.  
     print "La duración del evento rebasó los 30 segundos"
     print 
     else
     segs%= contms/1000
     milisegs%= contms mod 1000
     print "Te = ";segs%;" segundos y ";milisegs%;" milésimas"
     print
     endif

     print "Oprimir una tecla para efectuar otra medición"
    
     iniens
     jsr lee#car
     finens

    wend

   end_sub
      
   def_subint servovft1()
      dim byaux as byte

       glip 'Se requiere porque hay código BASIC 
            'en la subrutina deservicio.

      'Código para regresar a cero la bandera TOF
      byaux = tpm1sc
      tpm1sc = tpm1sc and &h7f 'TOF <-- 0
      '..........................................
      contms=contms+1 'Incrementa contador de milisegundos

      if contms>30000 then
       'Si el tiempo es mayor que 30 segundos,
       'testifica esto asignando un valor negativo,
       'y deshabilita localmente la interrupción.
       contms=-1
       tpm1sc = tpm1sc and &hbf 'toie <-- 0
      endif

      relip 'Se requiere porque hay código BASIC
            'en la subrutina deservicio.

    end_subint
 
int#(011) servovft1 'Colocación de vector asociado

