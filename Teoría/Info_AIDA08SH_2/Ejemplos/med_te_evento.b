''********** Programa med_te_evento *************
'Mide el tiempo que transcurre entre la opresi�n 
'de dos botones denominados B0 y B1 ligados 
'respectivamente con los bits pta0 y pta1 del MCU.
'B0 es el bot�n de arranque del contador de tiempo.
'B1 es el bot�n de paro del contador de tiempo.
'Se usa la interupci�n de sobreflujo del temporizador 1
'del MCU de modo que el requerimiento de interrupci�n 
'asociado se de cada milisegundo.

'Por: Antonio Salv� Calleja
'Fecha: 22/abril/2016

' ***** C�DIGO DE INICIALIZACI�N *****
 
'Declaraciones de variables globales especiales de usuario.
defvarbptr ptad &h0
defvarbptr ptape &h1840
defvarbptr tpm1sc &h20
defvarbptr tpm1modh &h23
defvarbptr tpm1modl &h24
'................................................
'Declaraci�n de la variable global contms que
'ser� el contador de milisegundos.
dim contms as integer
'.................................................

 ptape=&h3 'pta0 y pta1 tienen 'pull-up'
 
 tpm1sc=&h08 'pe=1,toie=0
 tpm1modh=&h4e 'Tovf = 1 ms
 tpm1modl=&h1f
 

     iniens 
     cli     'Se habilitan globalmente interrupciones
     finens

   end_codini 'Fin de c�digo de inicializaci�n

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

     print "Inici� evento"

     iniens
espb1: brset 1,ptad@,espb1
       bclr 6,tpm1sc@ 'toie <-- 0
     finens

     print "Finaliz� evento"

     if contms<0 then
     'Si hubo saturaci�n en el tiempo,
     'se notifica esto al usuario.  
     print "La duraci�n del evento rebas� los 30 segundos"
     print 
     else
     segs%= contms/1000
     milisegs%= contms mod 1000
     print "Te = ";segs%;" segundos y ";milisegs%;" mil�simas"
     print
     endif

     print "Oprimir una tecla para efectuar otra medici�n"
    
     iniens
     jsr lee#car
     finens

    wend

   end_sub
      
   def_subint servovft1()
      dim byaux as byte

       glip 'Se requiere porque hay c�digo BASIC 
            'en la subrutina deservicio.

      'C�digo para regresar a cero la bandera TOF
      byaux = tpm1sc
      tpm1sc = tpm1sc and &h7f 'TOF <-- 0
      '..........................................
      contms=contms+1 'Incrementa contador de milisegundos

      if contms>30000 then
       'Si el tiempo es mayor que 30 segundos,
       'testifica esto asignando un valor negativo,
       'y deshabilita localmente la interrupci�n.
       contms=-1
       tpm1sc = tpm1sc and &hbf 'toie <-- 0
      endif

      relip 'Se requiere porque hay c�digo BASIC
            'en la subrutina deservicio.

    end_subint
 
int#(011) servovft1 'Colocaci�n de vector asociado

