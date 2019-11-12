' Programa ejemplo en BASIC compilable con MINIBAS8A.
' Ejecutable en un MCU MC9S08SH32 habilitado
' como dispositivo CHIPBAS8SH.
' Este programa puede ejecutarse de manera autónoma.

' Mide la velocidad de un movil que pasa entre dos sensores
' de paso, separados por una distancia especificada en metros.
' Se usa la instancia de interrupción por overflow del contador
' del temporizador uno.

' Se supone que los sensores generan un pulso verificado en bajo,
' al detectarse el paso del movil.
' El primer sensor estaría conectado al bit pta1 del puerto A.
' El segundo sensor estaría conectado al bit pta0 del puerto A.
' Escrito por: Antonio Salvá Calleja
' Fecha: Abril/6/2016


defvarbptr tpm1sc   &h20
defvarbptr tpm1modh &h23
defvarbptr tpm1modl &h24
defvarbptr ptad     &h0
defvarbptr ptape    &h1840
defvarbptr sopt1    &h1802


              sopt1 = &h21 ' Deshabilita COP

              iniens
tpm1sc@ equ $20
ptad@   equ $00

              jsr lee#car ' Esto equivale a un getchar(); de C
              finens

              input"Dar distancia entre sensores en metros-->",dentse
              
              
              ptape=&h3 'Pullups en bits 1 y 0 del puerto A
              tpm1modh=&h4e
              tpm1modl=&h1f 'modulo de cuenta=19999,para que Tovf=1 ms,con pe=1.

              tpm1sc=&h8 'toie<--0,clksb:clksa<--01, pe=1.
              
              iniens
              cli
              finens
  
              while 1

              contms%=0 'Inicializa contador de milisegundos 

              print "Espera paso por sensor 1" 

              iniens
espsens1:     brset 1,ptad@,espsens1
              bset 6,tpm1sc@  'toie<--1 
              finens  
   
              print "El movil pasó el sensor 1"

              iniens
espsens2:     brset 0,ptad@,espsens2
              bclr 6,tpm1sc@  'toie<--0 
              finens

              print "El movil pasó el sensor 2"

              vprom=3600.*dentse/contms%

   
              print

              print "La velocidad promedio del movil fue ";vprom;" Km/hr"

              print

              print "oprimir cualquier tecla para hacer otra medición"

              
              iniens
              jsr lee#car
              finens

              cls

              wend

servovf:
             glip
             
             byaux~=tpm1sc
             tpm1sc=tpm1sc and &h7f 'tof<--0

             contms% = contms% + 1


             relip

             retint

       dataw &hd7e8 servovf ' Colocación de vector de usuario 
                            ' asociado con la instancia de interrupción
                            ' de overflow del temporizador 1

       dataw &hd7fe &h8000  ' Colocación de vector de reset de la aplicación (VRA) 
 

  


   

   



