
'Programa semaforo_aut.b
'Valida un semáforo de seis luces,
'usa el procedimiento tipo sub retms(n).
'Configurado para ejecución autónoma.
 
defvarbptr portsem &h4 'Puerto de control es ptcd
defvarbptr ptcdd &h5
defvarbptr sopt1 &h1802

   sopt1=&h21 'Se deshabilita COP y se habilita pin de reset.
   ptcdd = &h3f 'pta5 a pta0 son salidas

  end_codini 'Fin del código de inicialización.

  def_sub main()

    while 1
 
    portsem=&h0c
    retms(30000)
    retms(30000)
    portsem=&h14
    retms(5000)
    portsem=&h21
    retms(30000)
    retms(30000)
    portsem=&h22
    retms(5000)
    
    wend


  end_sub
 
#include "j:\hcs08\mi_retms.bib"
 
  