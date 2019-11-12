' Programa ejemplo del curso de programaci�n de MCU's
' mc9s08gt60.
' Mide la velocidad de un movil que pasa entre dos sensores
' de paso, separados por una distancia especificada en metros.

' Se supone que los sensores generan un pulso verificado en bajo,
' al detectarse el paso del movil.
' El primer sensor estar�a conectado al bit ptbd3 del puerto B.
' El segundo sensor estar�a conectado al bit ptbd0 del puerto B.
' La velocidad medida se despliega en pantalla de consola y en
' en el rengl�n 1 del LCD.
' Por:Antonio Salv� Calleja, enero de 2012

defvarbptr tpm1sc   &h30
defvarbptr tpm1modh &h33
defvarbptr tpm1modl &h34
defvarbptr ptbd     &h4
defvarbptr ptbpe    &h5



              iniens
tpm1sc@ equ $30
ptbd@   equ $04
$include "e:\hc08\mdam8a05.asm"

              jsr lee#car
              finens

              input"Dar distancia entre sensores en metros-->",dentse
              
              
              ptbpe=&hf 'Pullups en bits 3 a 0 del puerto B
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
espsens1:     brset 3,ptbd@,espsens1
              bset 6,tpm1sc@  'toie<--1 
              finens  
   
              print "El movil pas� el sensor 1"

              iniens
espsens2:     brset 0,ptbd@,espsens2
              bclr 6,tpm1sc@  'toie<--0 
              finens

              print "El movil pas� el sensor 2"

              vprom=3600.*dentse/contms%

   
              print

              print "La velocidad promedio del movil fue ";vprom;" Km/hr"
              posdesp~=&h80
              num$="Vp="+str$(vprom)+" Km/hr"
              gosub despstr

              num$=" Km/hr"
              posdesp~=&h8a
              gosub despstr 
 
              print

              print "oprimir cualquier tecla para hacer otra medici�n"

              
              iniens
              jsr lee#car
              finens

'++++++++   Borra rengl�n 1 de LCD  ++++++++++
'                   1234567890123456
              num$="                "
              posdesp~=&h80
              gosub despstr 
'++++++++++++++++++++++++++++++++++++++++++++++

              cls

              wend

servovf:
             glip
             
             byaux~=tpm1sc
             tpm1sc=tpm1sc and &h7f 'tof<--0

             contms%=contms% + 1


             relip

             retint

'Subrutina despstr
'Coloca en el LCD al string num$
'Antes de invocar:
'num$<--string a colocar en LCD
'posdesp~<--byte comando de posici�n inicial de colocaci�n.
'Usa la variable tipo byte lstr~,la cual retorna con valor cero.
 


despstr:

         lstr~ = len(num$)



          iniens

          lda num$
          psha
          pulh
          ldx num$+1 'h:x<--direcci�n inicial de num$ en memoria.
          lda posdesp~
          jsr escom4
yuopp:    lda ,x
          jsr escdat4
          aix #$01
          lda lstr~
          deca 
          sta lstr~       
          bne yuopp

          finens

          return





             dataw &hdfee servovf

  


   

   



