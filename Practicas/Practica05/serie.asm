.data
	mensaje1: .asciiz "Introduce el número de iteraciones: \n"
	mensaje2: .asciiz "la serie resultante es: \n"
	cuatro: .float 4.0
	uno: .float  1.0
	tres: .float 3.0
	zero: .float 0.0
.text
	main:
		#Pide el primer número
		li $v0, 4
		la $a0, mensaje1
		syscall 
		
		li $v0, 5
		syscall 
		
		#Lo almacena en t0
		move $s0, $v0 #a
		
		#Se hace la llamada a la función
		jal serie
		
		#Se imprime el mensaje de respuesta
		li $v0, 4
		la $a0, mensaje2
		syscall
		
		#Se imprime el valor de la serie
		li $v0 2
		mov.s $f12 $f3
		syscall
		
		#Terminamos la ejecución
		li $v0, 10
		syscall
		
	serie:
		li $s1 0 #n=0
		li $s4 1 #const 1
		s.s $f3 zero #suma=0
		for: 
			#(n > m)
			bgt $s1 $s0 end
			mul $s2 $s1 4 #4*n
			add $s3 $s2 1 #4n + 1
			add $s5 $s2 3 #4n + 3
			mtc1 $s3 $f1 #cast to float 4n + 1
			cvt.s.w $f1 $f1
			mtc1 $s5 $f6 #cast to float 4n + 3
			cvt.s.w $f6 $f6
			mtc1 $s4 $f4 #cast to float 1
			cvt.s.w $f4 $f4
			div.s $f2 $f4 $f1 # 1 / 4n + 1
			div.s $f6 $f4 $f6 # 1 / 4n + 3
			sub.s $f7 $f2 $f6 #(1 / 4n + 1) - (1 / 4n + 3)
			add.s $f3 $f3 $f7 #sum+= (1 / 4n + 1) - (1 / 4n + 3)
			add $s1 $s1 1 #n++
    			j for 
		end:

		#Regresamos a la función anterior
		jr $ra