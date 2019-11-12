
'Programa semaforo.b
'Valida un semáforo de seis luces,
'usa el procedimiento tipo sub retms(n)
 
defvarbptr portsem &h4 'Puerto de control es ptcd
defvarbptr ptcdd &h5

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
 
  def_sub retms(n as integer)

  'Este procedimiento genera una espera de n milisegundos,
  'se supone que la frecuencia del reloj de bus del MCU 
  'es 20 MHz.

    if n < 1 or n > 32766 then
    'Si 'n' no está en el rango apropiado
    'retorna sin generar un retardo. 
     exit_sub
    endif
  
        for i%=1 to n
        gosub ret1ms
        next i%

        exit_sub

ret1ms:
        iniens
        pshh
        pshx
        ldhx #$07cd
vuelta: nop
        nop
        aix #$ff
        cphx #$0000
        bne vuelta
        pulx
        pulh
        rts
        finens
       
   end_sub 

  