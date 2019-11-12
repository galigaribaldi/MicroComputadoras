'** Código ajustado de la sub printlcd16x2sh **

dim x1 as string
dim ren as byte
dim col as byte

'ini##dirprocs
     iniens
main  equ $0000
printlcd16x2sh  equ $0000
     finens
'fin##dirprocs



'*  e:\bibs_aida08\printlcdsh_fwr.bib
'ini##cod


'**** INICIO DE CAPTURA VARIABLES ARGUMENTO DESDE ZONA DEL STACK ****  

        l..str~=0
        tesdir..str%=0  

        iniens

        ldhx $0E,sp 'Captura dir de vararg (tipo string)

        lda $02,x   
        sta l..str~ 
        lda ,x
        sta tesdir..str%
        lda $01,x
        sta tesdir..str%+1 

        finens
       
'.....................................
        mi..ascii%=0
       ' nnstr=""
      x1 = ""                                                                      'nulstr

        iniens
        lda l..str~
        beq fuera..
        finens

       for i..~=1 to l..str~

         iniens 
         ldhx tesdir..str%
         lda ,x
         sta mi..ascii%+1
         aix #$01
         sthx tesdir..str%
         finens

       'nnstr=nnstr+chr$(mi..ascii%)
      x1 = x1 +  chr$(mi..ascii%)

                                              'asigvarstr


        next i..~
fuera..:

        iniens
        ldhx $10,sp 'Captura dir de vararg (tipo ent1by)
        lda ,x
        sta ren                                                 
        finens


        iniens
        ldhx $12,sp 'Captura dir de vararg (tipo ent1by)
        lda ,x
        sta col                                                 
        finens

'**** FIN DE CAPTURA DE VARIABLES ARGUMENTO ****


