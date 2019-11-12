'** Código ajustado de la sub main **

'ini##dirprocs
     iniens
main  equ $804A
printlcd16x2sh  equ $82A6
     finens
'fin##dirprocs


'ini##cod


'**** INICIO DE CAPTURA VARIABLES ARGUMENTO DESDE ZONA DEL STACK ****  
'**** FIN DE CAPTURA DE VARIABLES ARGUMENTO ****


'ini##cod_original

  iniens 
  jsr lee#car
  finens

'**    printlcd16x2sh("",1,1) 'Se inicializa el LCD
     varaux..1$ = ""
     varaux..2~ = 1
     varaux..3~ = 1
'<<<  printlcd16x2sh(varaux..1$,varaux..2~,varaux..3~)
          iniens
        ldhx #varaux..3~
        pshx
        pshh
        ldhx #varaux..2~
        pshx
        pshh
        ldhx #varaux..1$
        pshx
        pshh
        jsr printlcd16x2sh
        ais #$06
          finens
' Fin del código asociado con la sentencia que involucra a la sub printlcd16x2sh >>> 


  while 1


 

  input "Dar texto a colocar en LCD,texto = ",texto$
  input "Dar renglón,renglón = ",rn~
  input "Dar columna,columna = ",colu~

'**  printlcd16x2sh(texto$,rn~,colu~)
     varaux..1$ = texto$
     varaux..2~ = rn~
     varaux..3~ = colu~
'<<<  printlcd16x2sh(varaux..1$,varaux..2~,varaux..3~)
          iniens
        ldhx #varaux..3~
        pshx
        pshh
        ldhx #varaux..2~
        pshx
        pshh
        ldhx #varaux..1$
        pshx
        pshh
        jsr printlcd16x2sh
        ais #$06
          finens
' Fin del código asociado con la sentencia que involucra a la sub printlcd16x2sh >>> 


  print "Oprimir una tecla"

  iniens 
  jsr lee#car
  finens
   '               1234567890123456
'**   printlcd16x2sh("                ",rn~,1)
     varaux..1$ = "                "
     varaux..2~ = rn~
     varaux..3~ = 1
'<<<  printlcd16x2sh(varaux..1$,varaux..2~,varaux..3~)
          iniens
        ldhx #varaux..3~
        pshx
        pshh
        ldhx #varaux..2~
        pshx
        pshh
        ldhx #varaux..1$
        pshx
        pshh
        jsr printlcd16x2sh
        ais #$06
          finens
' Fin del código asociado con la sentencia que involucra a la sub printlcd16x2sh >>> 





  wend






'     end_sub
          iniens
           pulx
           pulh
           sthx  var#topmem
           pulx
           pulh
           sthx  var#dirultdesc
           pulx
           pulh
           sthx  var#dirinistr
           pulx
           pulh
           sthx  apun*
           pula
           pulx
           pulh
           rts
          finens

