


        end_codini

 def_sub main()

  iniens 
  jsr lee#car
  finens

    printlcd16x2sh("",1,1) 'Se inicializa el LCD

  while 1


 

  input "Dar texto a colocar en LCD,texto = ",texto$
  input "Dar renglón,renglón = ",rn~
  input "Dar columna,columna = ",colu~

  printlcd16x2sh(texto$,rn~,colu~)

  wend


 end_sub

#include "e:\bibs_aida08\printlcdsh_fwr.bib"


 