	iniens
	jsr lee#car 'Esto equivale a un getchar(); de C
	finens

dardatos:	input "x1 = ",x1
		input "x2 = ",x2
		input "x3 = ",x3

		z1= 3.5+x1*x2
		z2= sqr(x1)+3./x2+x1
		Z3 = sqr(x1)
		

		print "3.5+x1*x2 = ",z1
		print "sqr(x1)+3./x2+x1 = ",z2
		print "sqr(";x1;")= ",z3
		print
		goto dardatos

 