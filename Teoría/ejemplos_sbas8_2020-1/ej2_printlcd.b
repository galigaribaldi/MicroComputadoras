


        end_codini

 def_sub main()

  iniens 
  jsr lee#car
  finens

    printlcd16x2sh("",1,1) 'Se inicializa el LCD

  while 1


 

  input "Dar texto a colocar en LCD,texto = ",texto$
  input "Dar rengl�n,rengl�n = ",rn~
  input "Dar columna,columna = ",colu~

  printlcd16x2sh(texto$,rn~,colu~)

  print "Oprimir una tecla"

  iniens 
  jsr lee#car
  finens
   '               1234567890123456
   printlcd16x2sh("                ",rn~,1)




  wend


 end_sub

#include "e:\bibs_aida08\printlcdsh_fwr.bib"


 