 ' Programa que resuelve una ecuación cuadrática de la forma: a*x^2 + b*x +c =0
          while 1
              iniens
               jsr lee#car 'Esto equivale a un getchar(); en C.
              finens
dara:       input "a=",a                                                                                                                                                                                                                             
            if a = 0. then
            print "El coeficiente (a) debe ser diferente de cero"
            goto dara
            endif
            input "b=",b
            input "c=",c
            dis = b * b - 4. * a * c
            if dis < 0. then
            print "RAICES COMPLEJAS"
            pim = sqr(-dis) / (2. * a)
            pre = -b / (2 * a)
            print "r1="; pre; "+ j"; pim
            print "r2="; pre; "- j"; pim
            else    
            print "RAICES REALES "
            radi = SQR(dis) / (2 * a)
            rep = -b / (2 * a)
            r1 = rep + radi
            r2 = rep - radi
            print "r1="; r1
            print "r2="; r2
            endif
            print " OPRIMIR UNA  TECLA"            
          wend



     




























